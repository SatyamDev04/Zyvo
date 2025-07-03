//
//  HostAddCardVC.swift
//  Zyvo
//
//  Created by ravi on 26/12/24.
//

import UIKit
import DropDown
import Combine
import AVFoundation
import ProgressHUD
import StripePayments
import CountryPickerView

class HostAddCardVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    func didSelect(image: UIImage?) {
        
    }
    
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var CardNumTxtF: UITextField!
    @IBOutlet weak var MonthBtnO: UIButton!
    @IBOutlet weak var MonthTxt: UITextField!
    @IBOutlet weak var YearTxt: UITextField!
    @IBOutlet weak var YearBtnO: UIButton!
    @IBOutlet weak var BgV: UIView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var idTypeTF: UITextField!
    @IBOutlet weak var idNumberTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var postalCodeTF: UITextField!
    @IBOutlet weak var ssnLast4TF: UITextField!
    @IBOutlet weak var frontDocTF: UITextField!
    @IBOutlet weak var backDocTF: UITextField!
    
    let idTypeDrop = DropDown()
    let countryDrop = DropDown()
    let stateDrop = DropDown()
    let cityDrop = DropDown()
    let BankProofDrop = DropDown()
    
    var idTypeArr = ["Driver License","Passport"]
    var months = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var years = [""]
    var addCardViewModel = H_AddCardViewModel()
    var CountryStateCityVM = CountryStateViewModel()
    private var cancellables = Set<AnyCancellable>()
    var countryDetails = [CountryStateCityDataModel]()
    var arr_State_Details = [CountryStateCityDataModel]()
    var arr_City_Details = [CountryStateCityDataModel]()
    var countryCode = ""
    var stateCode = ""
    var cityCode = ""
    var idType = ""
    var imagePicker1: ImagePicker!
    var documentPicker: DocumentPicker?
    var BankProofDOC = Data()
    var FrontDOC = Data()
    var BackDOC = Data()
    var fileTypeName = ""
    var pickMediaFor = ""
    private let textShort    = "Please wait..."
    private var timer: Timer?
    
    var datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var toolBar = UIToolbar()
    let screenWidth = UIScreen.main.bounds.width
    var DOBArr = [String]()
    private var pickerView: UIPickerView!
    private var pickerContainer: UIView!
    private var isMonthPicker = true // To track whether it's a month or year picker
    
    let validator = PhoneNumberValidator()
    let countryPicker = CountryPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryCodeTF.text = "🇺🇸 +1"
        self.countryCode = "+1"
        phoneNumTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
        countryPicker.delegate = self
        
        phoneNumTF.delegate = self
        phoneNumTF.keyboardType = .numberPad
        bindVC()
        bindVC_State()
        bindVC_City()
        bindVC_AddCard()
        years = Array(currentYear...(currentYear + 30)).map { String($0) }
        
        BgV.layer.cornerRadius = 15
        // Round top-left and top-right corners only
        BgV.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        toolBar.sizeToFit()
        toolBar.tintColor = .systemBlue
        toolBar.isUserInteractionEnabled = true
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTapped))
        doneButton.tintColor = .black
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        dobTF.inputView = datePicker
        dobTF.inputAccessoryView = toolBar
        dobTF.delegate = self
        datePicker.minimumDate = .none
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        imagePicker1 = ImagePicker(presentationController: self, delegate: self)
        documentPicker = DocumentPicker(presentationController:self, delegate: self)
        
        CountryStateCityVM.GetCountryStateCityApi()
    }
    
    
    @objc func textFieldDidChange() {
        guard let number = phoneNumTF.text,
              let code = countryCodeTF.text else {
            return
        }
        let phoneNumber = (phoneNumTF.text ?? "")
        //let regionCode = expectedRegion // or use "IN" directly
        if phoneNumber != "" {
            let isValid = validator.isValidMobileNumber(countryCode: self.countryCode, number: "\(self.countryCode)\(phoneNumber)")
            print("Is valid: \(isValid)")
            
            if isValid != true {
                self.showAlert(for: "Please enter valid phone number")
                self.phoneNumTF.text = ""
            }
        }
    }
    
    @IBAction func btnSelectCountry_Tap(_ sender: UIButton) {
        countryPicker.showCountriesList(from:self)
    }
    @IBAction func MonthDropBtn(_ sender: UIButton) {
        for subView in view.subviews {
            if subView == pickerContainer {
                resetPickerView()
            }
        }
        
        setupPickerView(SelDateBtn: MonthBtnO)
        isMonthPicker = true // Set the picker to month mode
        pickerView.reloadAllComponents()
        showPicker()
    }
    
    @IBAction func YearDropBtn(_ sender: UIButton) {
        for subView in view.subviews {
            if subView == pickerContainer {
                resetPickerView()
            }
        }
        
        setupPickerView(SelDateBtn: YearBtnO)
        isMonthPicker = false // Set the picker to year mode
        pickerView.reloadAllComponents()
        showPicker()
    }
    
    @IBAction func btn_Country(_ sender: UIButton) {
        self.countryDrop.anchorView = sender
        self.countryDrop.direction = .bottom
        self.countryDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
        self.countryDrop.textColor = .black
        self.countryDrop.separatorColor = .clear
        self.countryDrop.selectionBackgroundColor = .clear
        self.countryDrop.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.countryDrop.dataSource.removeAll()
        self.countryDrop.cellHeight = 35
        self.countryDrop.dataSource = countryDetails.map {$0.name ?? ""}
        
        self.countryDrop.selectionAction = { [unowned self] (index, item) in
            
            self.countryTF.text = item
            self.stateTF.text = ""
            self.cityTF.text = ""
            self.postalCodeTF.text = ""
            self.countryCode = self.countryDetails[index].iso2 ?? ""
            self.stateCode = ""
            self.cityCode = ""
            CountryStateCityVM.GetStateCityApi(countryCode: self.countryCode)
        }
        self.countryDrop.show()
    }
    
    @IBAction func btn_State(_ sender: UIButton) {
        guard cityTF.text != "" || countryTF.text != "" else {
            self.AlertControllerOnr(title: "Alert!", message: "Please select country first")
            return
        }
        self.stateDrop.anchorView = sender
        self.stateDrop.direction = .bottom
        self.stateDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
        self.stateDrop.textColor = .black
        self.stateDrop.separatorColor = .clear
        self.stateDrop.selectionBackgroundColor = .clear
        self.stateDrop.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.stateDrop.dataSource.removeAll()
        self.stateDrop.cellHeight = 35
        self.stateDrop.dataSource = arr_State_Details.map {$0.name ?? ""}
        
        self.stateDrop.selectionAction = { [unowned self] (index, item) in
            
            self.stateTF.text = item
            self.cityTF.text = ""
            self.postalCodeTF.text = ""
            //            self.stateCode = self.arr_State_Details[index].iso2 ?? ""
            self.stateCode = self.arr_State_Details[index].iso2 ?? ""
            CountryStateCityVM.GetCityApi(countryCode:self.countryCode, stateCode: self.stateCode)
            //            self.API_TO_Get_Cities(Cities: cityCode)
        }
        self.stateDrop.show()
    }
    
    @IBAction func btn_city(_ sender: UIButton) {
        
        guard countryTF.text != "" || stateTF.text != "" else {
            self.AlertControllerOnr(title: "Alert!", message: "Please select country first")
            return
        }
        guard stateTF.text != "" else {
            self.AlertControllerOnr(title: "Alert!", message: "Please select state first")
            return
        }
        
        self.cityDrop.anchorView = sender
        self.cityDrop.direction = .bottom
        self.cityDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
        self.cityDrop.textColor = .black
        self.cityDrop.separatorColor = .clear
        self.cityDrop.selectionBackgroundColor = .clear
        self.cityDrop.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.cityDrop.dataSource.removeAll()
        self.cityDrop.cellHeight = 35
        self.cityDrop.dataSource = arr_City_Details.map {$0.name ?? ""}
        self.cityDrop.selectionAction = { [unowned self] (index, item) in
            self.cityTF.text = item
        }
        self.cityDrop.show()
    }
    
    @IBAction func btn_IdTypeDrop(_ sender: UIButton) {
        self.idTypeDrop.anchorView = sender
        self.idTypeDrop.direction = .bottom
        self.idTypeDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
        self.idTypeDrop.textColor = .black
        self.idTypeDrop.separatorColor = .clear
        self.idTypeDrop.selectionBackgroundColor = .clear
        self.idTypeDrop.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.idTypeDrop.dataSource.removeAll()
        self.idTypeDrop.cellHeight = 35
        self.idTypeDrop.dataSource = idTypeArr
        
        self.idTypeDrop.selectionAction = { [unowned self] (index, item) in
            self.idTypeTF.text = item
            if index == 0{
                self.idType = "driver_license"
            }else{
                self.idType = "passport"
            }
        }
        self.idTypeDrop.show()
    }
    
    @IBAction func AddCardBtn(_ sender: UIButton) {
        guard validation1() else {
            return
        }
        guard validation() else {
            return
        }
        callFunc()
    }
    
    @IBAction func frontDocumentBtn(_ sender: UIButton) {
        self.pickMediaFor = "Front"
        let ac = UIAlertController(title: "Photo Source", message: "Choose A Source", preferredStyle: .actionSheet )
        let cameraBtn = UIAlertAction(title: "Open Camera", style: .default) {[weak self] (_) in
            
            // Check if the camera is available on the device as a source type
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                switch cameraAuthorizationStatus {
                case .notDetermined: self?.requestCameraPermission()
                    
                case .authorized: self?.presentCamera()
                    
                case .restricted, .denied: self?.alertCameraAccessNeeded()
                    
                @unknown default:
                    self?.alertCameraAccessNeeded()
                    break
                }
                
            }
            else
            {
                let alert = UIAlertController(title: "", message: ("You don't have camera."), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: ("OK"), style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            
            self?.showImagePicker(selectedSource: .camera)
        }
        let libraryBtn = UIAlertAction(title: "Open Gallery", style: .default) {[weak self] (_) in
            self?.showImagePicker(selectedSource: .photoLibrary)
        }
        let DocBtn = UIAlertAction(title: "Open Document", style: .default) {[weak self] (_) in
            self?.openDocPicker()
        }
        
        let cancelBtn = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        ac.addAction(cameraBtn)
        ac.addAction(libraryBtn)
        ac.addAction(DocBtn)
        ac.addAction(cancelBtn)
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func backDocumentBtn(_ sender: UIButton) {
        self.pickMediaFor = "Back"
        let ac = UIAlertController(title: "Photo Source", message: "Choose A Source", preferredStyle: .actionSheet )
        let cameraBtn = UIAlertAction(title: "Open Camera", style: .default) {[weak self] (_) in
            
            // Check if the camera is available on the device as a source type
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                switch cameraAuthorizationStatus {
                case .notDetermined: self?.requestCameraPermission()
                    
                case .authorized: self?.presentCamera()
                    
                case .restricted, .denied: self?.alertCameraAccessNeeded()
                    
                @unknown default:
                    self?.alertCameraAccessNeeded()
                    break
                }
                
            }
            else
            {
                let alert = UIAlertController(title: "", message: ("You don't have camera."), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: ("OK"), style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            
            self?.showImagePicker(selectedSource: .camera)
        }
        let libraryBtn = UIAlertAction(title: "Open Gallery", style: .default) {[weak self] (_) in
            self?.showImagePicker(selectedSource: .photoLibrary)
        }
        let DocBtn = UIAlertAction(title: "Open Document", style: .default) {[weak self] (_) in
            self?.openDocPicker()
        }
        
        let cancelBtn = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        ac.addAction(cameraBtn)
        ac.addAction(libraryBtn)
        ac.addAction(DocBtn)
        ac.addAction(cancelBtn)
        self.present(ac, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dobTF {
            datePicker.datePickerMode = .date
            datePicker.maximumDate = Date()
        }
    }
    
    @objc func doneButtonTapped() {
        if dobTF.isFirstResponder {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dobTF.text = dateFormatter.string(from: datePicker.date)
            let dateString = dobTF.text ?? ""
            let dateComponents = dateString.split(separator: "/").map { String($0) }
            
            if dateComponents.count == 3 {
                let formattedDate = [dateComponents[0],dateComponents[1], dateComponents[2]]
                self.DOBArr = formattedDate
                print(formattedDate) // Output: ["3", "5", "2025"]
            }
        }
        self.view.endEditing(true)
    }
    
    private func showPicker() {
        UIView.animate(withDuration: 0.3) {
            self.pickerContainer.frame.origin.y = self.MonthBtnO.frame.width
        }
    }
    
    @objc func doneTapped() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        
        if isMonthPicker {
            // Convert the index to a numeric string with leading zero
            let selectedMonthNumber = String(format: "%02d", selectedRow + 1)
            MonthTxt.text = selectedMonthNumber
        } else {
            // Get the selected year
            YearTxt.text = years[selectedRow]
        }
        
        // Animate the picker container out of view
        UIView.animate(withDuration: 0.3) {
            self.pickerContainer.frame.origin.y = self.view.frame.height
        }
    }
    
    
    private func setupPickerView(SelDateBtn: UIButton) {
        // Get the button's frame relative to the view
        let buttonFrame = SelDateBtn.convert(SelDateBtn.bounds, to: self.view)
        
        // Create the container view for the picker and its controls
        pickerContainer = UIView(frame: CGRect(x: buttonFrame.origin.x,
                                               y: buttonFrame.maxY,
                                               width: SelDateBtn.frame.width + 30,
                                               height: 250))
        
        pickerContainer.backgroundColor = #colorLiteral(red: 1, green: 0.968627451, blue: 0.9411764706, alpha: 1)
        
        // Create the UIPickerView
        pickerView = UIPickerView(frame: CGRect(x: 0,
                                                y: 50,
                                                width: SelDateBtn.frame.width + 30,
                                                height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Add a toolbar with a "Done" button
        let toolbar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: SelDateBtn.frame.width + 30,
                                              height: 40))
        toolbar.sizeToFit()
        
        // Set the color of the "Done" button to black
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        doneButton.tintColor = #colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1) // Set the button color to green
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        // Add the toolbar and picker to the container
        pickerContainer.addSubview(toolbar)
        pickerContainer.addSubview(pickerView)
        
        // Add the picker container to the view
        self.view.addSubview(pickerContainer)
        
        // Animate the picker container to appear smoothly
        UIView.animate(withDuration: 0.3) {
            self.pickerContainer.frame.origin.y = buttonFrame.maxY
        }
    }
    
    private func resetPickerView() {
        // Remove the picker and its container from the view hierarchy
        pickerContainer.removeFromSuperview()
        
        // Reset the picker to the first row or any default state if needed
        pickerView.selectRow(0, inComponent: 0, animated: false) // Reset to the first row
        
        // Optionally, reset the text fields or any other related state
        //        MonthTxt.text = ""
        //        YearTxt.text = ""
    }
    
    
    
    
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return isMonthPicker ? months.count : years.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return isMonthPicker ? months[row] : years[row]
    }
}

extension HostAddCardVC: DocumentDelegate, ImagePickerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func presentCamera() {
        self.showImagePicker(selectedSource: .camera)
        let imagePicker = UIImagePickerController()
        
        // set its delegate, set its source type
        imagePicker.delegate = (self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
            self.presentCamera()
        })
    }
    
    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Need Camera Access",
            message: "Camera access is required to capture photo in this app.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showImagePicker(selectedSource : UIImagePickerController.SourceType){
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource)
        else {
            return
        }
        DispatchQueue.main.async {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = selectedSource
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
    }
    
    func openDocPicker(){
        documentPicker?.displayPicker()
        documentPicker?.pickerController?.allowsMultipleSelection = false
    }
    
    func didPickDocument(document: Document?) {
        if let pickedDoc = document {
            let FileURL = pickedDoc.fileURL
            /// do what you want with the file URL
            //   print(FileURL)
            
            let name = FileURL.lastPathComponent
            let fileName = name
            let fileArray = fileName.components(separatedBy: ".")
            let firstName = fileArray.first
            let finalFileName = fileArray.last
            self.fileTypeName = finalFileName ?? ""
            
            do {
                let DataFile = try Data(contentsOf: FileURL as URL)
                
                actionProgressStart(textShort)
                ProgressHUD.colorAnimation = .systemBlue
                ProgressHUD.colorProgress = .systemBlue
                
                //                self.BankImg_CoverDotted.isHidden = true
                if self.pickMediaFor == "Front"{
                    self.FrontDOC = DataFile
                    self.frontDocTF.text = fileName
                }else if self.pickMediaFor == "Back"{
                    self.BackDOC = DataFile
                    self.backDocTF.text = fileName
                }
                //                self.BankIMG.image = UIImage(named: "pdfpng") // docs
                
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }
    
    // progress bar.
    func actionProgressStart(_ status: String? = nil) {
        
        timer?.invalidate()
        timer = nil
        
        var intervalCount: CGFloat = 0.0
        
        ProgressHUD.progress(status, intervalCount/100)
        timer = Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { timer in
            intervalCount += 1
            ProgressHUD.progress(status, intervalCount/100)
            if (intervalCount >= 100) {
                self.actionProgressStop()
            }
        }
    }
    
    func actionProgressStop() {
        
        timer?.invalidate()
        timer = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            ProgressHUD.succeed(interaction: false)
        }
    }
    
    //MARK:-imagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage ?? UIImage()
        let selectedName = info[.imageURL] as? URL ?? URL(string: "")
        let DataFile = selectedImage.jpegData(compressionQuality: 0.5) ?? Data()
        
        //        self.BankImg_CoverDotted.isHidden = true
        if self.pickMediaFor == "Front"{
            self.FrontDOC = DataFile
            self.frontDocTF.text = "\(selectedName ?? URL(fileURLWithPath: ""))"
        }else if self.pickMediaFor == "Back"{
            self.BackDOC = DataFile
            self.backDocTF.text = "\(selectedName ?? URL(fileURLWithPath: ""))"
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension HostAddCardVC {
    
    func validation() -> Bool {
        
        if self.frontDocTF.text == ""  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mFrontID)
            return false
        }
        
        if self.backDocTF.text == ""  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mBackID)
            return false
        }
        return true
    }
    
    
    func validation1() -> Bool {
        
        if firstNameTF.text?.count == 0 && lastNameTF.text?.count == 0 && emailTF.text?.count == 0 && phoneNumTF.text?.count == 0 && dobTF.text?.count == 0 &&  addressTF.text?.count == 0 && countryTF.text?.count == 0 && stateTF.text?.count == 0 && cityTF.text?.count == 0 && postalCodeTF.text?.count == 0{
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mEmptyField)
            return false
        }
        
        
        if self.firstNameTF.text == " " || firstNameTF.text?.count == 0  {
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mFirstName)
            return false
        }
        
        if self.lastNameTF.text == " " || lastNameTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mLastName)
            return false
        }
        
        if self.emailTF.text == " " || emailTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mEmail)
            return false
        }
        
        if self.emailTF.text!.contains("@")  {
            if !self.isValidEmail(testStr: self.emailTF.text!) {
                AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mValidEmail)
                return false
            }
        }
        
        if self.phoneNumTF.text == " " || phoneNumTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mPhoneNumber)
            return false
        }
        
        if self.dobTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mDob)
            return false
        }
        
        
        if self.addressTF.text == " " || addressTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mAddress)
            return false
        }
        
        
        
        if self.stateTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mState)
            return false
        }
        
        if self.cityTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mCity)
            return false
        }
        
        if self.postalCodeTF.text?.count == 0  {
            
            AlertControllerOnr(title: alertTitle.alert_alert, message: messageString.mPostalCode)
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField ==  firstNameTF && textField ==  lastNameTF{
            
            if string.count == 0 {
                return true
            }
            if string == " " {
                return true
            }
            if !self.pavan_checkAlphabet(Str: string) {
                return false
            }
            return true
        }
    
            if textField == phoneNumTF {
                let currentText = phoneNumTF.text ?? ""
                // Create the updated text after replacement
                guard let rangeOfTextToReplace = Range(range, in: currentText) else { return false }
                let updatedText = currentText.replacingCharacters(in: rangeOfTextToReplace, with: string)
                // Allow only numbers and a maximum of 10 digits
                let isNumeric = updatedText.allSatisfy { $0.isNumber }
               // return isNumeric && updatedText.count <= 10
                return isNumeric && updatedText.count <= 9 || updatedText.count <= 10 || updatedText.count <= 11
            }
           
//        else if textField == phoneNumTF{
//            guard let text = self.phoneNumTF.text else { return false }
//            let newString = (text as NSString).replacingCharacters(in: range, with: string)
//            
//            self.phoneNumTF.text = format(with: "+X (XXX) XXX-XXXX", phone: newString)
//            return false
//        }
        
        return true
    }
}

