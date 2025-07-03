//
//  MessageVC.swift
//  Zyvo
//
//  Created by ravi on 22/10/24.
//

import UIKit
//import KDCircularProgress
import DropDown
import Combine
import TwilioConversationsClient
import IQKeyboardManagerSwift

class MessageVC:UIViewController {
    
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var view_Search: UIView!
    @IBOutlet weak var txt_Search: UITextField!
    
    var Arr = ["Mute","Report","Delete chat","Block","Archive"]
    
    private var totalUnreadCount = 0
    
    var dropDown = DropDown()
    var dropDownFilter = DropDown()
    var ArrFilter = ["All Conversations","Archived","Unread"]
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = ChatDataViewModel()
    
    var index : Int? = 0
    
    private let debouncer = Debouncer()
    private var chatDataArr: [ChatDataModel] = []
    private var MainchatDataArr: [ChatDataModel] = []
    
    private var chatDataArrMain: [ChannelListModel] = []
    
    private var conversationsManager = QuickstartConversationsManager.shared.self
    private var listOfChannel: [TCHConversation] = []
    private var listOfChannel_bal = false
    
    var currentStatus = ""
    
    var isFetched : Bool? = false
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
        
        txt_Search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setupTableView()
        
        setupUI()
        
        view_Search.layer.borderWidth = 1.5
        view_Search.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2
        conversationsManager.myMsg = { msg in
            print(msg?.body ?? "","twillio msg from closer")
            
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        isFetched = false
        self.tblV.setEmptyView(message: "")
        self.chatDataArr.removeAll()
        self.tblV.reloadData()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let searchText = textField.text?.lowercased(), !searchText.isEmpty else {
            self.chatDataArr = self.MainchatDataArr
            self.reloadAllData()
            return
        }

        self.chatDataArr = self.MainchatDataArr.filter {
            ($0.receiverName ?? "").lowercased().contains(searchText)
        }
        
        self.reloadAllData()
    }
    
