//
//  HostChatVC.swift
//  Zyvo
//ravi kumar;
//  Created by ravi on 2/01/25.
//

import UIKit
import DropDown
import ISEmojiView
import TwilioConversationsClient
import AVFoundation
import MobileCoreServices
import UniformTypeIdentifiers
import IQKeyboardManagerSwift
import SDWebImage
import Photos
import Combine


class HostChatVC: UIViewController, UITextViewDelegate {
    var Message = ""
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var txtChat: UITextView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var view_ProfileImg: UIView!
    @IBOutlet weak var view_message: UIView!
    
    @IBOutlet weak var tbl_bottom_h: NSLayoutConstraint!
    
    @IBOutlet weak var viewBlock: UIView!
    @IBOutlet weak var viewSendMessage: UIView!
    
    @IBOutlet weak var btnDot: UIButton!
    var isBlockStatus : Int? = 0
    
    var isMuteStatus : Int? = 0
    
    var isArchiveStatus : Int? = 0
    
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = ChatDataViewModel()
    
    var dropDown = DropDown()
    
    var index : Int? = 0
    
    var SenderID = ""
    
    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var lbl_User: UILabel!
    @IBOutlet var borderV: [UIView]!
    let keyboardSettings = KeyboardSettings(bottomType: .categories)
    let user_id = UserDetail.shared.getUserId()
    var friend_id = ""
    var friend_identity = ""
    var friend_name = ""
    var friendImg = ""
    var serviceName = ""
    var user_img = ""
    var user_imgV = UIImage()
    var friend_imgV = UIImage()
    var timerToLast : Timer?
    // MARK:twilio
    //    var conversationsManager = QuickstartConversationsManager()
    var conversationsManager = QuickstartConversationsManager.shared.self
    var uniqueConversationName = ""
    var messages:Set<TCHMessage> = Set<TCHMessage>()
    var sortedMessages:[TCHMessage] = []
    var lastCell = 1
    
    //    var uploadingArray : [(msg:TCHMessageOptions,name:String,img:Data?)] = []
    var uploadingArray : [uploadStruce] = []
    
    var hostProfileImg = ""
    var guesttProfileImg = ""
    
    var hostName = ""
    var guestName = ""
    
    var favoriteStatus : Int? = 0
    
    var Arr = ["Mute","Report","Delete chat","Block","Archive"]
    
    // MARK:tableView
    let MyChatCellIdentifier = "ChatCell"
    
    let MyChatImgCellIdentifier = "ImgChatCell"
    
    @IBOutlet var bottomConstraintForKeyboard: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    private var token :NSKeyValueObservation?
    
    var backAction:(_ str : String,_ favStatus : String,_ muteStatus : String, _ archiveStatus : String ) -> () = { str,favStatus,muteStatus,archiveStatus  in }
    var onlineStatusTimer: Timer?
    private let placeholderText = "Type a message..."
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        
        bindVC()
        
        print(self.Message,"Message coming")
        imgProfile.makeCircular()
        imgProfile.contentMode = .scaleAspectFill
        
        self.lbl_User.text = self.guestName
        
        self.imgProfile.loadImage(from:self.hostProfileImg,placeholder: UIImage(named: "user"))
        
        IQKeyboardManager.shared.enable = false
        print(isBlockStatus ?? 0,"isBlockStatus")
        if (isBlockStatus ?? 0) == 0 {
            viewSendMessage.isHidden = false
            viewBlock.isHidden = true
        }  else if (isBlockStatus ?? 0) == 2 {
            viewSendMessage.isHidden = false
            viewBlock.isHidden = true
        } else {
            viewSendMessage.isHidden = true
            viewBlock.isHidden = false
        }
        if favoriteStatus == 1 {
            btnFavourite.setImage(UIImage(named: "staricon 1"), for: .normal)
        } else {
            btnFavourite.setImage(UIImage(named: "Group 1171276144"), for: .normal)
        }
        
