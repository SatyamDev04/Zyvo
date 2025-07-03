//
//  CreateProfileVC.swift
//  Zyvo
//
//  Created by ravi on 16/10/24.
//

import UIKit
import GooglePlaces
import IQKeyboardManagerSwift
import CountryPickerView
import Combine
import Persona2
//import IQKeyboardManager

class CreateProfileVC: UIViewController,UITextViewDelegate {
    
    var OTP = ""
    var userID = ""
    var tempID = ""
    var identity_verify : Int? = 0
    
    @IBOutlet weak var btnEditAboutMe: UIButton!
    @IBOutlet weak var view_ConfirmNowEmail: UIView!
    @IBOutlet weak var view_VerifiedEmail: UIView!
    @IBOutlet weak var view_VerifiedPhone: UIView!
    @IBOutlet weak var view_ConfirmNowPhone: UIView!
    
   
    
    @IBOutlet weak var view_verifyIndentityConfirmNow: UIView!
    @IBOutlet weak var view_verifiedIndentity: UIView!
    
    @IBOutlet weak var scrollV: UIScrollView!
    //let keyboardSettings = KeyboardSettings(bottomType: .categories)
    @IBOutlet weak var view_timeResend: UIView!
    @IBOutlet weak var view_OTPtxt: DPOTPView!
    @IBOutlet var view_OTPVerification: UIView!
    @IBOutlet weak var view_Phone: UIView!
    @IBOutlet weak var view_Email: UIView!
    @IBOutlet weak var txt_EmailVerification: UITextField!
    @IBOutlet weak var view_EmailVerificaiton: UIView!
    @IBOutlet weak var txt_PhoneVerification: UITextField!
    @IBOutlet weak var view_phoneVerification: UIView!
    @IBOutlet var view_Verification: UIView!
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
    @IBOutlet weak var viewVerification: UIView!
    @IBOutlet weak var tbl_bottom_h: NSLayoutConstraint!
    @IBOutlet weak var verificationDetaiilLbl: UILabel!
    @IBOutlet weak var resendBtnO: UIButton!
    @IBOutlet weak var OTPverificationDetaiilLbl: UILabel!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var infoBtnO: UIButton!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var txt_aboutMe: UITextView!
    var verificationStatus = ""
    private var placesClient: GMSPlacesClient!
    // var imageArray = [Country]()
    var types = ""
    var locationArray: [String] = [ ]
    var myWorkArr: [String] = []
    var myLanguageArr: [String] = []
    var myHobbiesArr: [String] = []
    var myPetsArr: [String] = []
    var activeTextField: UITextField?
    let infoLabel = UILabel()
    var timer = Timer()
    let countryPicker = CountryPickerView()
    var SignUpWith = ""
    var editEmail_Phone = ""
    
    var firstName = ""
    var lastName = ""
    var fullName = ""
    var countryCode = ""
   
    var expectedRegion = ""
    
    var viewModel = MyProfileViewModel()
    
    var profileData : MyProfileModel?
    
    var viewModelVerifyEmail = EmailVerificationViewModel()
    
    var viewModelEmailVerifyOTP = OTPEmailVerifyViewModel()
    
    
    private var viewModelVerifyPhone = PhoneVerificationViewModel_CreateProfile()
    
    var viewModelPhoneVerifyOTP = OTPVerifyPhoneViewModel()
    
    let placeholderText = "Describe here about yourself...."
    let validator = PhoneNumberValidator()
    private var cancellables = Set<AnyCancellable>()
    var profileIMGURL = ""
    var isAboutMeStatus = false
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImg.makeCircular()
        profileImg.contentMode = .scaleAspectFill
        bindVC()
        bindViewModel()
        
        txt_aboutMe.delegate = self
        txt_aboutMe.text = placeholderText
        txt_aboutMe.textColor = .lightGray
        
        let fullName = self.fullName
        let nameComponents = fullName.components(separatedBy: " ")

        let firstName = nameComponents.first ?? ""
        let lastName = nameComponents.dropFirst().joined(separator: " ")
        self.firstName = firstName
        self.lastName = lastName
        print("First Name: \(firstName)")
        print("Last Name: \(lastName)")
        