    private func setupTableView() {
        tblV.delegate = self
        tblV.dataSource = self
        tblV.register(UINib(nibName: "msgCell", bundle: nil), forCellReuseIdentifier: "msgCell")
        
//        let token = UserDetail.shared.getChatToken()
//        QuickstartConversationsManager.shared.loginWithAccessToken(token) { (res) in
//            print("Login with Access Token")
//            self.viewModel.apiForGetChatData(userType: "guest")
//        }
         self.conversationsManager.delegate = self
    }
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        conversationsManager.delegate = self
        
    }
    
    @objc private func pullToRefresh() {
        APIManager.shared.apiforGetChatToken(role: "guest") { t in
            let token = UserDetail.shared.getChatToken()
            QuickstartConversationsManager.shared.loginWithAccessToken(token) { (res) in
                print("Login with Access Token")
                self.viewModel.apiForGetChatData(userType: "guest")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        conversationsManager.delegate = self
        IQKeyboardManager.shared.enable = true
        
        let token = UserDetail.shared.getChatToken()
        if isFetched == false {
            QuickstartConversationsManager.shared.loginWithAccessToken(token) { (res) in
                print("Login with Access Token")
                
                self.viewModel.apiForGetChatData(userType: "guest")
            }
        }
        
//        if let token = UserDefaults.standard.object(forKey: "twilioToken") as? String, self.conversationsManager.client == nil {
//            print("I am here")
//            let token = UserDetail.shared.getChatToken()
//            
//            self.conversationsManager.loginWithAccessToken(token) { (res) in
                //self.reloadAllData()
//                }
//        }else{
//            
//            print("I am not here")
//       
//        }
    }
    
    
    @IBAction func btnFitler_Tap(_ sender: UIButton) {
        
        // Set up the dropdown
        dropDownFilter.anchorView = sender // Anchor dropdown to the button
        dropDownFilter.dataSource = ArrFilter
        dropDownFilter.direction = .bottom
        dropDown.backgroundColor = UIColor.white
        dropDownFilter.cornerRadius = 10
        dropDownFilter.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        dropDownFilter.layer.shadowColor = UIColor.gray.cgColor
        dropDownFilter.layer.shadowOpacity = 0.2
        dropDownFilter.layer.shadowRadius = 10
        dropDownFilter.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        
        if let anchorHeight = dropDownFilter.anchorView?.plainView.bounds.height {
            dropDownFilter.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        
        // Customize cells
        dropDownFilter.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        
        // Handle selection
        dropDownFilter.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected Value: \(item)")
            
            if "\(item)" == "Archived" {
                
                self.currentStatus = "Archived"
                
                self.chatDataArr = chatDataArr.filter { $0.isArchived == 1 }
                self.tblV.reloadData()
                
            }
            if "\(item)" == "Unread" {
                self.currentStatus = "Unread"
                getUnreadConversations { [weak self] unreadConversations in
                        guard let self = self else { return }
                        // Filter only the unread messages
                        self.chatDataArr = self.chatDataArr.filter { chat in
                            unreadConversations.contains { $0.uniqueName == chat.groupName }
                        }
                        self.tblV.reloadData() // Reload table with unread messages
                    }
            }
            if "\(item)" == "All Conversations" {
                
                self.currentStatus = "All Conversations"
                
                let token = UserDetail.shared.getChatToken()
                QuickstartConversationsManager.shared.loginWithAccessToken(token) { (res) in
                    print("Login with Access Token")
                    self.viewModel.apiForGetChatData(userType: "guest")
                }
                
            }
        }
        
        // Show dropdown
        dropDownFilter.show()
        
    }
    
    func getUnreadConversations(completion: @escaping ([TCHConversation]) -> Void) {
        
        var unreadConversations: [TCHConversation] = []

        let dispatchGroup = DispatchGroup()

        for conversation in self.listOfChannel {
            dispatchGroup.enter()
            conversation.getUnreadMessagesCount { (result, unreadCount) in
                if result.isSuccessful, let unread = unreadCount?.intValue, unread > 0 {
                    unreadConversations.append(conversation) // ✅ Append only unread messages
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            print(unreadConversations.count,"COUNT")
            completion(unreadConversations) // ✅ Return unread conversations
        }
    }


    
    private func fetchUnreadMessageCounts() {
        var totalUnreadCount = 0
        let group = DispatchGroup()
        
        for data in chatDataArr {
            if let uniqueName = data.groupName, let conversation = data.chatData, uniqueName == conversation.uniqueName {
                group.enter()
                conversation.getUnreadMessagesCount { (result, unreadCount) in
                    if let unread = unreadCount as? Int {
                        totalUnreadCount += unread
                        print("Unread count for Main Tab \(uniqueName): \(unread)")
                        
                        group.notify(queue: .main) {
                            self.totalUnreadCount = totalUnreadCount
                            print("Total Unread Messages for message VC : \(self.totalUnreadCount)")
                            if let tabBarVC = self.tabBarController as? MainTabVC {
                                tabBarVC.updateBadgeCount(totalUnreadCount)
                            }
                        }
                        
                    } else {
                        print("Failed to fetch unread count for \(uniqueName)")
                    }
                    group.leave()
                }
            }
        }
        
    }
}

extension MessageVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120   // UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatDataArr.count ?? 0
    }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as! msgCell
        let data = chatDataArr[indexPath.row]
      
        cell.userName.text = data.receiverName ?? ""
        cell.lbl_PropertyTitle.text = "(\(data.propertyTitle ?? ""))"
        var image = data.receiverImage ?? ""
        let imgURL = AppURL.imageURL + image
        cell.userImg.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
        
        cell.btnMenu.tag = indexPath.row
        cell.btnDetails.tag = indexPath.row
        cell.btnMenu.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        cell.btnDetails.addTarget(self, action: #selector(buttonDetails(_:)), for: .touchUpInside)
        cell.view_online.isHidden = true
//        if indexPath.row == 0 {
//            cell.view_online.isHidden = false
//        }
        cell.lbl_time.text = ""
        cell.lbl_message.text = ""
        if let uniqueName = data.groupName, let conversation = data.chatData, uniqueName == conversation.uniqueName {
            if let lastMessageIndex = conversation.lastMessageIndex {
                conversation.message(withIndex: lastMessageIndex) { (result, message) in
                    DispatchQueue.main.async {
                        if let messageBody = message {
                            cell.lbl_message.text = messageBody.body
                            if let dateUpdated = messageBody.dateUpdated {
                                cell.lbl_time.text = self.updateLastMsgTime(dateUpdated)
                            }
                        }
                    }
                }
            }
            conversation.getUnreadMessagesCount { (res, unreadCount) in
                DispatchQueue.main.async {
                    if let unread = unreadCount as? Int, unread > 0 {
                        print("\(unread) COUNT USERWISE MESSAGE UNREAD")
                    }
                }
            }
        }
        return cell
 }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = chatDataArr[indexPath.row]
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        
            if let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC {
                vc.uniqueConversationName = data.groupName ?? ""
                let userid = UserDetail.shared.getUserId()
                if userid == data.receiverID {
                    vc.friend_id = data.senderID ?? ""
                    vc.SenderID = data.receiverID ?? ""
                } else if userid == data.senderID {
                    vc.friend_id = data.receiverID ?? ""
                    vc.SenderID = data.senderID ?? ""
                }
                
                vc.favoriteStatus = data.isFavorite ??  0
                vc.isBlockStatus = data.isBlocked ?? 0
                vc.isMuteStatus = data.isMuted ?? 0
                vc.isArchiveStatus = data.isArchived ?? 0
                let hostImage = data.senderProfile ?? ""
                let guestImage = data.receiverImage ?? ""
                vc.hostProfileImg = AppURL.imageURL + hostImage
                vc.guesttProfileImg = AppURL.imageURL + guestImage
                vc.hostName = data.receiverName ?? ""
                vc.guestName = data.senderName ?? ""
                
                self.tabBarController?.tabBar.isHidden = true
                vc.hidesBottomBarWhenPushed = true
                
                if let uniqueName = data.groupName,
                   let conversation = data.chatData,
                   uniqueName == conversation.uniqueName {
                    conversation.getUnreadMessagesCount { (result, unreadCount) in
                        DispatchQueue.main.async {
                            if let unread  = unreadCount {
                                print("Unread count for \(uniqueName): \(unread)")
                                var remainingCount = self.totalUnreadCount  - Int(truncating: unread)
                                self.totalUnreadCount = remainingCount
                                print("Total Unread Messages DidSelect : \(remainingCount)")
                                if let tabBarVC = self.tabBarController as? MainTabVC {
                                    tabBarVC.updateBadgeCount(remainingCount)
                                }
                            } else {
                                print("Unread count is nil for \(uniqueName)")
                            }
                        }
                    }
                } else {
                    print("Conversation not found for \(data.groupName ?? "Unknown")")
                }
                vc.backAction = { str,favStatus, muteStatus, archiveStatus in
                    self.chatDataArr = self.MainchatDataArr
                    print("\(str) Block Status Received")
                    print("\(favStatus) favStatus Received")
                    print("\(muteStatus) muteStatus Received")
                    print("\(archiveStatus) muteStatus Received")
                    let isblockedStatus = str
                    let isMuteStatus = muteStatus
                    if isblockedStatus == "0" {
                        self.Arr[3] = "Block"
                        self.chatDataArr[indexPath.row].isBlocked = 0
                    }
                    if isblockedStatus == "1" {
                        self.Arr[3] = "Unblock"
                        self.chatDataArr[indexPath.row].isBlocked = 1
                    }
                    let isFavStatus = favStatus
                    if isFavStatus == "0" {
                        self.chatDataArr[indexPath.row].isFavorite = 0
                    }
                    if isFavStatus == "1" {
                        self.chatDataArr[indexPath.row].isFavorite = 1
                    }
                    let MuteStatus = isMuteStatus
                    if MuteStatus == "0" {
                        self.chatDataArr[indexPath.row].isMuted = 0
                    }
                    if isMuteStatus == "1" {
                        self.chatDataArr[indexPath.row].isMuted = 1
                    }
                    let isarchiveStatus = archiveStatus
                    if isarchiveStatus == "0" {
                        self.chatDataArr[indexPath.row].isArchived = 0
                    }
                    if isarchiveStatus == "1" {
                        self.chatDataArr[indexPath.row].isArchived = 1
                    }
                    if self.currentStatus == "All Conversations" || self.currentStatus == "Archived" || self.currentStatus == "Unread" {
                        self.currentStatus = ""
                        let token = UserDetail.shared.getChatToken()
                        QuickstartConversationsManager.shared.loginWithAccessToken(token) { (res) in
                            print("Login with Access Token")
                            self.viewModel.apiForGetChatData(userType: "guest")
                        }
                    }
                    self.tabBarController?.tabBar.isHidden = false
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    @objc func buttonDetails(_ sender: UIButton) {
        let d = sender.tag
        let data = chatDataArr[d]
        print(d,"Index")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListingDetailsVC") as! ListingDetailsVC
        let userid = UserDetail.shared.getUserId()
        if userid == data.receiverID {
            vc.hostid = data.senderID ?? ""
        } else if userid == data.senderID {
            vc.hostid = data.receiverID ?? ""
        }
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        print("RAVI")
        // Set up the dropdown
        let blockedStatus = chatDataArr[sender.tag].isBlocked ?? 0
        
        let muteStatus = chatDataArr[sender.tag].isMuted ?? 0
        
        let archiveStatus = chatDataArr[sender.tag].isArchived ?? 0
        
        self.index = sender.tag
        if archiveStatus == 0 {
            Arr[4] = "Archive"
        }
        if archiveStatus == 1 {
            Arr[4] = "Unarchive"
        }
        if muteStatus == 0 {
            Arr[0] = "Mute"
        }
        if muteStatus == 1 {
            Arr[0] = "Unmute"
        }
        if blockedStatus == 0 {
            Arr[3] = "Block"
        }
        if blockedStatus == 1 {
            Arr[3] = "Unblock"
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
            
            if item == "Report" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportViolationVC") as! ReportViolationVC
                self.tabBarController?.tabBar.isHidden = true
                vc.ComingFrom = "MessageChat"
                vc.groupChannelName = chatDataArr[sender.tag].groupName ?? ""
                vc.reporter_id = chatDataArr[sender.tag].senderID ?? ""
                vc.reported_user_id = chatDataArr[sender.tag].receiverID ?? ""
                vc.backAction = { str in
                    if str == "Cancel"{
                        self.tabBarController?.tabBar.isHidden = false
                    }
                    if str == "ReportSubmitted"{
                        
                        let sb = UIStoryboard(name: "Host", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "HostNotificationPopUpVC") as! HostNotificationPopUpVC
                        vc.backAction = { str in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                            vc.comesFrom = "ReportSubmitted"
                            vc.backCome = {
                                self.tabBarController?.tabBar.isHidden = false
                            }
                            vc.modalPresentationStyle = .overCurrentContext
                            self.present(vc, animated: true)
                        }
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: true)
                       
                    }
                }
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            }
            
            if item == "Block" {
                print("call api for block here")
                
                if item == "Block" {
                    viewModel.apiForBlockUser(senderId: chatDataArr[sender.tag].senderID ?? "", group_channel: chatDataArr[sender.tag].groupName ?? "", blockUnblock: "1")
                }
            }
            if item == "Unblock" {
                print("call api for unblock here")
                
                if item == "Unblock" {
                    viewModel.apiForBlockUser(senderId: chatDataArr[sender.tag].senderID ?? "", group_channel: chatDataArr[sender.tag].groupName ?? "", blockUnblock: "0")
                }
            }
            if item == "Mute" {
                viewModel.apiForSetMuteUnmute(senderId: chatDataArr[sender.tag].senderID ?? "", group_channel: chatDataArr[sender.tag].groupName ?? "", mute: "1")
            }
            if item == "Unmute" {
                viewModel.apiForSetMuteUnmute(senderId: chatDataArr[sender.tag].senderID ?? "", group_channel: chatDataArr[sender.tag].groupName ?? "", mute: "0")
            }
            if item == "Archive" {
                viewModel.apiForSetArchiveUnarchive(senderId: chatDataArr[sender.tag].senderID ?? "", group_channel: chatDataArr[sender.tag].groupName ?? "")
            }
            if item == "Unarchive" {
                viewModel.apiForSetArchiveUnarchive(senderId: chatDataArr[sender.tag].senderID ?? "", group_channel: chatDataArr[sender.tag].groupName ?? "")
            }
            if item == "Delete chat" {
                
                print("DeleteChatAPI")
                
                self.viewModel.apiForDeleteChat(userType: "guest", groupChannel: self.chatDataArr[sender.tag].groupName ?? "")
//                leaveConversation(groupName: chatDataArr[sender.tag].groupName ?? "") { success, errorMessage in
//                    if success {
//                        print("TESTING: Chat deleted successfully.")
//                        // Find the index of the chat to delete
//                        if let index = self.chatDataArr.firstIndex(where: { $0.groupName == self.chatDataArr[sender.tag].groupName }) {
//                            self.viewModel.apiForDeleteChat(userType: "guest", groupChannel: self.chatDataArr[sender.tag].groupName ?? "")
//                        }
//                    } else {
//                        print("TESTING: Failed to delete chat. Error: \(errorMessage ?? "Unknown error")")
//                    }
//                }
            }
        }
        // Show dropdown
        dropDown.show()
    }
    
    func leaveConversation(groupName: String, completion: @escaping (Bool, String?) -> Void) {
        guard let client = conversationsManager.client else {
            completion(false, "Conversations client is not initialized.")
            return
        }

        client.conversation(withSidOrUniqueName: groupName) { result, conversation in
            if let conversation = conversation, result.isSuccessful {
                conversation.leave { status in
                    if status.isSuccessful {
                        print("Successfully left the conversation.")
                        completion(true, nil)
                    } else {
                        completion(false, status.resultText ?? "Unknown error occurred while leaving conversation.")
                    }
                }
            } else {
                completion(false, result.resultText ?? "Failed to retrieve conversation.")
            }
        }
    }

    
    func deleteConversation(groupName: String, completion: @escaping (Bool, String?) -> Void) {
        guard let client = conversationsManager.client else {
            completion(false, "Conversations client is not initialized.")
            return
        }

        client.conversation(withSidOrUniqueName: groupName) { result, conversation in
            if let conversation = conversation, result.isSuccessful {
                conversation.destroy { status in
                    if status.isSuccessful {
                        print("YES CHAT DELETED")
                        completion(true, nil)
                    } else {
                        completion(false, status.resultText ?? "Unknown error occurred while deleting conversation.")
                    }
                }
            } else {
                completion(false, result.resultText ?? "Failed to retrieve conversation.")
            }
        }
    }
}

extension MessageVC {
    
    func updateLastMsgTime(_ time: String) -> String {
        let dateFormatte = DateFormatter()
        dateFormatte.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatte.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let theSecondDate = dateFormatte.date(from: time) {
            dateFormatte.timeZone = TimeZone.current
            dateFormatte.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let theFirstDate = Date()
            let theComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: theSecondDate, to: theFirstDate)
            
            if let theNumbe = theComponents.year, theNumbe > 0 {
                return "\(theNumbe)y ago"
            } else if let theNumbe = theComponents.month, theNumbe > 0 {
                return "\(theNumbe)month ago"
            } else
            
            if let theNumbe = theComponents.day, theNumbe > 0 {
                return "\(theNumbe)d ago"
            } else if let theNumbe = theComponents.hour, theNumbe > 0 {
                return "\(theNumbe)h ago"
            } else if let theNumbe = theComponents.minute, theNumbe > 0 {
                return "\(theNumbe)m ago"
            } else if let theNumbe = theComponents.second, theNumbe > 0 {
                return "\(theNumbe)s ago"
            } else {
                return "now"
            }
        }
        return ""
    }
}