        view_ProfileImg.layer.cornerRadius = view_ProfileImg.layer.frame.height / 2
        view_ProfileImg.layer.borderWidth = 3
        view_ProfileImg.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/266, alpha: 0.3).cgColor
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.layer.frame.height / 2
        self.imgProfile.contentMode = .scaleToFill
        
        view_message.layer.cornerRadius = view_message.layer.frame.height / 2
        view_message.layer.borderWidth = 1
        view_message.layer.borderColor = UIColor.lightGray.cgColor
        
        viewBlock.layer.cornerRadius = viewBlock.layer.frame.height / 2
        
        //self.tabBarController?.setTabBarHidden(true, animated: true)
        friend_identity = friend_id
        
        print(friend_identity,"friendidentity")
        self.conversationsManager.delegate = self
        self.setupTableview()
        self.keyboardNotifications()
        
        txtChat.delegate = self
        if let token = UserDefaults.standard.object(forKey: "twilioToken") as? String, self.conversationsManager.client == nil {
            self.conversationsManager.loginWithAccessToken(token) { (res) in
                self.getChat()
            }
        }else{
            self.getChat()
        }
        self.setUp()
        self.loadUserImage()
    }
    
    // Remove placeholder on edit
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtChat.text == placeholderText {
            txtChat.text = ""
            txtChat.textColor = .black
        }
    }
    // Add placeholder if empty
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtChat.text.isEmpty {
            txtChat.text = placeholderText
            txtChat.textColor = .lightGray
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkFriendOnlineStatus(friendIdentity: self.friend_id)

        // Start timer to periodically check online status
        onlineStatusTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.checkFriendOnlineStatus(friendIdentity: self.friend_id)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Invalidate timer when user leaves chat
        onlineStatusTimer?.invalidate()
        onlineStatusTimer = nil
    }
    
    func getChat() {
        self.conversationsManager.loadChat(uniqueConversationName: uniqueConversationName, friendIdentity: friend_identity)
    }
  
    func setUp() {
        
        var timesCount = 0
        timerToLast = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (tim) in
            if self.sortedMessages.count > 0 {
                let inde = IndexPath(row: 0, section: 0)
                let s = self.tableView.indexPathsForVisibleRows ?? []
                if s.contains(inde) {
                // self.tableView.reloadRows(at: s, with: .none)
                }
                timesCount = timesCount + 5
                if timesCount >= 20 {
                    timesCount = 0
                }
            }
        })
        if Message != "" {
            sendMessage(inputMessage: Message)
        }
    }
    
    func loadUserImage(){
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerToLast?.invalidate()
        timerToLast = nil
        
    }
    func setupTableview() {
        
        let cellNib = UINib(nibName: MyChatCellIdentifier, bundle: nil)
        
        let cellNib1 = UINib(nibName: MyChatImgCellIdentifier, bundle: nil)
        
        tableView!.register(cellNib1, forCellReuseIdentifier:MyChatImgCellIdentifier)
        
        tableView!.register(cellNib, forCellReuseIdentifier:MyChatCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
      //  tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));
        tableView.showsVerticalScrollIndicator = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
     //   checkFriendOnlineStatus(friendIdentity: friend_id)
        
//        conversationsManager.checkTwilioUserStatus(userId: friend_id) { str in
//            print(str, "yahu hai")
//        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    @IBAction func btnFavourite_Tap(_ sender: UIButton) {
        if (favoriteStatus ?? 0) == 0 {
            viewModel.apiForSetFavourite(senderId: self.SenderID , group_channel: self.uniqueConversationName , favorite: "1")
            
        } else {
            
            viewModel.apiForSetFavourite(senderId: self.SenderID , group_channel: self.uniqueConversationName , favorite: "0")
        }
    }
    @IBAction func btnSelectImage(_ sender: UIButton) {
        showImagePickerOptions()
    }
    
    
    @IBAction func btnblockChat_Tap(_ sender: UIButton) {
        
        if (isBlockStatus ?? 0) == 0 {
            viewModel.apiForBlockUser(senderId: self.SenderID , group_channel: self.uniqueConversationName , blockUnblock: "1")
        }
        
    }
    
    @IBAction func btnDot_Tapp(_ sender: UIButton) {
        
        self.index = sender.tag
        
        if isArchiveStatus == 0 {
            Arr[4] = "Archive"
        }
        if isArchiveStatus == 1 {
            Arr[4] = "Unarchive"
        }
        
        if isBlockStatus == 0 {
            Arr[3] = "Block"
        }
        if isBlockStatus == 1 {
            Arr[3] = "Unblock"
        }
        
        if isMuteStatus == 0 {
            Arr[0] = "Mute"
        }
        if isMuteStatus == 1 {
            Arr[0] = "Unmute"
        }
        dropDown.anchorView = sender // Anchor dropdown to the button
        dropDown.dataSource = Arr
        dropDown.direction = .bottom
        
        dropDown.backgroundColor = UIColor.white
        dropDown.cornerRadius = 10
        dropDown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        dropDown.layer.shadowColor = UIColor.gray.cgColor
        dropDown.layer.shadowOpacity = 0.2
        dropDown.layer.shadowRadius = 10
        dropDown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = dropDown.anchorView?.plainView.bounds.height {
            dropDown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        // Customize cells
        dropDown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        // Handle selection
        dropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            
            print("Selected index: \(index)")
            print("Selected month: \(item)")
                if item == "Block" {
                    viewModel.apiForBlockUser(senderId: self.SenderID, group_channel: self.uniqueConversationName, blockUnblock: "1")
                }
                if item == "Unblock" {
                    viewModel.apiForBlockUser(senderId: self.SenderID, group_channel: self.uniqueConversationName, blockUnblock: "0")
                }
            
            if item == "Mute" {
                
                viewModel.apiForSetMuteUnmute(senderId: self.SenderID, group_channel: self.uniqueConversationName, mute: "1")
                
            }
            
            if item == "Unmute" {
                
                viewModel.apiForSetMuteUnmute(senderId: self.SenderID, group_channel: self.uniqueConversationName, mute: "0")
                
            }
            
            if item == "Archive" {
                viewModel.apiForSetArchiveUnarchive(senderId: self.SenderID, group_channel: self.uniqueConversationName)
            }
            if item == "Unarchive" {
                
                viewModel.apiForSetArchiveUnarchive(senderId: self.SenderID, group_channel: self.uniqueConversationName)
            }
            
            if item == "Report" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostReportViolationPopUpVc") as! HostReportViolationPopUpVc
                vc.ComingFrom = "HostChat"
                vc.groupChannel = uniqueConversationName
                vc.reporter_id = user_id
                vc.reported_user_id = self.friend_id
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            }
        }
        // Show dropdown
        dropDown.show()
    }
    
    func showImagePickerOptions() {
        let actionSheet = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.openPhotoLibrary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        } else {
            showAlert(for: "Camera not available")
        }
    }
    
    func openPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func sendMessage(_ sender:UIButton) {
        
        if self.txtChat.text == "" {
            return
        }
        if isBlockStatus ?? 0 == 2 {
            self.showAlert(for: "You are blocked by \(self.guestName)")
        } else {
            sendMessage(inputMessage: txtChat.text!)
            self.txtChat.text = ""
        }
    }
    
    func scrollToBottom(animated: Bool = true) {
        DispatchQueue.main.async {
            let numberOfSections = self.tableView.numberOfSections
            if numberOfSections > 0 {
                let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections - 1)
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
            }
        }
    }
    
    func sendImage(data:Data) {
        
        let val = uploadingArray.count
        var cell: ImgChatCell?
        
        let imgName = Date.getCurrentDateForName()
        let messageOptions = TCHMessage()
        // Save image to a temporary file
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent("\(imgName).jpg")

        do {
            try data.write(to: fileURL)
        } catch {
            print("Failed to write image data to file: \(error.localizedDescription)")
            return
        }

        self.conversationsManager.sendMediaMessage(data: data, contentType: "image/jpeg", fileName: "\(imgName).jpg") { (result, _)  in
            DispatchQueue.main.async {
                if !(result?.isSuccessful ?? false) {
                    print("Media upload failed: \(String(describing: result?.error))")
                } else {
                    print("Media upload successful")
                }
                if let d = self.uploadingArray.firstIndex(where: {($0.name == "\(imgName).jpg")}) {
                    self.uploadingArray.remove(at: d)
                    DispatchQueue.main.async {
                        self.tableView.reloadSections([0], with: .none)
                    }
                }
            }
        }
        
        // Append message to uploading array
        uploadingArray.append(uploadStruce(  msg: messageOptions, name: "\(imgName).jpg", img: data))
        tableView.reloadSections([0], with: .none)
        self.scrollToBottom()
        
    }
    // MARK: - Chat Service
    
    func sendMessage(inputMessage: String) {
        self.conversationsManager.sendMessage(inputMessage, completion: { (result, _) in
            if result.isSuccessful {
                if self.lbl_Status.text == "Offline" {
                    print("Send Chat api")
                    self.viewModel.apiForSendChatNotification(senderId: self.SenderID, receiver_id: self.friend_id)
                }
               // self.txtChat.inputView = nil
               // self.txtChat.keyboardType = .default
                //self.txtChat.reloadInputViews()
            } else {
                self.displayErrorMessage("Unable to send message")
            }
        })
    }
    
    @IBAction func btnUnblock_Tap(_ sender: UIButton) {
        viewModel.apiForBlockUser(senderId: self.SenderID , group_channel: self.uniqueConversationName , blockUnblock: "0")
    }
    @IBAction func btnBack(_ sender: UIButton) {
        
        print("hello I bak ")
        
        // Switch to tab index 1 after popping
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
            self.navigationController?.popViewController(animated: true)
            self.backAction("\(self.isBlockStatus ?? 0)", "\(self.favoriteStatus ?? 0)", "\(self.isMuteStatus ?? 0)",  "\(self.isArchiveStatus ?? 0)")
            
        }
    }
    
    func updateLastMsgTime(_ time:String) -> String{
        print(time)
        let dateFormatte = DateFormatter()
        dateFormatte.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatte.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let theSecondDate = dateFormatte.date(from: time) {
            dateFormatte.timeZone = TimeZone.current
            dateFormatte.dateFormat = "yyyy-MM-dd HH:mm:ss"
           
            let theFirstDate = Date()
            
            let theComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second ], from: theSecondDate, to: theFirstDate)
            if let theNumbe = theComponents.year, theNumbe > 0 {
                return "\(theNumbe)y ago"
            }else if let theNumbe = theComponents.month, theNumbe > 0 {
                return "\(theNumbe)month ago"
            }else if let theNumbe = theComponents.day, theNumbe > 0 {
                return "\(theNumbe)d ago"
            }else if let theNumbe = theComponents.hour, theNumbe > 0 {
                return "\(theNumbe)h ago"
            }else if let theNumbe = theComponents.minute, theNumbe > 0 {
               
                if theNumbe >= 1 {
                    return "\(theNumbe)m ago"
                }else{
                    return "now"
                }
            }
        }
        return  "now"
    }
}
extension HostChatVC {
    func bindVC() {
            viewModel.$blockResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    var isblockedStatus = response.data?.isBlocked ?? false
                    print(response.message ?? "")
                    
                    print(isblockedStatus ,"isBlockStatus")
                    
                    if (isblockedStatus) == false {
                        self.isBlockStatus = 0
                        self.viewSendMessage.isHidden = false
                        self.viewBlock.isHidden = true
                        
                    } else {
                        self.isBlockStatus = 1
                        self.viewSendMessage.isHidden = true
                        self.viewBlock.isHidden = false
                    }
                })
            }.store(in: &cancellables)
        
        
        viewModel.$getFavResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    var isfavStatus = response.data?.favoriteStatus ?? "0"
                    print(response.message ?? "")
                    
                    print(isfavStatus ,"isfavStatus")
                    
                    if (isfavStatus) == "0" {
                        self.favoriteStatus = 0
                        self.btnFavourite.setImage(UIImage(named: "Group 1171276144"), for: .normal)
                        
                    } else {
                        self.favoriteStatus = 1
                        self.btnFavourite.setImage(UIImage(named: "staricon 1"), for: .normal)
                        
                    }
                    
                })
            }.store(in: &cancellables)
        
        // Result Mute Unmute api
              viewModel.$getMuteUnmuteResult
                  .receive(on: DispatchQueue.main)
                  .sink { [weak self] result in
                      guard let self = self else{return}
                      result?.handle(success: { response in
                          
                          var isMuteStatus = response.data?.muteStatus ?? 0
                          print(response.message ?? "")
                          print(isMuteStatus,"isMuteStatus")
                         
                          if (isMuteStatus) == 0 {
                              self.isMuteStatus = 0
                             
                          } else {
                              self.isMuteStatus = 1
                          }
            
                      })
                  }.store(in: &cancellables)
        
        // Result Archive UnArchive api
              viewModel.$setArchiveResult
                  .receive(on: DispatchQueue.main)
                  .sink { [weak self] result in
                      guard let self = self else{return}
                      result?.handle(success: { response in
                          var isArchiveResult = response.data?.isArchived ?? false
                          print(response.message ?? "")
                          print(isArchiveResult,"isArchiveResult")
                         
                          if (isArchiveResult) == false {
                              self.isArchiveStatus = 0
                              
                          } else {
                              self.isArchiveStatus = 1
                          }
                      })
                  }.store(in: &cancellables)
        
        
        // Result sendChatNotification
        viewModel.$sendChatNotiResult
                  .receive(on: DispatchQueue.main)
                  .sink { [weak self] result in
                      guard let self = self else{return}
                      result?.handle(success: { response in
                          print(response.message ?? "")
                      })
                  }.store(in: &cancellables)
        
    }
}


