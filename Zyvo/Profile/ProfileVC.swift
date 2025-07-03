//
//  ProfileVC.swift
//  Zyvo
//
//  Created by ravi on 8/11/24.
//

import UIKit
import GooglePlaces
import IQKeyboardManagerSwift
import CountryPickerView
import Combine
import Persona2



class ProfileVC: UIViewController,UITextViewDelegate,UIPopoverPresentationControllerDelegate {
    var identity_verify : Int? = 0
    @IBOutlet weak var btnEditStreet: UIButton!
    @IBOutlet weak var btnEditCity: UIButton!
    @IBOutlet weak var btnEditState: UIButton!
    @IBOutlet weak var btnEditZip: UIButton!
    @IBOutlet weak var btnEditAboutMe: UIButton!
    @IBOutlet weak var view_ConfirmNowEmail: UIView!
    @IBOutlet weak var view_VerifiedIndentity: UIView!
    @IBOutlet weak var view_ConfirmNowIndentity: UIView!
    @IBOutlet weak var view_VerifiedEmail: UIView!
    @IBOutlet weak var view_VerifiedPhone: UIView!
    @IBOutlet weak var view_ConfirmNowPhone: UIView!
    @IBOutlet weak var view_ProfilePassword: UIView!
    @IBOutlet weak var view_ProfilePhoneNumber: UIView!
    @IBOutlet weak var scrollV: UIScrollView!
    @IBOutlet weak var view_Street: UIView!
    @IBOutlet weak var view_City: UIView!
    @IBOutlet weak var view_State: UIView!
    @IBOutlet weak var view_Zip: UIView!
    @IBOutlet weak var view_EmailProfile: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet var view_UploadPhoto: UIView!
    @IBOutlet weak var collecV_Place: UICollectionView!
    @IBOutlet weak var collecV_MyWork: UICollectionView!
    @IBOutlet weak var collecV_MyLanguage: UICollectionView!
    @IBOutlet weak var collecV_MyHobbies: UICollectionView!
    @IBOutlet weak var collecV_MyPets: UICollectionView!
    @IBOutlet weak var view_AboutMe: UIView!
    @IBOutlet weak var view_Dark: UIView!
    @IBOutlet weak var view_ProfileDetails: UIView!
    @IBOutlet weak var view_Photo: UIView!
    @IBOutlet weak var tbl_bottom_h: NSLayoutConstraint!
    @IBOutlet weak var cardNumTblV: UITableView!
    @IBOutlet weak var addCardBtnV: UIView!
    @IBOutlet weak var cardListV: UIView!
    @IBOutlet weak var viewAddCardBtn: UIView!
    @IBOutlet weak var tblVH_Const: NSLayoutConstraint!
    @IBOutlet weak var paymentDropIcon: UIImageView!
    @IBOutlet weak var paymentDropBtnO: UIButton!
    @IBOutlet weak var txt_PhoneProfile: UITextField!
    @IBOutlet weak var lbl_nameUser: UILabel!
    @IBOutlet weak var txt_PasswordProfile: UITextField!
    @IBOutlet weak var txtV_AboutMe: UITextView!
    @IBOutlet weak var txt_EmailProfile: UITextField!
    @IBOutlet weak var txt_streetProfile: UITextField!
    @IBOutlet weak var txt_cityProfile: UITextField!
    @IBOutlet weak var txt_stateProfile: UITextField!
    @IBOutlet weak var txt_zipProfile: UITextField!
    private var placesClient: GMSPlacesClient!
    var types = ""
    var fName = ""
    var lName = ""
    var verificationStatus = ""
    var locationArray: [String] = []
    var indexforDeleteLocation : Int? = 0
    var myWorkArr: [String] = []
    var indexforDeleteWork : Int? = 0
    var myLanguageArr: [String] = []
    var indexforDeleteLanguage : Int? = 0
    var myHobbiesArr: [String] = []
    var indexforDeleteHobby : Int? = 0
    var myPetsArr: [String] = []
    var indexforDeletePet : Int? = 0
    var activeTextField: UITextField?
    var timer = Timer()
    let countryPicker = CountryPickerView()
    var editEmail_Phone = ""
    var OTP = ""
    var userID = ""
    var tempID = ""
    var workDataAfterDeletion : DeleteWorkModel?
    var viewModel = GetMyProfileViewModel()
    var profileData : MyProfileModel?
    private var cancellables = Set<AnyCancellable>()
    var getCardArr : [Card]?
    var card_id = ""
    var customerID = ""
    var indx : Int? = 0
    var  phonetobeUpdate = ""
    var isAboutMeStatus = false  // Track editing state
    var isStreetUpdateStatus = false
    var isCityUpdateStatus = false
    var isStateUpdateStatus = false
    var isZipcdeUpdateStatus = false
    let placeholderText = "Write about yourself" // Placeholder text
    @IBOutlet weak var view_MainPassword: UIView!
    let editImage = UIImage(named: "EditPencilicon") // Replace with your edit image
    let saveImage = UIImage(named: "rightSigntick") // Replace with your save image
    var profileIMGURL = ""
    var firstName = ""
    var lastName = ""
    var addNewLocation = "No"
    @IBOutlet weak var infoBtnO: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindVC()
        setupTextView()
        setupTextFields()
        setupProfileViews()
        setupCollectionView(collecV_Place)
        setupCollectionView(collecV_MyWork)
        setupCollectionView(collecV_MyLanguage)
        setupCollectionView(collecV_MyHobbies)
        setupCollectionView(collecV_MyPets)
        configureUserType()
        setupTextViewsAndButtons()
        setupVerificationViews()
        setupPhotoAndProfileViews()
        setupCardTableView()
    }
    private func configureUserType() {
        let user = UserDetail.shared.getUserType()
        view_MainPassword.isHidden = (user != "Email")
        viewModel.apiForGetSavedCard()
    }
    private func setupTextViewsAndButtons() {
        txtV_AboutMe.delegate = self
        btnEditAboutMe.setImage(UIImage(named: "EditPencilicon"), for: .normal)
        keyboardNotifications()
        IQKeyboardManager.shared.enable = false
    }
    private func setupVerificationViews() {
        addCardBtnV.isHidden = false
        cardListV.isHidden = true
        setupFullScreenSubview(view_UploadPhoto)
    }
    private func setupFullScreenSubview(_ subview: UIView) {
        subview.frame = self.view.bounds
        self.view.addSubview(subview)
        subview.isHidden = true
    }
    private func setupPhotoAndProfileViews() {
        view_Dark.layer.cornerRadius = 20
        view_Photo.makeCircular(borderWidth: 3, borderColor: UIColor(red: 58/255, green: 75/255, blue: 76/255, alpha: 0.18))
        view_ProfileDetails.applyRoundedBorder(radius: 15, borderWidth: 0.75, borderColor: .lightGray)
        view_AboutMe.applyRoundedBorder(radius: 15, borderWidth: 0.75, borderColor: .lightGray)
        profileImg.makeCircular()
        profileImg.contentMode = .scaleAspectFill
    }
    private func setupCardTableView() {
        cardNumTblV.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
        cardNumTblV.delegate = self
        cardNumTblV.dataSource = self
        cardNumTblV.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    func setupProfileViews() {
        view_EmailProfile.applyRoundedBorder()
        view_ProfilePassword.applyRoundedBorder()
        view_ProfilePhoneNumber.applyRoundedBorder()
        view_State.applyRoundedBorder()
        view_City.applyRoundedBorder()
        view_Zip.applyRoundedBorder()
        view_Street.applyRoundedBorder()
        viewAddCardBtn.applyLightGrayRoundedBorder()
        view_EmailProfile.applyLightGrayRoundedBorder()
    }
    private func setupCollectionView(_ collectionView: UICollectionView?) {
        let nib = UINib(nibName: "MasterCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "MasterCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        cardNumTblV.layer.removeAllAnimations()
        tblVH_Const.constant = cardNumTblV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    func setupTextFields() {
        txt_streetProfile.delegate = self
        txt_cityProfile.delegate = self
        txt_stateProfile.delegate = self
        txt_zipProfile.delegate = self
        txt_streetProfile.isUserInteractionEnabled = false
        txt_cityProfile.isUserInteractionEnabled = false
        txt_stateProfile.isUserInteractionEnabled = false
        txt_zipProfile.isUserInteractionEnabled = false
        txt_streetProfile.placeholder = "Street"
        txt_cityProfile.placeholder = "City"
        txt_stateProfile.placeholder = "State"
        txt_zipProfile.placeholder = "Zipcode"
    }
    func setupTextView() {
        txtV_AboutMe.delegate = self
        txtV_AboutMe.isEditable = false // Initially non-editable
        txtV_AboutMe.text = placeholderText
        txtV_AboutMe.textColor = UIColor.lightGray // Placeholder color
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        viewModel.getProfile()
    }
    @IBAction func btnEditAboutMe_Tap(_ sender: UIButton) {
        
        if isAboutMeStatus {
             
              if txtV_AboutMe.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || txtV_AboutMe.text == placeholderText {
                  self.showAlert(for: "Please enter your About Me")
                  txtV_AboutMe.becomeFirstResponder()
                  isAboutMeStatus = false
                  txtV_AboutMe.isEditable = true
                  btnEditAboutMe.setImage(UIImage(named: "rightSigntick"), for: .normal)
              } else {
                  txtV_AboutMe.isEditable = false
                  txtV_AboutMe.resignFirstResponder()
                  viewModel.apiForUpdateAboutMe(AboutMe: txtV_AboutMe.text)
                  btnEditAboutMe.setImage(UIImage(named: "EditPencilicon"), for: .normal)
              }
          } else {
             
              txtV_AboutMe.isEditable = true
              txtV_AboutMe.becomeFirstResponder()
              btnEditAboutMe.setImage(UIImage(named: "rightSigntick"), for: .normal)

              if txtV_AboutMe.text == placeholderText {
                  txtV_AboutMe.text = ""
                  txtV_AboutMe.textColor = .black
              }
          }
          isAboutMeStatus.toggle()
  
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtV_AboutMe.text.isEmpty {
            txtV_AboutMe.text = placeholderText
            txtV_AboutMe.textColor = UIColor.lightGray // Reset to placeholder color
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtV_AboutMe.text == placeholderText {
            txtV_AboutMe.text = "" // Clear text when starting to type
            txtV_AboutMe.textColor = UIColor.black // Set text color to normal
        }
    }
    @IBAction func btnEditStreet_Tap(_ sender: UIButton) {
        
       
        if isStreetUpdateStatus {
            // Stop editing and call API
            txt_streetProfile.isUserInteractionEnabled = false
            btnEditStreet.setImage(UIImage(named: "EditPencilicon"), for: .normal)
            txt_streetProfile.resignFirstResponder()
            //  if txt_streetProfile.text != placeholderText {
            print("api call here for edit Street")
            viewModel.apiForUpdateStreet(StreetAddress: self.txt_streetProfile.text ?? "")
        } else {
            // Start editing
            txt_streetProfile.isUserInteractionEnabled = true
            txt_streetProfile.becomeFirstResponder()
            btnEditStreet.setImage(UIImage(named: "rightSigntick"), for: .normal)
        }
        isStreetUpdateStatus.toggle()
    }
    @IBAction func btnEditCity_Tap(_ sender: UIButton) {
        if isCityUpdateStatus {
            // Stop editing and call API
            txt_cityProfile.isUserInteractionEnabled = false
            btnEditCity.setImage(UIImage(named: "EditPencilicon"), for: .normal)
            txt_cityProfile.resignFirstResponder()
            //  if txt_streetProfile.text != placeholderText {
            print("api call here for edit City")
            viewModel.apiForUpdateCity(City: self.txt_cityProfile.text ?? "")
            // }
        } else {
            // Start editing
            txt_cityProfile.isUserInteractionEnabled = true
            txt_cityProfile.becomeFirstResponder()
            btnEditCity.setImage(UIImage(named: "rightSigntick"), for: .normal)
            
        }
        isCityUpdateStatus.toggle()
    }
    @IBAction func btnEditState_Tap(_ sender: UIButton) {
        if isStateUpdateStatus {
            // Stop editing and call API
            txt_stateProfile.isUserInteractionEnabled = false
            btnEditState.setImage(UIImage(named: "EditPencilicon"), for: .normal)
            txt_stateProfile.resignFirstResponder()
            //  if txt_streetProfile.text != placeholderText {
            print("api call here for edit State")
            viewModel.apiForUpdateState(State: self.txt_stateProfile.text ?? "")
            // }
        } else {
            // Start editing
            txt_stateProfile.isUserInteractionEnabled = true
            txt_stateProfile.becomeFirstResponder()
            btnEditState.setImage(UIImage(named: "rightSigntick"), for: .normal)
            
        }
        isStateUpdateStatus.toggle()
        
    }
    @IBAction func btnEditZip_Tap(_ sender: UIButton) {
        
        if isZipcdeUpdateStatus {
            // Stop editing and call API
            txt_zipProfile.isUserInteractionEnabled = false
            btnEditZip.setImage(UIImage(named: "EditPencilicon"), for: .normal)
            txt_zipProfile.resignFirstResponder()
            //  if txt_streetProfile.text != placeholderText {
            print("api call here for edit zipcode")
            viewModel.apiForUpdateZipcode(zip: self.txt_zipProfile.text ?? "")
            // }
        } else {
            // Start editing
            txt_zipProfile.isUserInteractionEnabled = true
            txt_zipProfile.becomeFirstResponder()
            btnEditZip.setImage(UIImage(named: "rightSigntick"), for: .normal)
            
        }
        isZipcdeUpdateStatus.toggle()
        
    }
    @IBAction func btnEditName_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeNameVC") as! ChangeNameVC
        vc.profileIMGURL = self.profileIMGURL
        vc.firstName = self.fName
        vc.lastName = self.lName
        vc.backAction = { strfName , strlName in
            print(strfName,strlName,"Name Recieved")
            let nameUser = "\(strfName)" +  " \(strlName)!"
            // var imgurlss = self.profileData?.profileImage ?? ""
            print(nameUser,"nameUser")
            self.lbl_nameUser.text = "Hey \(nameUser)"
            self.fName = strfName
            self.lName = strlName
        }
        self.present(vc, animated: true)
    }
    @IBAction func btnConfirmEmail_Tap(_ sender: UIButton) {
        print("confirm Email here")
        verificationStatus = "EmailVerified"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPSenderVC") as! OTPSenderVC
        vc.verificationStatus = verificationStatus
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { userID,email, otp, countryCode in
            print(userID,email, otp,"str")
            if userID != "" || email != "" || otp != ""  {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CodeVerifierVC") as! CodeVerifierVC
                vc.verificationStatus = self.verificationStatus
                vc.OTP = otp
                vc.userID = userID
                vc.countryCode = countryCode
                vc.emailtobeUpdate = email
                vc.backAction = { str in
                    print(str,"str recieved")
                    if str == "Yes"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                        vc.comesFrom = self.verificationStatus
                        vc.backCome = {
                            self.view_ConfirmNowEmail.isHidden = true
                            self.view_VerifiedEmail.isHidden = false
                            self.txt_EmailProfile.text = email
                        }
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: true)
                    }
                }
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            } }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
        
    }
    @IBAction func btnLogout_Tap(_ sender: UIButton) {
        print("Logout")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogoutPopUpVC") as! LogoutPopUpVC
        vc.backAction = {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "HomeVCWithoutLoginVC") as! HomeVCWithoutLoginVC
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.present(vc, animated: true)
    }
    @IBAction func btnSwitchToHost_Tap(_ sender: UIButton) {
        print("Switch To Hostt")
        let stryB = UIStoryboard(name: "Host", bundle: nil)
        UserDetail.shared.setlogintType("Host")
        let vc = stryB.instantiateViewController(withIdentifier: "HostMyTabVC") as! HostMyTabVC
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func btnNotification_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnHelpCenter_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HelpCenterVC") as! HelpCenterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnFaq_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnShareFeedback_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShareFeedbackVC") as! ShareFeedbackVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func infoBtn(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Host", bundle: nil)
        let popoverContent = storyboard.instantiateViewController(withIdentifier: "InfoPopVC") as! InfoPopVC
        popoverContent.msg = "Before you can book or host  on the platform the name on Id must match verification documents."
        popoverContent.modalPresentationStyle = .popover
        if let popover = popoverContent.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds // Attach to the button bounds
            popover.permittedArrowDirections = .any // Force the popover to show below the button
            popover.delegate = self
            popoverContent.preferredContentSize = CGSize(width: 230, height: 80)
        }
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Ensures the popover does not change to fullscreen on compact devices.
    }
    
    @IBAction func btnTermCondition_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        vc.comingFrom = "TermCondition"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnPrivacy_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        vc.comingFrom = "Privacy"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnConfirmIndentity_Tap(_ sender: UIButton) {
        
        // Build the inquiry with the view controller as delegate
        let inquiry = Inquiry.from(templateId: "itmpl_yEu1QvFA5fJ1zZ9RbUo1yroGahx2", delegate: self)
            .build()
            .start(from: self) // start inquiry with view controller as presenter
        
    }
    @IBAction func btnConfirmPhone_Tap(_ sender: UIButton) {
        print("confirm phone here")
        verificationStatus = "PhoneVerified"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPSenderVC") as! OTPSenderVC
        vc.verificationStatus = verificationStatus
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { userID,email, otp, countryCode in
            print(userID,email, otp,countryCode,"str Recieved")
            if userID != "" || email != "" || otp != "" || countryCode != "" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CodeVerifierVC") as! CodeVerifierVC
                vc.verificationStatus = self.verificationStatus
                vc.OTP = otp
                vc.userID = userID
                vc.phonetobeUpdate = email
                vc.countryCode = countryCode
                vc.countryCode = countryCode
                vc.backAction = { str in
                    if str == "Yes"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                        vc.comesFrom = self.verificationStatus
                        vc.backCome = {
                            self.view_ConfirmNowPhone.isHidden = true
                            self.view_VerifiedPhone.isHidden = false
                            self.txt_PhoneProfile.text = email
                        }
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: true)
                    }
                }
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
        
    }
    @IBAction func btnverifyIdentity_Tap(_ sender: UIButton) {
        
    }
    @IBAction func btnsaveProfile_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnUploadPropilePhoto_Tao(_ sender: UIButton) {
        self.tabBarController?.setTabBarHidden(true, animated: false)
        view_UploadPhoto.isHidden = false
    }
    @IBAction func btnOutsideUploadPropilePhoto_Tao(_ sender: UIButton) {
        self.tabBarController?.setTabBarHidden(false, animated: false)
        view_UploadPhoto.isHidden = true
    }
    @IBAction func btnCamera_Tap(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        } else {
            // Show an alert if the camera is not available
            let alert = UIAlertController(title: "Camera Unavailable",
                                          message: "Your device doesn't have a camera.",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func paymentMethodDropBtn(_ sender: UIButton){
        if sender.isSelected == false {
            sender.isSelected = true
            self.addCardBtnV.isHidden = true
            self.cardListV.isHidden = false
            paymentDropIcon.image = UIImage(named: "União 106")
        }else{
            sender.isSelected = false
            self.addCardBtnV.isHidden = false
            self.cardListV.isHidden = true
            paymentDropIcon.image = UIImage(named: "dropdownicon")
        }
    }
    @IBAction func btnAddNewCard_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        vc.backAction = {
            self.addCardBtnV.isHidden = true
            self.cardListV.isHidden = false
            self.paymentDropBtnO.isSelected = true
            self.paymentDropIcon.image = UIImage(named: "União 106")
            self.viewModel.apiForGetSavedCard()
        }
        self.present(vc, animated: true)
    }
    @IBAction func btnGallery_Tap(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func editEmailBtn(_ sender: UIButton){
        verificationStatus = "Emailupdate"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPSenderVC") as! OTPSenderVC
        vc.verificationStatus = verificationStatus
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { userID,email, otp, countryCode in
            print(userID,email, otp,"str")
            
            if userID != "" || email != "" || otp != ""  {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CodeVerifierVC") as! CodeVerifierVC
                vc.verificationStatus = self.verificationStatus
                vc.OTP = otp
                vc.userID = userID
                vc.emailtobeUpdate = email
                vc.backAction = { str in
                    if str == "Yes"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                        vc.comesFrom = self.verificationStatus
                        self.txt_EmailProfile.text = email
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: true)
                    }
                }
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            } }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    @IBAction func editPhoneBtn(_ sender: UIButton){
        
        verificationStatus = "UpdatePhone"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPSenderVC") as! OTPSenderVC
        vc.verificationStatus = verificationStatus
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { userID,email, otp, countryCode in
            print(userID,email, otp,countryCode,"str Recieved")
            if userID != "" || email != "" || otp != "" || countryCode != "" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CodeVerifierVC") as! CodeVerifierVC
                vc.verificationStatus = self.verificationStatus
                vc.OTP = otp
                vc.userID = userID
                vc.phonetobeUpdate = email
                vc.countryCode = countryCode
                vc.backAction = { str in
                    if str == "Yes"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                        vc.comesFrom = self.verificationStatus
                        self.txt_PhoneProfile.text = email
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: true)
                    }
                }
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    @IBAction func editPassBtn(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
        vc.comingFrom = "PassChange"
        vc.userID = UserDetail.shared.getUserId()
        vc.backAction = { str in
            print(str,"str")
            if str == "Cancel"{
                print(str)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                vc.comesFrom = "PassChange"
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}
extension ProfileVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImg.image = selectedImage
            view_UploadPhoto.isHidden = true
            viewModel.encodeImageToString(image: selectedImage)
            self.tabBarController?.setTabBarHidden(false, animated: false)
            
        }
        dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileVC :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collecV_Place {
            if self.locationArray.count == 0{
                return 1
            }else if self.locationArray.count >= 2{
                return self.locationArray.count
                
            }else{
                return self.locationArray.count + 1
            }
        } else if collectionView == collecV_MyWork {
            if  self.myWorkArr.count == 0 {
                return 1
            } else if self.myWorkArr.count >= 2{
                return self.myWorkArr.count
                
            }else {
                return myWorkArr.count + 1
            }
        }
        else if collectionView == collecV_MyLanguage {
            if  self.myLanguageArr.count == 0 {
                return 1
            } else if self.myLanguageArr.count >= 2{
                return self.myLanguageArr.count
                
            }else {
                return myLanguageArr.count + 1
            }
        }
        else if collectionView == collecV_MyHobbies {
            if  self.myHobbiesArr.count == 0 {
                return 1
            } else if self.myHobbiesArr.count >= 2{
                return self.myHobbiesArr.count
                
            }else {
                return myHobbiesArr.count + 1
            }
        } else {
            if  self.myPetsArr.count == 0 {
                return 1
            } else if self.myPetsArr.count >= 2{
                return self.myPetsArr.count
                
            }else {
                return myPetsArr.count + 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collecV_Place {
            let cell = collecV_Place.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.locationArray.count {
                // Display language name for regular cells
                let language = self.locationArray[indexPath.item]
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                cell.btnCross.tag = indexPath.row
                cell.imgicon.image = UIImage(named: "location line")
                
                cell.btnCross.addTarget(self, action: #selector(self.DeleteLocation(sender:)), for: .touchUpInside)
                cell.lbl_title.text = locationArray[indexPath.item]  // Assuming you have a label for displaying the language
                cell.lbl_title.sizeToFit()
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewLocation(sender:)), for: .touchUpInside)
            }
            return cell
        } else if collectionView == collecV_MyWork {
            let cell = collecV_MyWork.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.myWorkArr.count {
                // Display language name for regular cells
                let language = self.myWorkArr[indexPath.item]
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                cell.txt_Workname.delegate = self
                cell.btnCross.tag = indexPath.row
                cell.imgicon.image = UIImage(named: "myworkicon")
                cell.btnCross.addTarget(self, action: #selector(self.DeleteWork(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myWorkArr[indexPath.row]
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                cell.txt_Workname.delegate = self
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewWork(sender:)), for: .touchUpInside)
            }
            return cell
        }
        else if collectionView == collecV_MyLanguage {
            let cell = collecV_MyLanguage.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.myLanguageArr.count {
                // Display language name for regular cells
                let language = self.myLanguageArr[indexPath.item]
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                cell.btnCross.tag = indexPath.row
                cell.imgicon.image = UIImage(named: "languageicon")
                cell.btnCross.addTarget(self, action: #selector(self.DeleteLanguage(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myLanguageArr[indexPath.row]
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                types = "laguange"
                cell.txt_Workname.delegate = self
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewLanguage(sender:)), for: .touchUpInside)
            }
            return cell
        } else if collectionView == collecV_MyHobbies {
            let cell = collecV_MyHobbies.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.myHobbiesArr.count {
                // Display language name for regular cells
                let language = self.myHobbiesArr[indexPath.item]
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                cell.txt_Workname.delegate  = self
                cell.btnCross.tag = indexPath.row
                cell.imgicon.image = UIImage(named: "hobbiesicon")
                cell.btnCross.addTarget(self, action: #selector(self.DeleteHobbies(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myHobbiesArr[indexPath.row]
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                types = "Hobbie"
                cell.txt_Workname.delegate = self
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewhobbies(sender:)), for: .touchUpInside)
            }
            return cell
        } else {
            let cell = collecV_MyPets.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.myPetsArr.count {
                // Display language name for regular cells
                let language = self.myPetsArr[indexPath.item]
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                cell.txt_Workname.delegate  = self
                cell.btnCross.tag = indexPath.row
                cell.imgicon.image = UIImage(named: "peticon")
                cell.btnCross.addTarget(self, action: #selector(self.DeletePets(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myPetsArr[indexPath.row]
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                types = "PEts"
                cell.txt_Workname.delegate = self
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewPets(sender:)), for: .touchUpInside)
            }
            return cell
        }
    }
    
    // MARK: - Add location or delete location
    @objc func addNewLocation (sender: UIButton) {
        print(sender.tag)
        self.addNewLocation = "Yes"
        self.autocompleteClicked()
    }
    
    @objc func DeleteLocation (sender: UIButton) {
        print(sender.tag)
        
        self.indexforDeleteLocation = sender.tag
        viewModel.apiForDeletePlace(index: sender.tag)
        
    }
    // MARK: -  Add work or delete work
    @objc func addNewWork (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyWork.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        
        print(types,"category ")
        cell.imgAddicon.image = UIImage(named: "myworkicon")
        cell.view_main.isHidden = true
        cell.view_AddNew.isHidden = true
        cell.view_Type.isHidden = false
        // Ensure the layout is updated
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        // Optionally update the layout for the collection view
        collecV_MyWork.performBatchUpdates(nil)
        
        cell.btnAddWork.tag = sender.tag
        cell.btnAddWork.addTarget(self, action: #selector(self.addNewWorkFinal(sender:)), for: .touchUpInside)
        
    }
    @objc func addNewWorkFinal (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyWork.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        //  cell.widthH_constant.constant = 150
        if cell.txt_Workname.text == "" {
            print("enter name")
            self.showAlert(for: "Add work")
        } else {
            viewModel.apiForAddWork(workName: cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
        }
    }
    @objc func DeleteWork (sender: UIButton) {
        print(sender.tag)
        
        self.indexforDeleteWork = sender.tag
        viewModel.apiForDeleteWork(index: sender.tag)
        
    }
    
    // MARK: - Add Language or Delete Language
    @objc func addNewLanguage (sender: UIButton) {
        print(sender.tag)
        
       
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseLanguageVC") as! ChooseLanguageVC
        vc.mySelectedLanguageArr = self.myLanguageArr
        vc.backAction = { str in
            print(str,"Data Recieved")
            self.viewModel.apiForAddLanguage(languageName: str)
            self.collecV_MyLanguage.reloadData()
        }
        self.present(vc, animated: true)
        
    }
    
    @objc func addNewLaguagefinal (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyLanguage.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        //        cell.widthH_constant.constant = 150
        if cell.txt_Workname.text == "" {
            print("enter name")
            showAlert(for: "Enter Language")
        }
    }
    
    @objc func DeleteLanguage (sender: UIButton) {
        print(sender.tag)
        viewModel.apiForDeleteLanguage(index: sender.tag)
        self.indexforDeleteLanguage = sender.tag
    }
    // MARK: - Add or Delete Hobbies
    @objc func addNewhobbies (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyHobbies.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        
        cell.imgAddicon.image = UIImage(named: "hobbiesicon")
        cell.view_main.isHidden = true
        cell.view_AddNew.isHidden = true
        cell.view_Type.isHidden = false
        
        // Ensure the layout is updated
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        // Optionally update the layout for the collection view
        collecV_MyHobbies.performBatchUpdates(nil)
        cell.btnAddWork.tag = sender.tag
        cell.btnAddWork.addTarget(self, action: #selector(self.addMyHobbiesfinal(sender:)), for: .touchUpInside)
        
    }
    @objc func addMyHobbiesfinal (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyHobbies.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        //  cell.widthH_constant.constant = 150
        if cell.txt_Workname.text == "" {
            print("enter name")
            showAlert(for: "Enter Hobby")
        } else {
            viewModel.apiForAddHobbies(HobbyName: cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
        }
    }
    @objc func DeleteHobbies (sender: UIButton) {
        print(sender.tag)
        viewModel.apiForDeleteHobby(index: sender.tag)
        self.indexforDeleteHobby = sender.tag
        
    }
    // MARK: - ADD Pets or Delete Pets
    
    @objc func addNewPets (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyPets.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        print(types,"category ")
        cell.imgAddicon.image = UIImage(named: "peticon")
        cell.view_main.isHidden = true
        cell.view_AddNew.isHidden = true
        cell.view_Type.isHidden = false
        cell.btnAddWork.tag = sender.tag
        // Ensure the layout is updated
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        // Optionally update the layout for the collection view
        collecV_MyPets.performBatchUpdates(nil)
        cell.btnAddWork.addTarget(self, action: #selector(self.addMyPetsfinal(sender:)), for: .touchUpInside)
    }
    
    @objc func addMyPetsfinal (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyPets.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        if cell.txt_Workname.text == "" {
            print("enter name")
            showAlert(for: "Enter Pet Name")
        } else {
            viewModel.apiForAddPet(PetName: cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
        }
    }
    @objc func DeletePets (sender: UIButton) {
        print(sender.tag)
        self.indexforDeletePet = sender.tag
        viewModel.apiForDeletePet(index: sender.tag)
    }
}
extension ProfileVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCardArr?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cardNumTblV.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        let data = getCardArr?[indexPath.row]
        
        cell.lbl_cardNumber.text = ("**** **** **** \(data?.last4 ?? "")")
        
        if data?.isPreferred == true {
            cell.lbl_Preferred.isHidden = false
        } else {
            cell.lbl_Preferred.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = getCardArr?[indexPath.row]
        self.indx = indexPath.row
        self.viewModel.apiForSetPreferredCard(cardID: data?.cardID ?? "")
    }
}
extension ProfileVC {
    func bindVC(){
        //updateStateResult
        viewModel.$updateZipCodeResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    let txt = response.data?.addedzipcode ?? ""
                    self.txt_zipProfile.text = txt
                    self.btnEditZip.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.txt_zipProfile.isUserInteractionEnabled = false
                })
            }.store(in: &cancellables)
        //updateStateResult
        viewModel.$updateStateResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    let txt = response.data?.addedstate ?? ""
                    self.txt_stateProfile.text = txt
                    self.btnEditState.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.txt_stateProfile.isUserInteractionEnabled = false
                })
            }.store(in: &cancellables)
        //updateCityResult
        viewModel.$updateCityResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    let txt = response.data?.addedCity ?? ""
                    self.txt_cityProfile.text = txt
                    self.btnEditCity.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.txt_cityProfile.isUserInteractionEnabled = false
                })
            }.store(in: &cancellables)
        // updateStreetResult
        
        viewModel.$updateStreetResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    let txt = response.data?.addedStreetAddress ?? ""
                    self.txt_streetProfile.text = txt
                    self.btnEditStreet.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.txt_streetProfile.isUserInteractionEnabled = false
                })
            }.store(in: &cancellables)
        
        // updateAboutMeResult
        viewModel.$updateAbouMeResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    let txt = response.data?.addedAboutMe ?? ""
                    self.txtV_AboutMe.text = txt
                    self.btnEditAboutMe.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.txtV_AboutMe.isEditable = false
                })
            }.store(in: &cancellables)
        
        // updateProfileImage
        viewModel.$getUpdateProfileImgResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    
                    let image = response.data?.profileImageURL ?? ""
                    let imgURL = AppURL.imageURL + image
                    self.profileIMGURL = imgURL
                    
                    UserDetail.shared.setProfileimg(imgURL)
                    
                    let profileurl  = UserDetail.shared.getProfileimg()
                    print(profileurl,"profileurlRAVI profileurlRAVI")
                    
                    if let tabBarVC = self.tabBarController as? MainTabVC {
                        tabBarVC.setProfileTabImage()
                    }
                    
                    self.profileImg.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
                })
            }.store(in: &cancellables)
        
        // AddLanguage
        viewModel.$addLanguageResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    let addedlng = response.data?.addedlanguage ?? ""
                    self.myLanguageArr.append(addedlng)
                    self.collecV_MyLanguage.reloadData()
                })
            }.store(in: &cancellables)
        
        // DeleteLocation
        viewModel.$deleteLanguageResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    self.myLanguageArr.remove(at: self.indexforDeleteLanguage ?? 0)
                    self.collecV_MyLanguage.reloadData()
                })
            }.store(in: &cancellables)
        
        // AddPet
        viewModel.$addPetResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    var addedPet = response.data?.addedPet ?? ""
                    self.myPetsArr.append(addedPet)
                    self.collecV_MyPets.reloadData()
                })
            }.store(in: &cancellables)
        
        // DeleteLocation
        viewModel.$deletePetResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    self.myPetsArr.remove(at: self.indexforDeletePet ?? 0)
                    self.collecV_MyPets.reloadData()
                })
            }.store(in: &cancellables)
        
        
        // AddHobby
        viewModel.$addHobbyResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    var addedHobby = response.data?.addedHobby ?? ""
                    self.myHobbiesArr.append(addedHobby)
                    self.collecV_MyHobbies.reloadData()
                })
            }.store(in: &cancellables)
        
        // DeleteLocation
        viewModel.$deleteHobbyResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    self.myHobbiesArr.remove(at: self.indexforDeleteHobby ?? 0)
                    self.collecV_MyHobbies.reloadData()
                })
            }.store(in: &cancellables)
        
        // AddPlace
        viewModel.$addPlaceResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    let addedLocation = response.data?.addedLocation ?? ""
                    self.locationArray.append(addedLocation)
                    self.collecV_Place.reloadData()
                })
            }.store(in: &cancellables)
        
        // DeleteLocation
        viewModel.$deletePlaceResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    self.locationArray.remove(at: self.indexforDeleteLocation ?? 0)
                    self.collecV_Place.reloadData()
                })
            }.store(in: &cancellables)
        
        // DeleteWork
        viewModel.$deleteWorkResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    self.myWorkArr.remove(at: self.indexforDeleteWork ?? 0)
                    self.collecV_MyWork.reloadData()
                })
            }.store(in: &cancellables)
        
        // AddWork
        viewModel.$addWorkResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    let workAdded = response.data?.addedWork ?? ""
                    self.myWorkArr.append(workAdded)
                    self.collecV_MyWork.reloadData()
                })
            }.store(in: &cancellables)
        
        viewModel.$getMyProfileResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    // self.showToast(response.message ?? "")
                    self.profileData = nil
                    self.profileData = response.data
                    let isEmailVerified = self.profileData?.emailVerified ?? 0
                    let isPhoneVerified = self.profileData?.phoneVerified ?? 0
                    if isEmailVerified == 1 {
                        self.view_ConfirmNowEmail.isHidden = true
                        self.view_VerifiedEmail.isHidden = false
                    } else {
                        self.view_ConfirmNowEmail.isHidden = false
                        self.view_VerifiedEmail.isHidden = true
                    }
                    if isPhoneVerified == 1 {
                        self.view_ConfirmNowPhone.isHidden = true
                        self.view_VerifiedPhone.isHidden = false
                    } else {
                        self.view_ConfirmNowPhone.isHidden = false
                        self.view_VerifiedPhone.isHidden = true
                    }
                    self.identity_verify = self.profileData?.identityVerified ?? 0
                    if  self.identity_verify == 1 {
                        self.view_ConfirmNowIndentity.isHidden = true
                        self.view_VerifiedIndentity.isHidden = false
                    } else {
                        self.view_ConfirmNowIndentity.isHidden = false
                        self.view_VerifiedIndentity.isHidden = true
                    }
                    let imgURL = AppURL.imageURL + (self.profileData?.profileImage ?? "")
                    self.profileIMGURL = imgURL
                    self.profileImg.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
                    let nameUser = "\(self.profileData?.firstName  ?? "")" +  " \(self.profileData?.lastName  ?? "")"
                    print(nameUser,"nameUser")
                    if nameUser != " " {
                        self.lbl_nameUser.text = "Hey \(nameUser)!" } else {
                            self.lbl_nameUser.text = "Hey Guest!"
                        }
                    self.fName = "\(self.profileData?.firstName  ?? "")"
                    self.lName = "\(self.profileData?.lastName  ?? "")"
                    let street =  self.profileData?.street ?? ""
                    let city =  self.profileData?.city ?? ""
                    let state =  self.profileData?.state ?? ""
                    let zip =  self.profileData?.zipCode ?? ""
                    self.txt_streetProfile.text = street
                    self.txt_cityProfile.text = city
                    self.txt_stateProfile.text = state
                    self.txt_zipProfile.text = zip
                    let email = self.profileData?.email ?? ""
                    
                    let Phone = self.profileData?.phoneNumber ?? ""
                    
                    let desc = self.profileData?.aboutMe ?? ""
                   
                    if desc != "" {
                        self.txtV_AboutMe.text = desc
                        self.txtV_AboutMe.textColor = .black
                    } else {
                        self.txtV_AboutMe.textColor = .gray
                        self.txtV_AboutMe.text = self.placeholderText
                    }
                    self.txt_PhoneProfile.text = Phone
                    
                    self.txt_EmailProfile.text = email
                    self.myPetsArr = self.profileData?.pets ?? []
                    self.myHobbiesArr = self.profileData?.hobbies ?? []
                    self.myLanguageArr = self.profileData?.languages ?? []
                    self.locationArray = self.profileData?.whereLive ?? []
                    self.myWorkArr = self.profileData?.myWork ?? []
                    DispatchQueue.main.asyncAfter(deadline: .now() ) {
                        self.collecV_Place.reloadData()
                        self.collecV_MyLanguage.reloadData()
                        self.collecV_MyPets.reloadData()
                        self.collecV_MyWork.reloadData()
                        self.collecV_MyHobbies.reloadData()
                    }
                })
            }.store(in: &cancellables)
        
        //Result Verify Identity
        viewModel.$verifyIdentityResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { [self] response in
                    self.showToast(response.message ?? "")
                    self.view_ConfirmNowIndentity.isHidden = true
                    self.view_VerifiedIndentity.isHidden = false
                })
            }.store(in: &cancellables)
        
        //getSavedCard
        viewModel.$getCardResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    self.getCardArr = response.data?.cards
                    self.customerID = response.data?.stripeCustomerID ?? ""
                    self.cardNumTblV.reloadData()
                })
            }.store(in: &cancellables)
        
        //setPreferredCard
        viewModel.$setPreferredResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.card_id = self.getCardArr?[self.indx ?? 0].cardID ?? ""
                    self.viewModel.apiForGetSavedCard()
                })
            }.store(in: &cancellables)
    }
}
extension ProfileVC:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = 50
        let cellWidth: CGFloat = 150  // Default width
        // Handle different collection views based on which one is being displayed
        switch collectionView {
        case collecV_Place:
            return getSizeForCollectionView(dataArray: locationArray, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
        case collecV_MyWork:
            return getSizeForCollectionView(dataArray: myWorkArr, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
        case collecV_MyLanguage:
            return getSizeForCollectionView(dataArray: myLanguageArr, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
        case collecV_MyHobbies:
            return getSizeForCollectionView(dataArray: myHobbiesArr, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
        case collecV_MyPets:
            return getSizeForCollectionView(dataArray: myPetsArr, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
        default:
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    // Generalized function to calculate cell size based on the array and indexPath
    func getSizeForCollectionView(dataArray: [String], indexPath: IndexPath, defaultWidth: CGFloat, cellHeight: CGFloat) -> CGSize {
        var cellWidth = defaultWidth
        var text = ""
        if dataArray.count == 1 {
            if indexPath.item == 0 {
                text = dataArray[0]
                print(text)
                if let calculatedWidth = calculateWidth(for: text) {
                    cellWidth = calculatedWidth
                    return CGSize(width: cellWidth, height: cellHeight)
                }
            }
            if indexPath.item == 1 {
                return CGSize(width: cellWidth, height: cellHeight)
            }
        }else if dataArray.count == 2{
            if indexPath.item == 0 {
                text = dataArray[0]
                if let calculatedWidth = calculateWidth(for: text) {
                    cellWidth = calculatedWidth
                    return CGSize(width: cellWidth, height: cellHeight)
                }
            }
            if indexPath.item == 1 {
                text = dataArray[1]
                if let calculatedWidth = calculateWidth(for: text) {
                    cellWidth = calculatedWidth
                    return CGSize(width: cellWidth, height: cellHeight)
                }
            }
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func calculateWidth(for text: String) -> CGFloat? {
        guard !text.isEmpty else { return nil }
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15) // Set a font if needed
        // Calculate the width of the text
        let textAttributes = [NSAttributedString.Key.font: label.font!]
        let textWidth = (text as NSString).size(withAttributes: textAttributes).width
        // Add some padding to the calculated text width
        let padding: CGFloat = 70
        let dynamicWidth = textWidth + padding
        print(dynamicWidth, "Dynamic Width")
        return dynamicWidth
    }
    // Set minimum line spacing and inter-item spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
}
extension ProfileVC: CLLocationManagerDelegate{
    @objc func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        autocompleteController.autocompleteFilter = filter
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
        autocompleteController.tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]//.white]
    }
}
extension ProfileVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        guard let placeName = place.name else { return }
        print("Place name: \(placeName)")
        print("Place ID: \(place.placeID ?? "N/A")")
        print("Latitude: \(place.coordinate.latitude)")
        print("Longitude: \(place.coordinate.longitude)")
        print("Formatted Address: \(place.formattedAddress ?? "N/A")")
        // Save to UserDefaults
        UserDefaults.standard.set("\(place.coordinate.latitude)", forKey: "selectedlat")
        UserDefaults.standard.set("\(place.coordinate.longitude)", forKey: "selectedLong")
        if addNewLocation == "Yes" {
            print("PlaceAPI triggered")
            viewModel.apiForAddPlace(PlaceName: placeName)
            NotificationCenter.default.post(
                name: NSNotification.Name("currentLocation"),
                object: ["latitude": "\(place.coordinate.latitude)", "longitude": "\(place.coordinate.longitude)"]
            )
        } else {
            updateAddressFields(from: place.coordinate, fallbackStreet: placeName)
        }
        dismiss(animated: true, completion: nil)
    }
    private func updateAddressFields(from coordinate: CLLocationCoordinate2D, fallbackStreet: String) {
        extractAddressDetails(from: coordinate) { [weak self] street, city, state, zip in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.txt_streetProfile.text = street?.isEmpty == false ? street : fallbackStreet
                self.txt_cityProfile.text = city
                self.txt_stateProfile.text = state
                self.txt_zipProfile.text = zip
                [self.btnEditCity, self.btnEditState, self.btnEditZip].forEach {
                    $0?.setImage(UIImage(named: "rightSigntick"), for: .normal)
                }
                self.isCityUpdateStatus = true
                self.isStateUpdateStatus = true
                self.isZipcdeUpdateStatus = true
            }
        }
    }
    private func extractAddressDetails(from coordinate: CLLocationCoordinate2D,
                                       completion: @escaping (_ street: String?, _ city: String?, _ state: String?, _ zip: String?) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                print("Reverse geocode failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil, nil, nil, nil)
                return
            }
            let street = [placemark.subThoroughfare, placemark.thoroughfare]
                .compactMap { $0 }
                .joined(separator: " ")
            completion(street, placemark.locality, placemark.administrativeArea, placemark.postalCode)
        }
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Autocomplete Error: \(error.localizedDescription)")
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension ProfileVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            //Default character limit: 30
            return updatedText.count <= 20
    }
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let animationDuration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        // Adjust the bottom constraint based on the keyboard's height
        tbl_bottom_h.constant = keyboardHeight
        // Get the visible cells of the collection view and update the label widths dynamically
        for cell in self.collecV_Place.visibleCells {
            if let myCell = cell as? MasterCell {
                let labelText = myCell.lbl_title.text ?? ""
                let font = myCell.lbl_title.font ?? UIFont.systemFont(ofSize: 12)
                // Calculate the dynamic width of the label's text
                let textAttributes = [NSAttributedString.Key.font: font]
                let textWidth = (labelText as NSString).size(withAttributes: textAttributes).width
                let padding: CGFloat = 20 // Add some padding
                // Update the label's width constraint
                myCell.lbl_title.translatesAutoresizingMaskIntoConstraints = false
                myCell.lbl_title.widthAnchor.constraint(equalToConstant: textWidth + padding).isActive = true
            }
        }
        // Update layout with animation
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
        // Scroll the active text field into view (if applicable)
        if let activeField = self.activeTextField {
            scrollViewToVisible(activeField, withKeyboardHeight: keyboardHeight)
        }
    }
    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let animationDuration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        // Reset the bottom constraint
        tbl_bottom_h.constant = 24 // original constraint value
        // Update layout with animation
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    func scrollViewToVisible(_ textField: UITextField, withKeyboardHeight keyboardHeight: CGFloat) {
        // Ensure the scrollView exists
        guard let scrollView = self.scrollV else { return }
        // Calculate the visible area of the scrollView by subtracting the keyboard height
        var visibleRect = scrollView.frame
        visibleRect.size.height -= keyboardHeight
        // Convert the text field's frame to the scroll view's coordinate system
        let textFieldFrame = textField.convert(textField.bounds, to: scrollView)
        // Check if the text field is outside the visible area
        if !visibleRect.contains(textFieldFrame.origin) {
            // Scroll the scroll view so the text field is visible
            scrollView.scrollRectToVisible(textFieldFrame, animated: true)
        }
    }
    // Track the active text field when editing begins
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        if textField == txt_streetProfile {
            self.addNewLocation = "No"
            self.autocompleteClicked()
        }
    }
    // Clear the active text field when editing ends
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    func keyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
}
extension ProfileVC: InquiryDelegate {
    func inquiryComplete(inquiryId: String, status: String, fields: [String : InquiryField]) {
        print(inquiryId)
        print(status)
        if status ==  "completed" {
            self.identity_verify = 1
            self.view_VerifiedIndentity.isHidden = false
            self.view_ConfirmNowIndentity.isHidden = true
        } else {
            self.identity_verify = 0
            self.view_VerifiedIndentity.isHidden = true
            self.view_ConfirmNowIndentity.isHidden = false
        }
        viewModel.apiForVerifyIdentity(identityverify: self.identity_verify ?? 0)
        // Inquiry completed
    }
    func inquiryCanceled(inquiryId: String?, sessionToken: String?) {
        // Inquiry cancelled by user
    }
    func inquiryError(_ error: Error) {
        // Inquiry errored
    }
}