extension MessageVC: QuickstartConversationsManagerDelegate {

    func reloadAllData() {
        debouncer.debounce(1.0) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.global(qos: .userInitiated).async {
                for item in 0..<self.chatDataArr.count {
                    let name = self.chatDataArr[item].groupName
                    if let conversation = self.listOfChannel.first(where: { $0.uniqueName == name }) {
                        self.chatDataArr[item].chatData = conversation
                    }
                }
                
                self.chatDataArr.sort {
                    ($0.chatData?.lastMessageDate ?? Date.distantPast) > ($1.chatData?.lastMessageDate ?? Date.distantPast)
                }
                
                DispatchQueue.main.async {
                    self.fetchUnreadMessageCounts()
                    self.tblV.reloadData()
                }
            }
        }
    }
    
    func displayStatusMessage(_ statusMessage: String) {
        print(statusMessage)
    }
    
    func displayErrorMessage(_ errorMessage: String) {
        print(errorMessage)
    }
    
    func startTyping(participant: TCHParticipant) {
        print("Start Typing")
    }
    
    func endTyping(participant: TCHParticipant) {
        print("End Typing")
    }
    
    func getClient(client: TwilioConversationsClient?) {
        if let client = client, let list = client.myConversations() {
            DispatchQueue.main.async {
                self.listOfChannel = list
                self.listOfChannel_bal = true
                self.reloadAllData()
            }
        }
    }
    
    func reloadMessages() {
        let token = UserDetail.shared.getChatToken()
        QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] _ in
            self?.viewModel.apiForGetChatData(userType: "guest")
        }
    }
    
    func receivedNewMessage(message: TCHMessage) {
        if let client = conversationsManager.client, let list = client.myConversations() {
            DispatchQueue.main.async {
                self.listOfChannel = list
                self.listOfChannel_bal = true
                self.fetchUnreadMessageCounts()
                self.reloadAllData()
            }
        }
    }
}