extension HostChatVC:UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.conversationsManager.conversation?.typing()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == "Type a message" && textField.text == ""{
            
            
        }else{
            
            
        }
        print("textFieldDidEndEditing")
    }
    @objc func keyboardWillShow(sender: NSNotification) {
        let i = sender.userInfo!
        let s: TimeInterval = (i[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let k = (i[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        tbl_bottom_h.constant = k
        UIView.animate(withDuration: s) { self.view.layoutIfNeeded() }
        self.conversationsManager.conversation?.typing()
        
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let s: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        tbl_bottom_h.constant = 24
        UIView.animate(withDuration: s) { self.view.layoutIfNeeded() }
        
    }
    
    func keyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
}

extension HostChatVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: NSInteger) -> Int {
        if section == 0 {
            return uploadingArray.count
        }else{
            return sortedMessages.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell:UITableViewCell
            let message = uploadingArray[indexPath.row]
            cell = getChatCellForTableView(tableView: tableView, forIndexPath:indexPath, message:message)
          //  cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
            return cell
        }
        var cell:UITableViewCell
        let message = sortedMessages[indexPath.row]
        
        cell = getChatCellForTableView(tableView: tableView, forIndexPath:indexPath, message:message)
        
        if indexPath.row == 0 {
            if let conversation = conversationsManager.conversation,let itt = message.index {
                conversation.setLastReadMessageIndex(itt) { (result, value) in
                }
            }
        }
       // cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        return cell
    }
    func getChatCellForTableView(tableView: UITableView, forIndexPath indexPath:IndexPath, message: uploadStruce) -> UITableViewCell {
        let ext = message.name.fileExtension()
        
        print(ext,"extension ravi")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImgChatCell", for:indexPath as IndexPath) as! ImgChatCell
        
                if let da = message.img {
                    cell.img11.image = UIImage(data: da)
                }
        return UITableViewCell()
    }
    
     func getChatCellForTableView(tableView: UITableView, forIndexPath indexPath:IndexPath, message: TCHMessage) -> UITableViewCell {
         if sortedMessages.count > 90 {
             self.loadNewMessage(indexPath: indexPath)
         }
         var ms = message.author ?? ""
         // let date = NSDate.dateWithISO8601String(dateString: message.dateUpdated ?? "")
         print(ms = message.author ?? "","xyz",ms,"Auther",user_id)
         
         if !message.attachedMedia.isEmpty {
             let cell = tableView.dequeueReusableCell(withIdentifier: "ImgChatCell", for: indexPath) as! ImgChatCell
         
             if let media = message.attachedMedia.first {
                 media.getTemporaryContentUrl { result, url in
                            if result.isSuccessful, let urlString = url {
                                DispatchQueue.global().async {
                                  //  if let data = try? Data(contentsOf: urlString) {
                                        DispatchQueue.main.async {
                                            cell.img11.loadImage(from: urlString)
                                            cell.lbl_Time.text = self.updateLastMsgTime(message.dateUpdated ?? "")
                                            if ms == "\(self.user_id)"{
                                                cell.imgUser.loadImage(from:self.hostProfileImg,placeholder: UIImage(named: "user"))
                                                cell.lbl_name.text = self.guestName
                                            }else{
                                                cell.imgUser.loadImage(from:self.guesttProfileImg,placeholder: UIImage(named: "user"))
                                                cell.lbl_name.text = self.hostName
                                            }
                                            
                                        }
                                    //}
                                }
                            } else {
                                print("Failed to get media URL: \(result.error?.localizedDescription ?? "Unknown error")")
                            }
                        }
             }
             return cell
         }
             else{
             let cell = tableView.dequeueReusableCell(withIdentifier: MyChatCellIdentifier, for:indexPath as IndexPath) as! ChatCell
             if ms == "\(user_id)" {
                 cell.img.loadImage(from:self.guesttProfileImg,placeholder: UIImage(named: "user"))
                 cell.lbl_name.text = self.hostName
                 cell.setUser(user: message.author ?? "[Unknown author]", imgArr: Media(image:user_imgV, data: nil, url: nil), messageBody: message,user_id:user_id)
                 return cell
             } else {
                 
                 cell.img.loadImage(from:self.hostProfileImg,placeholder: UIImage(named: "user"))
                 cell.lbl_name.text = self.guestName
                 
                 cell.setUser(user: message.author ?? "[Unknown author]", imgArr: Media(image:user_imgV, data: nil, url: nil), messageBody: message,user_id:user_id)
                 return cell
             }
         }
     }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    func loadNewMessage(indexPath: IndexPath) {
        if indexPath.row == (sortedMessages.count - 1) && lastCell == 1 && sortedMessages.count > 90 {
            self.lastCell = 2
            let d = UInt(sortedMessages.count)
            self.conversationsManager.conversation?.getMessagesBefore(d, withCount: d + 100, completion: { (result, messages) in
                if let messages = messages, messages.count > 0 {
                    self.addMessages(newMessages: Set(messages),loadToBottom: true)
                    self.lastCell = 1
                    if d != self.messages.count {
                        DispatchQueue.main.async {
                            self.tableView?.reloadData()
                            self.scrollToBottom()
                        }
                    }
                }else{
                    self.lastCell = 3
                }
            })
        }
    }
    
    func addMessages(newMessages:Set<TCHMessage>,loadToBottom:Bool = true) {
        messages =  messages.union(newMessages)
        sortMessages()
        DispatchQueue.main.async {
            self.tableView!.reloadData()
            self.scrollToBottom()
        }
    }
    func sortMessages() {
        sortedMessages = messages.sorted { (b, a) -> Bool in
            (a.dateUpdated ?? "") > (b.dateUpdated ?? "")
        }
    }
}
// MARK: QuickstartConversationsManagerDelegate

extension HostChatVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            selectedImage.resizeByByte(maxMB: 1) { (data) in
                DispatchQueue.main.async {
                    guard let imageData = data else {
                        self.showAlert(for: "Image could not be processed. Please select a smaller image.")
                        return
                    }
                    self.sendImage(data: imageData)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.tabBarController?.setTabBarHidden(false, animated: false)
        dismiss(animated: true, completion: nil)
    }
}

extension HostChatVC: TCHConversationDelegate {
    func conversation(_ conversation: TCHConversation, participantJoined participant: TCHParticipant) {
        print("Participant Joined: \(participant.identity ?? "Unknown")")
    }
    
    func conversation(_ conversation: TCHConversation, participantLeft participant: TCHParticipant) {
        print("Participant Left: \(participant.identity ?? "Unknown")")
    }
}
extension HostChatVC: QuickstartConversationsManagerDelegate {

    func checkFriendOnlineStatus(friendIdentity: String) {
        
        conversationsManager.client?.subscribedUser(withIdentity: friendIdentity) { result, user in
            if let user = user, result.isSuccessful {
                let isOnline = user.isOnline()
                print("\(friendIdentity) is online: \(isOnline)")

                DispatchQueue.main.async {
                    if isOnline {
                        self.lbl_Status.text = "Online"
                    } else {
                        self.lbl_Status.text = "Offline"
                      // self.fetchLastReadMessageTime(for: friendIdentity)
                    }
                }
            } else {
                print("Failed to fetch user or user does not exist.")
//                DispatchQueue.main.async {
//                    self.lbl_Status.text = "Offline"
//                }
            }
        }
    }


    private func getFormattedLastSeen(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    func startTyping(participant: TCHParticipant) {
        print("startTyping",participant.identity as Any)
        self.lbl_Status.text = "Typing...."
        
    }
    func endTyping(participant: TCHParticipant) {
        print("endTyping",participant.identity as Any)
        self.lbl_Status.text = "Online"
        
    }
    

    func getClient(client: TwilioConversationsClient?) {
       // var unreadConversations: [TCHConversation] = []
//        if let client = client, let conversations = client.myConversations() {
//            DispatchQueue.main.async {
//
//                let dispatchGroup = DispatchGroup()
//
//                for conversation in conversations {
//                    dispatchGroup.enter()
//                    conversation.getUnreadMessagesCount { result, count in
//                        if result.isSuccessful, let unreadCount = count {
//                            unreadConversations.append(conversation) // Add if unread messages exist
//                        }
//                        dispatchGroup.leave()
//                    }
//                }
//            }
//        }
    }
    func displayStatusMessage(_ statusMessage: String) {
        //        self.navigationItem.prompt = statusMessage
        //        print("statusMessage",statusMessage)
    }
    func displayErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: "",
                                                message: errorMessage,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func reloadMessages() {
        //        sortedMessages = self.conversationsManager.messages
        //        sortedMessages.reverse()
        self.loadMessages()
        print("reloadMessages")
        //        self.tableView.reloadData()
    }
    
    func receivedNewMessage(message:TCHMessage) {
        print("receivedNewMessage")
        checkFriendOnlineStatus(friendIdentity: self.friend_id)
        if !messages.contains(message) {
            addMessages(newMessages: [message])
        }
    }
    func loadMessages() {
        messages.removeAll()
        let items = self.conversationsManager.messages
        self.addMessages(newMessages: Set(items))
    }
}