extension HostAddCardVC {
    
    func callFunc() {
        // self.addCardBtn.isUserInteractionEnabled = false
        let cardParams = STPCardParams()
        //                cardParams.number = "4242424242424242"
        //                cardParams.expMonth = 10
        //                cardParams.expYear = 2026
        //                cardParams.cvc = "123"
        
        //            let fullName = MonthTxt.text!
        //            let fullNameArr = fullName.components(separatedBy: "/")
        cardParams.name = "\(firstNameTF.text ?? "") \(lastNameTF.text ?? "")"
        cardParams.number = CardNumTxtF.text
        cardParams.expMonth = UInt(MonthTxt.text ?? "")!
        cardParams.expYear = UInt(YearTxt.text ?? "")!
        //            cardParams.cvc = cvvTF.text
        cardParams.addressZip = self.postalCodeTF.text
        cardParams.addressCity = self.cityTF.text
        cardParams.addressState = self.stateTF.text
        cardParams.addressLine1 = self.addressTF.text
        cardParams.currency = "USD"
        
        print(cardParams,"cardParams")
        STPAPIClient.shared.createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token111 = token, error == nil else {
                // Present error to user...
                let UserInfo = error.unsafelyUnwrapped.localizedDescription
                self.showAlert(for: UserInfo)
                // self.addCardBtn.isUserInteractionEnabled = true
                
                return
            }
            //  self.TokenId = token111.tokenId as Any as? String
            print(token111.tokenId as Any,"token id")
            //self.callAddCardApi()
            
            self.addCardViewModel.H_AddCardApi(firstName: self.firstNameTF.text ?? "", lastName: self.lastNameTF.text ?? "", cardNum: self.CardNumTxtF.text ?? "", token: token?.tokenId, email: self.emailTF.text ?? "", phoneNumber: self.phoneNumTF.text ?? "", dob: self.DOBArr, ssnLast4: self.ssnLast4TF.text ?? "", address: self.addressTF.text ?? "", country: self.countryCode, state: self.stateCode, city: self.cityTF.text ?? "", postalCode: self.postalCodeTF.text ?? "", idType: self.idType, idNumber: self.idNumberTF.text ?? "", verificationDocumentFront: self.FrontDOC, verificationDocumentBack: self.BackDOC)
            
            //            self.PaymentApi(cardExpMonth: fullNameArr[0], cardExpYear: fullNameArr[1], stripeToken: token111.tokenId)
            
        }
    }
    
    func bindVC(){
        CountryStateCityVM.$getCountryStateCityResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.countryDetails.removeAll()
                    self.countryDetails = response.data ?? []
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_State(){
        CountryStateCityVM.$getStateCityResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.AlertControllerCuston(title: "Success", message: response.message, BtnTitle: ["Okay"]) { dict in
                        self.arr_State_Details.removeAll()
                        self.arr_State_Details = (response.data ?? []).sorted {
                            ($0.name ?? "").lowercased() < ($1.name ?? "").lowercased()
                        }
                    }
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_City(){
        CountryStateCityVM.$getCityResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.AlertControllerCuston(title: "Success", message: response.message, BtnTitle: ["Okay"]) { dict in
                        self.arr_City_Details.removeAll()
                        self.arr_City_Details = response.data ?? []
                    }
                })
            }.store(in: &cancellables)
    }
    
    
    func bindVC_AddCard(){
        addCardViewModel.$addCardResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.AlertControllerCuston(title: "Success", message: response.message, BtnTitle: ["Okay"]) { dict in
                        if response.success == true{
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                })
            }.store(in: &cancellables)
    }
}


extension HostAddCardVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Use the name and phone code directly
        let flag = country.code.flagEmoji // Access the flag emoji as String
        let name = country.name
        let code = country.phoneCode
       // self.countryCode = code
        countryCodeTF.text = "\(flag) (\(code))"
        self.countryCode = "\(code)"
        if (phoneNumTF.text ?? "") != "" {
            let phoneNumber = (phoneNumTF.text ?? "")
            let isValid =  validator.isValidMobileNumber(countryCode: self.countryCode, number: "\(self.countryCode)\(phoneNumber)")
            print("Is valid: \(isValid)")
            if isValid != true {
                self.showAlert(for: "Please enter valid phone number")
                self.phoneNumTF.text = ""
            }
        }
    }
}