extension MessageVC {
    func bindVC() {
        
        viewModel.$getChatDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    let arr = response.data ?? []
                    
                    self.chatDataArr = arr.filter { $0.isDeleted == false && $0.propertyTitle != ""}
                    
                    if self.chatDataArr.count == 0 {
                        self.tblV.setEmptyView(message: "No Data Found")
                    } else {
                        self.tblV.setEmptyView(message: "")
                    }
                    
                    
                    self.MainchatDataArr = self.chatDataArr
                    

                    DispatchQueue.main.asyncAfter(deadline: .now() ){
                        
                        self.reloadAllData()
                        
                        self.refreshControl.endRefreshing()
                    }
                })
            }.store(in: &cancellables)
        
        // Result Block api
        viewModel.$blockResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    var isblockedStatus = response.data?.isBlocked ?? false
                    print(response.message ?? "")
                    print(isblockedStatus,"isblockedStatus")
                    if isblockedStatus == true {
                        self.Arr[3] = "Unblock"
                        self.chatDataArr[self.index ?? 0].isBlocked = 1
                    }
                    if isblockedStatus == false {
                        self.Arr[3] = "Block"
                        self.chatDataArr[self.index ?? 0].isBlocked = 0
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
                    if isMuteStatus == 1 {
                        self.Arr[0] = "Unmute"
                        self.chatDataArr[self.index ?? 0].isMuted = 1
                    }
                    if isMuteStatus == 0 {
                        self.Arr[0] = "Mute"
                        self.chatDataArr[self.index ?? 0].isMuted = 0
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
                          if isArchiveResult == true {
                              self.Arr[4] = "Unarchive"
                              self.chatDataArr[self.index ?? 0].isArchived = 1
                          }
                          if isArchiveResult == false {
                              self.Arr[4] = "Archive"
                              self.chatDataArr[self.index ?? 0].isArchived = 0
                          }
                      })
                  }.store(in: &cancellables)
        
        
        // Result Mute Unmute api
        viewModel.$getDeleteChatResult
                  .receive(on: DispatchQueue.main)
                  .sink { [weak self] result in
                      guard let self = self else{return}
                      result?.handle(success: { response in
                          print(response.message ?? "")
                          self.chatDataArr.remove(at: self.index ?? 0)
                         DispatchQueue.main.async {
                         self.tblV.reloadData()
                         }
                      })
                  }.store(in: &cancellables)
        
    }
}

class Debouncer {
    private var timer: Timer?
    
    func debounce(_ delay: TimeInterval, action: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            action()
        }
    }
}



struct ChannelListModel {
    let groupName: String?
    let receiverId: String?
    let receiverImage: String?
    let receiverName: String?
    let senderId: String?
    let senderName: String?
    let senderProfile: String?
    var lastMessage: String = ""
    var lastMessageTime: String = ""
    var isOnline: Bool = false
    var propertyTitle: String = ""
    var date: String = ""
    var isBlocked: Int = 0
    var isDeleted: Bool = false
    var isFavorite: Int = 0
    var isMuted: Int = 0
    var isArchived: Int = 0
}