        self.lbl_UserName.text = "Hey \(self.firstName)" + " \(self.lastName)!"
        
        self.keyboardNotifications()
        IQKeyboardManager.shared.enable = false
        
        
        countryCodeTF.text = "🇺🇸 +1"
        viewModelVerifyPhone.countryCode = "+1"
        
        self.countryCode =  "+1"
        self.expectedRegion = "US"
       
        txt_PhoneVerification.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        txt_PhoneVerification.delegate = self
        txt_PhoneVerification.keyboardType = .numberPad // Set keyboard to number pad
        
        view_OTPtxt.dpOTPViewDelegate = self
        view_timeResend.isHidden = true
        
        view_Email.layer.cornerRadius = view_Email.layer.frame.height / 2
        view_Email.layer.borderWidth = 1
        view_Email.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Phone.layer.cornerRadius = view_Phone.layer.frame.height / 2
        view_Phone.layer.borderWidth = 1
        view_Phone.layer.borderColor = UIColor.lightGray.cgColor
        
        placesClient = GMSPlacesClient.shared()
        
        view_phoneVerification.isHidden = true
        view_EmailVerificaiton.isHidden = true
        
        view_UploadPhoto.frame = self.view.bounds
        self.view.addSubview(view_UploadPhoto)
        view_UploadPhoto.isHidden = true
        
        view_Verification.frame = self.view.bounds
        self.view.addSubview(view_Verification)
        view_Verification.isHidden = true
        
        view_OTPVerification.frame = self.view.bounds
        self.view.addSubview(view_OTPVerification)
        view_OTPVerification.isHidden = true
        // view_Dark.layer.cornerRadius = 20
        view_Photo.layer.cornerRadius = view_Photo.layer.frame.height / 2
        view_Photo.layer.borderWidth = 3
        view_Photo.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/266, alpha: 0.3).cgColor
        
        view_ProfileDetails.layer.cornerRadius = 15
        view_ProfileDetails.layer.borderWidth = 0.75
        view_ProfileDetails.layer.borderColor = UIColor.lightGray.cgColor
        
        countryPicker.delegate = self
        
        view_AboutMe.layer.cornerRadius = 15
        view_AboutMe.layer.borderWidth = 0.75
        view_AboutMe.layer.borderColor = UIColor.lightGray.cgColor
        
        let nib2 = UINib(nibName: "MasterCell", bundle: nil)
        collecV_Place?.register(nib2, forCellWithReuseIdentifier: "MasterCell")
        collecV_Place.delegate = self
        collecV_Place.dataSource = self
        
        let nib1 = UINib(nibName: "MasterCell", bundle: nil)
        collecV_MyWork?.register(nib1, forCellWithReuseIdentifier: "MasterCell")
        collecV_MyWork.delegate = self
        collecV_MyWork.dataSource = self
        
        let nib3 = UINib(nibName: "MasterCell", bundle: nil)
        collecV_MyLanguage?.register(nib3, forCellWithReuseIdentifier: "MasterCell")
        collecV_MyLanguage.delegate = self
        collecV_MyLanguage.dataSource = self
        
        let nib4 = UINib(nibName: "MasterCell", bundle: nil)
        collecV_MyHobbies?.register(nib4, forCellWithReuseIdentifier: "MasterCell")
        collecV_MyHobbies.delegate = self
        collecV_MyHobbies.dataSource = self
        
        let nib5 = UINib(nibName: "MasterCell", bundle: nil)
        collecV_MyPets?.register(nib5, forCellWithReuseIdentifier: "MasterCell")
        collecV_MyPets.delegate = self
        collecV_MyPets.dataSource = self
        
        infoLabel.text = "Before you can book or host  on the platform the name on Id must match verification documents."
        
        // Set custom font "Poppins" with size 15
        if let customFont = UIFont(name: "Poppins-Regular", size: 8) {
            infoLabel.font = customFont
        } else {
            print("Custom font 'Poppins-Regular' not found. Ensure it's added to the project.")
        }
        infoLabel.textAlignment = .center
        infoLabel.backgroundColor = UIColor.white
        infoLabel.textColor = .black
        infoLabel.layer.cornerRadius = 8
        infoLabel.layer.borderWidth = 1
        infoLabel.numberOfLines = 3
        infoLabel.layer.borderColor = UIColor.lightGray.cgColor
        infoLabel.clipsToBounds = true
        infoLabel.frame = CGRect(x: infoBtnO.frame.midX + 2 , y: infoBtnO.frame.maxY - 120 , width: 210, height: 40)
        viewModel.getProfile()
        
    }
    
    @objc func textFieldDidChange() {
        guard let number = txt_PhoneVerification.text,
              let code = countryCodeTF.text else {
            continueButton.isEnabled = false
            return
        }
        
        let phoneNumber = (txt_PhoneVerification.text ?? "")
        let regionCode = expectedRegion // or use "IN" directly
        
        let isValid = validator.isValidMobileNumber(countryCode: self.countryCode, number: "\(self.countryCode)\(phoneNumber)")
        print("Is valid: \(isValid)")
        
        print("Is valid: \(isValid)")
        if isValid == true {
            continueButton.isEnabled = true
        } else {
            continueButton.isEnabled = false
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txt_aboutMe.text == placeholderText {
            txt_aboutMe.text = ""
            txt_aboutMe.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txt_aboutMe.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            txt_aboutMe.text = placeholderText
            txt_aboutMe.textColor = .lightGray
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        let usertype = UserDetail.shared.getUserType()
        if usertype == "Email" {
            view_ConfirmNowEmail.isHidden = true
            view_VerifiedEmail.isHidden = false
        }
        if usertype == "Phone" {
            view_ConfirmNowPhone.isHidden = true
            view_VerifiedPhone.isHidden = false
            continueButton.isEnabled = true // Initially disabled
        }
    }
    private func bindViewModel() {
        
        viewModelEmailVerifyOTP.userID = self.userID
        viewModelEmailVerifyOTP.otpCode = self.OTP
        viewModelPhoneVerifyOTP.userID = self.userID
        viewModelPhoneVerifyOTP.otpCode = self.OTP
        
        txt_EmailVerification.textPublisher
            .compactMap { $0 }
            .assign(to: \.email, on: viewModelVerifyEmail)
            .store(in: &cancellables)
        
        txt_PhoneVerification.textPublisher
            .compactMap { $0 }
            .assign(to: \.phone, on: viewModelVerifyPhone)
            .store(in: &cancellables)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            if textField == txt_PhoneVerification {
                // Allow only numbers
                let isNumeric = updatedText.allSatisfy { $0.isNumber }
                // Allow 10 or 11 digits (common phone number lengths)
                return isNumeric && (updatedText.count <= 11)
            } else {
                // Default character limit: 30
                return updatedText.count <= 30
            }
//        // Get the current text
//        if textField == txt_PhoneVerification {
//            let currentText = txt_PhoneVerification.text ?? ""
//            // Create the updated text after replacement
//            guard let rangeOfTextToReplace = Range(range, in: currentText) else { return false }
//            let updatedText = currentText.replacingCharacters(in: rangeOfTextToReplace, with: string)
//            // Allow only numbers and a maximum of 10 digits
//            let isNumeric = updatedText.allSatisfy { $0.isNumber }
//           // return isNumeric && updatedText.count <= 10
//            return isNumeric && updatedText.count <= 9 || updatedText.count <= 10 || updatedText.count <= 11
//        }
//        // Allow changes for other text fields
//        return true
    }
    
    @IBAction func btnEditAboutMe_Tap(_ sender: UIButton) {
        if isAboutMeStatus {
             
              if txt_aboutMe.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || txt_aboutMe.text == placeholderText {
                  self.showAlert(for: "Please enter your About Me")
                  isAboutMeStatus = false
                  txt_aboutMe.isEditable = true
                  txt_aboutMe.becomeFirstResponder()
                  btnEditAboutMe.setImage(UIImage(named: "rightSigntick"), for: .normal)
              } else {
                  txt_aboutMe.isEditable = false
                  txt_aboutMe.resignFirstResponder()
                  viewModel.apiForUpdateAboutMe(AboutMe: txt_aboutMe.text)
                  btnEditAboutMe.setImage(UIImage(named: "EditPencilicon"), for: .normal)
              }
          } else {
             
              txt_aboutMe.isEditable = true
              txt_aboutMe.becomeFirstResponder()
              btnEditAboutMe.setImage(UIImage(named: "rightSigntick"), for: .normal)

              if txt_aboutMe.text == placeholderText {
                  txt_aboutMe.text = ""
                  txt_aboutMe.textColor = .black
              }
          }
          isAboutMeStatus.toggle()
    }
    
    @IBAction func btnEditName_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeNameVC") as! ChangeNameVC
        
        vc.backAction = { fname, lname in
            print(fname, lname,"Data Recieved")
            self.firstName = fname
            self.lastName = lname
            self.viewModel.first_name = self.firstName
            self.viewModel.last_name = self.lastName
            self.lbl_UserName.text = "Hey \(fname)" + " \(lname)!"
            UserDetail.shared.setName("\(fname)" + " \(lname)")
        }
        vc.profileIMGURL = self.profileIMGURL
        vc.firstName = self.firstName
        vc.lastName = self.lastName
        viewModel.first_name = self.firstName
        viewModel.last_name = self.lastName
        
        self.present(vc, animated: true)
    }
    
    @IBAction func btnConfirmIndentity_Tap(_ sender: UIButton) {
        
        // Build the inquiry with the view controller as delegate
        let inquiry = Inquiry.from(templateId: "itmpl_yEu1QvFA5fJ1zZ9RbUo1yroGahx2", delegate: self)
            .build()
            .start(from: self) // start inquiry with view controller as presenter
        
    }
    
    @IBAction func btnConfirmEmail_Tap(_ sender: UIButton) {
        
        view_Verification.isHidden = false
        verificationStatus = "EmailVerified"
        self.verificationDetaiilLbl.text = "Enter your email for\nthe verification process,we will send\n4 digits code to your email."
        if verificationStatus == "EmailVerified" {
            view_phoneVerification.isHidden = true
            view_EmailVerificaiton.isHidden = false
        }
    }
    @IBAction func btnSelectCountry_Tap(_ sender: UIButton) {
        countryPicker.showCountriesList(from:self)
    }
    
    @IBAction func btnCrossOTPVerification_Tap(_ sender: UIButton) {
        self.editEmail_Phone = ""
        self.txt_EmailVerification.text = ""
        self.txt_PhoneVerification.text = ""
        countryCodeTF.text = "🇺🇸 +1"
        viewModelVerifyPhone.countryCode = "+1"
        self.countryCode =  "+1"
        self.expectedRegion = "US"
        view_OTPVerification.isHidden = true
        self.timer.invalidate()
    }
    
    @IBAction func btnSubmitOTPVerification_Tap(_ sender: UIButton) {
        
        if verificationStatus == "EmailVerified" {
            if view_OTPtxt.text?.count != 4 {
                self.showAlert(for: "Enter Verification Code")
            } else {
                viewModelEmailVerifyOTP.verifyEmailOtp()
            }
        }
        if verificationStatus == "PhoneVerified" {
            if view_OTPtxt.text?.count != 4 {
                self.showAlert(for: "Enter Verification Code")
            } else {
                viewModelPhoneVerifyOTP.verifyPhoneOtp()
            }
        }
    }
    @IBAction func btnResendOTPVerificaiton_Tap(_ sender: UIButton) {
        if verificationStatus == "EmailVerified" {
            viewModelVerifyEmail.apiforEmailVerification()
        }
        if verificationStatus == "PhoneVerified" {
            viewModelVerifyPhone.apiForPhoneVerification()
        }
        view_timeResend.isHidden = false
        sender.isUserInteractionEnabled = false
        sender.setTitleColor(UIColor.lightGray, for: .normal)
        var runCount = Int()
        runCount = 60
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            print("Timer fired!")
            runCount -= 1
            let minutes = runCount / 60
            let seconds = runCount % 60
            self.lbl_time.text = String(format: "%02d:%02dsec", minutes, seconds)
            if runCount == 0 {
                self.lbl_time.text = "00:00sec"
                self.view_timeResend.isHidden = true
                sender.isUserInteractionEnabled = true
                sender.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
                timer.invalidate()
            }
        }
    }
    @IBAction func btnCrossVerificaiton_Tap(_ sender: UIButton) {
        self.editEmail_Phone = ""
        self.txt_EmailVerification.text = ""
        self.txt_PhoneVerification.text = ""
        countryCodeTF.text = "🇺🇸 +1"
        viewModelVerifyPhone.countryCode = "+1"
        self.countryCode =  "+1"
        self.expectedRegion = "US"
        view_Verification.isHidden = true
    }
    
    @IBAction func btnConfirmPhone_Tap(_ sender: UIButton) {
        countryCodeTF.text = "🇺🇸 +1"
        view_Verification.isHidden = false
        verificationStatus = "PhoneVerified"
        self.verificationDetaiilLbl.text = "Enter your phone for\nthe verification process,we will send\n4 digits code to your phone."
        if verificationStatus == "PhoneVerified" {
            view_phoneVerification.isHidden = false
            view_EmailVerificaiton.isHidden = true
        }
    }
    @IBAction func btnverifyIdentity_Tap(_ sender: UIButton) {
        
    }
    
    @IBAction func infoBtn(_ sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
            infoLabel.removeFromSuperview()
        }else{
            sender.isSelected = true
            viewVerification.addSubview(infoLabel)
        }
    }
    
    @IBAction func btnsaveProfile_Tap(_ sender: UIButton) {
        if firstName == "" || lastName == "" {
            self.showAlert(for: "Please update name")
        } else if locationArray.count == 0 {
            self.showAlert(for: "Please add location Where I live")
        } else if myLanguageArr.count == 0 {
            self.showAlert(for: "Please select my language")
        } else {
            viewModel.where_live = self.locationArray
            viewModel.works = self.myWorkArr
            viewModel.languages = self.myLanguageArr
            viewModel.hobbies = self.myHobbiesArr
            viewModel.pets = self.myPetsArr
            viewModel.about_me = self.txt_aboutMe.text
            viewModel.identity_verify = self.identity_verify ?? 0
            viewModel.encodeImageToString(image: profileImg.image ?? UIImage())
        }
    }
    
    @IBAction func btnskipProfile_Tap(_ sender: UIButton) {
        if lbl_UserName.text == "Hey Guest!" {
            self.showAlert(for: "Kindly update at least your name.")
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func btnSubmit_Verification(_ sender: UIButton) {
        
        if verificationStatus == "PhoneVerified" {
            
            guard viewModelVerifyPhone.isloginValid else {
                
                if let error = viewModelVerifyPhone.errorMessage {
                    self.showAlert(for: error)
                }
                
                return
            }
            
            viewModelVerifyPhone.apiForPhoneVerification()
            
        }
        if verificationStatus == "EmailVerified" {
            
            guard viewModelVerifyEmail.isSignUpValid else {
                if let error = viewModelVerifyEmail.errorMessage {
                    self.showAlert(for: error)
                }
                return
            }
            viewModelVerifyEmail.apiforEmailVerification()
            
        }
        
    }
    
    @IBAction func btnUploadPropilePhoto_Tao(_ sender: UIButton) {
        view_UploadPhoto.isHidden = false
    }
    
    @IBAction func btnOutsideUploadPropilePhoto_Tao(_ sender: UIButton) {
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
    
    @IBAction func btnGallery_Tap(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension CreateProfileVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImg.image = selectedImage
            viewModel.encodeImageToStringCreateProfile(image: selectedImage)
            
            view_UploadPhoto.isHidden = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateProfileVC :UICollectionViewDelegate,UICollectionViewDataSource {
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
                cell.btnCross.tag = indexPath.row
                cell.txt_Workname.delegate = self
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
                //cell.imgAddicon.image = UIImage(named: "myworkicon")
                
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
                
                cell.btnCross.tag = indexPath.row
                cell.imgicon.image = UIImage(named: "hobbiesicon")
                //cell.imgAddicon.image = UIImage(named: "myworkicon")
                
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
                cell.btnCross.tag = indexPath.row
                cell.imgicon.image = UIImage(named: "peticon")
                cell.btnCross.addTarget(self, action: #selector(self.DeletePets(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myPetsArr[indexPath.row]  // Assuming you have a label for displaying the language
                
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
        self.autocompleteClicked()
    }
    
    @objc func DeleteLocation (sender: UIButton) {
        print(sender.tag)
        locationArray.remove(at: sender.tag)
        self.collecV_Place.reloadData()
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
        //        cell.widthH_constant.constant = 43
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
        } else {
            myWorkArr.append(cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
            self.collecV_MyWork.reloadData() }
    }
    @objc func DeleteWork (sender: UIButton) {
        print(sender.tag)
        myWorkArr.remove(at: sender.tag)
        self.collecV_MyWork.reloadData()
    }
    
    // MARK: - Add Language or Delete Language
    @objc func addNewLanguage (sender: UIButton) {
        print(sender.tag)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseLanguageVC") as! ChooseLanguageVC
        vc.mySelectedLanguageArr = self.myLanguageArr
        vc.backAction = { str in
            print(str,"Data Recieved")
            self.myLanguageArr.append(str)
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
        } else {
            myLanguageArr.append(cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
            self.collecV_MyLanguage.reloadData() }
    }
    
    @objc func DeleteLanguage (sender: UIButton) {
        print(sender.tag)
        myLanguageArr.remove(at: sender.tag)
        self.collecV_MyLanguage.reloadData()
    }
    
    
    // MARK: - Add or Delete Hobbies
    @objc func addNewhobbies (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyHobbies.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        
        cell.imgAddicon.image = UIImage(named: "hobbiesicon")
        cell.view_main.isHidden = true
        cell.view_AddNew.isHidden = true
        cell.view_Type.isHidden = false
        //        cell.widthH_constant.constant = 43
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
        } else {
            myHobbiesArr.append(cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
            self.collecV_MyHobbies.reloadData() }
    }
    @objc func DeleteHobbies (sender: UIButton) {
        print(sender.tag)
        myHobbiesArr.remove(at: sender.tag)
        self.collecV_MyHobbies.reloadData()
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
        
        //        cell.widthH_constant.constant = 43
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
        } else {
            myPetsArr.append(cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
            self.collecV_MyPets.reloadData() }
    }
    
    @objc func DeletePets (sender: UIButton) {
        print(sender.tag)
        myPetsArr.remove(at: sender.tag)
        self.collecV_MyPets.reloadData()
    }
    
}

extension CreateProfileVC:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = 50
        var cellWidth: CGFloat = 150  // Default width
        
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


extension CreateProfileVC: CLLocationManagerDelegate{
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

extension CreateProfileVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(String(describing: place.placeID))")
        print("Place attributions: \(String(describing: place.attributions))")
        print("Place latitude: \(place.coordinate.latitude)")
        print("Place longitude: \(place.coordinate.longitude)")
        
        print("Place formattedAddress: \(String(describing: place.formattedAddress!))")
        if place.name != nil {
            UserDefaults.standard.set("\(place.coordinate.latitude)", forKey: "selectedlat")
            UserDefaults.standard.set("\(place.coordinate.longitude)", forKey: "selectedLong")
            
            self.locationArray.append("\(place.name ?? "")")
            self.collecV_Place.reloadData()
            
            NotificationCenter.default.post(name: NSNotification.Name("currentLocation"), object: ["latitude":"\(place.coordinate.latitude)","longitude":"\(place.coordinate.longitude)"])
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension CreateProfileVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Use the name and phone code directly
        let flag = country.code.flagEmoji // Access the flag emoji as String
        let name = country.name
        let code = country.phoneCode
        countryCodeTF.text = "\(flag) (\(code))"
        self.countryCode = "\(code)"
        viewModelVerifyPhone.countryCode = self.countryCode
        let phoneNumber = (txt_PhoneVerification.text ?? "")
        let isValid =  validator.isValidMobileNumber(countryCode: self.countryCode, number: "\(self.countryCode)\(phoneNumber)")
        print("Is valid: \(isValid)")
        if isValid == true {
            continueButton.isEnabled = true
        } else {
            continueButton.isEnabled = false
        }
    }
}

struct location {
    var loacationName: String
    var latitude: String
    var longitude: String
}

extension CreateProfileVC: UITextFieldDelegate {
    
   
    
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
    }
    
    // Clear the active text field when editing ends
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
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

extension CreateProfileVC {
    private func tobeVerifyPhone(OTP:String,Phone:String,userId:String){
        
        viewModelPhoneVerifyOTP.otpCode = OTP
        viewModelPhoneVerifyOTP.userID = userId
        view_Verification.isHidden = true
        view_OTPVerification.isHidden = false
        self.OTPverificationDetaiilLbl.text = "Please type the verification code send to \(Phone)"
    }
    
    private func tobeVerifyEmail(OTP:String,Email:String,userId:String){
        
        viewModelEmailVerifyOTP.otpCode = OTP
        viewModelEmailVerifyOTP.userID = userId
        view_Verification.isHidden = true
        view_OTPVerification.isHidden = false
        self.OTPverificationDetaiilLbl.text = "Please type the verification code send to \(Email)"
        
    }
    func bindVC(){
        
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
                        self.view_verifyIndentityConfirmNow.isHidden = true
                        self.view_verifiedIndentity.isHidden = false
                    } else {
                        self.view_verifyIndentityConfirmNow.isHidden = false
                        self.view_verifiedIndentity.isHidden = true
                    }
                    let imgURL = AppURL.imageURL + (self.profileData?.profileImage ?? "")
                    self.profileIMGURL = imgURL
                    self.profileImg.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
                    let nameUser = "\(self.profileData?.firstName  ?? "")" +  " \(self.profileData?.lastName  ?? "")"
                    print(nameUser,"nameUser")
                    if nameUser != " " {
                        self.lbl_UserName.text = "Hey \(nameUser)!" } else {
                            self.lbl_UserName.text = "Hey Guest!"
                        }
                    self.firstName = "\(self.profileData?.firstName  ?? "")"
                    self.lastName = "\(self.profileData?.lastName  ?? "")"
                    let street =  self.profileData?.street ?? ""
                    let city =  self.profileData?.city ?? ""
                    let state =  self.profileData?.state ?? ""
                    let zip =  self.profileData?.zipCode ?? ""
                   
                    let email = self.profileData?.email ?? ""
                    
                    let Phone = self.profileData?.phoneNumber ?? ""
                    
                    let desc = self.profileData?.aboutMe ?? ""
                   
                    if desc != "" {
                        self.txt_aboutMe.text = desc
                        self.txt_aboutMe.textColor = .black
                    } else {
                        self.txt_aboutMe.textColor = .gray
                        self.txt_aboutMe.text = self.placeholderText
                    }
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
        
        // updateAboutMeResult
        viewModel.$updateAbouMeResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    let txt = response.data?.addedAboutMe ?? ""
                    self.txt_aboutMe.text = txt
                    self.btnEditAboutMe.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.txt_aboutMe.isEditable = false
                })
            }.store(in: &cancellables)
        
        
        viewModel.$getProfileUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    print(response.message ?? "")
                    
                    print(response.data?.isProfileComplete ?? false,"isProfileComplete Status")
                    
                    var is_profile_complete = "\(response.data?.isProfileComplete ?? false)"
                    UserDetail.shared.setisCompleteProfile("\(response.data?.isProfileComplete ?? false)")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                })
            }.store(in: &cancellables)
        
        // Email verification
        viewModelVerifyEmail.$emailVerificationResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    
                    print(response.data?.email ?? "","Email")
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.otp ?? 0,"OTP")
                    
                    self.tobeVerifyEmail(OTP: "\(response.data?.otp ?? 0)", Email: (response.data?.email ?? ""),userId:"\(response.data?.userID ?? 0)" )
                    
                })
            }.store(in: &cancellables)
        
        
        viewModelEmailVerifyOTP.$emailVerifiedResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "0","RESULT AFTER VERIFICATION")
                    
                    self.resendBtnO.isUserInteractionEnabled = true
                    self.lbl_time.text = "00:00sec"
                    self.resendBtnO.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
                    self.view_OTPVerification.isHidden = true
                    self.view_timeResend.isHidden = true
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                    vc.comesFrom = self.verificationStatus
                    vc.backCome = {
                        if self.verificationStatus == "PhoneVerified" {
                            self.editEmail_Phone = ""
                            self.view_ConfirmNowPhone.isHidden = true
                            self.view_VerifiedPhone.isHidden = false
                        }else if self.verificationStatus == "EmailVerified" {
                            self.editEmail_Phone = ""
                            self.view_ConfirmNowEmail.isHidden = true
                            self.view_VerifiedEmail.isHidden = false
                        }
                    }
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true)
                })
            }.store(in: &cancellables)
        
        //Result phoneVerification
        
        viewModelVerifyPhone.$phoneverificationResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { [self] response in
                    
                    print(response.data?.phoneNumber ?? "","Email")
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.otp ?? 0,"OTP")
                    self.userID = "\(response.data?.userID ?? 0)"
                    self.OTP  = "\(response.data?.otp ?? 0)"
                    self.tobeVerifyPhone(OTP: "\(response.data?.otp ?? 0)", Phone: "\(response.data?.phoneNumber ?? "0")", userId: "\(response.data?.userID ?? 0)")
                    print(response.message ?? "0","MESSAGE")
                    
                })
            }.store(in: &cancellables)
        
        
        // Email verification
        viewModelPhoneVerifyOTP.$phoneVerifiedResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    
                    self.resendBtnO.isUserInteractionEnabled = true
                    self.lbl_time.text = "00:00sec"
                    self.resendBtnO.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
                    self.view_OTPVerification.isHidden = true
                    self.view_timeResend.isHidden = true
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                    vc.comesFrom = self.verificationStatus
                    vc.backCome = {
                        if self.verificationStatus == "PhoneVerified" {
                            self.editEmail_Phone = ""
                            self.view_ConfirmNowPhone.isHidden = true
                            self.view_VerifiedPhone.isHidden = false
                            
                        }else if self.verificationStatus == "EmailVerified" {
                            self.editEmail_Phone = ""
                            self.view_ConfirmNowEmail.isHidden = true
                            self.view_VerifiedEmail.isHidden = false
                        }
                    }
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true)
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
                    
                    self.profileImg.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
                })
            }.store(in: &cancellables)
    }
    
}
extension CreateProfileVC :DPOTPViewDelegate{
    
    func dpOTPViewAddText(_ text: String, at position: Int) {
        viewModelEmailVerifyOTP.updateOTPText(text)
        viewModelPhoneVerifyOTP.updateOTPText(text)
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {}
    func dpOTPViewChangePositionAt(_ position: Int) {}
    func dpOTPViewBecomeFirstResponder() {}
    func dpOTPViewResignFirstResponder() {}
    
}

extension CreateProfileVC: InquiryDelegate {
    
    func inquiryComplete(inquiryId: String, status: String, fields: [String : InquiryField]) {
        print(inquiryId)
        print(status)
        if status ==  "completed" {
            self.identity_verify = 1
            self.view_verifiedIndentity.isHidden = false
            self.view_verifyIndentityConfirmNow.isHidden = true
        } else {
            self.identity_verify = 0
            self.view_verifiedIndentity.isHidden = true
            self.view_verifyIndentityConfirmNow.isHidden = false
        }
        
        // Inquiry completed
    }
    
    func inquiryCanceled(inquiryId: String?, sessionToken: String?) {
        // Inquiry cancelled by user
    }
    
    func inquiryError(_ error: Error) {
        // Inquiry errored
    }
}
