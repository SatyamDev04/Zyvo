//
//  CheckoutVC.swift
//  Zyvo
//
//  Created by ravi on 28/11/24.
//

import UIKit
import DropDown
import Combine
class CheckoutVC: UIViewController {
    
    @IBOutlet weak var btnShowMoreAddOns: UIButton!
    @IBOutlet weak var lbl_respondHours: UILabel!
    @IBOutlet weak var imgHostStar: UIImageView!
    @IBOutlet weak var view_AddOns: UIView!
    @IBOutlet weak var lbl_HostRulesDesc: UILabel!
    @IBOutlet weak var lbl_timeFromTo: UILabel!
    @IBOutlet weak var lbl_parkingDesc: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var view_ParkingDesc: UIView!
    @IBOutlet weak var viewHold_MessageHost: UIView!
    @IBOutlet weak var view_MessageHost: UIView!
    @IBOutlet weak var view_HostDesc: UIView!
    @IBOutlet weak var view_Discount: UIView!
    @IBOutlet weak var view_Card: UIView!
    @IBOutlet weak var imgDownArrowDebitCard: UIImageView!
    @IBOutlet weak var imgProperty: UIImageView!
    @IBOutlet weak var StackAbove: UIStackView!
    @IBOutlet weak var btnConfirmPay: UIButton!
    @IBOutlet weak var view_RulesParking: UIView!
    @IBOutlet weak var view_HostRules: UIView!
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var tblVH_Const: NSLayoutConstraint!
    @IBOutlet weak var stackV_MessageHost: UIStackView!
    @IBOutlet weak var view_MessageHostDesc: UIView!
    @IBOutlet weak var view_otherReason: UIView!
    @IBOutlet weak var view_availableDays: UIView!
    @IBOutlet weak var view_IhaveDoubt: UIView!
    @IBOutlet weak var btnMsgHost: UIButton!
    @IBOutlet weak var viewMain_SelectTimeFromTo: UIView!
    @IBOutlet weak var viewOutSideSelectDate: UIView!
    @IBOutlet weak var collecV_Host: UICollectionView!
    @IBOutlet weak var view_Details: UIView!
    @IBOutlet weak var btnShowMessageHost: UIButton!
    @IBOutlet weak var view_CreditDebitCard: UIView!
    @IBOutlet weak var btnAddNewCard: UIButton!
    @IBOutlet weak var btnSaveChangesDates: UIButton!
    @IBOutlet weak var view_Hours: UIView!
    @IBOutlet weak var view_Calendar: UIView!
    @IBOutlet weak var view_time2: UIView!
    @IBOutlet weak var view_AddmoreTime: UIView!
    @IBOutlet weak var view_SelectDate: UIView!
    @IBOutlet weak var refundPolicyLbl: UILabel!
    @IBOutlet weak var btnSelectYear: UIButton!
    @IBOutlet weak var btnSelectMonth: UIButton!
    @IBOutlet weak var btnSelectDate: UIButton!
    @IBOutlet weak var view_date: UIView!
    @IBOutlet weak var view_month: UIView!
    @IBOutlet weak var view_year: UIView!
    @IBOutlet weak var viewFrom_hours: UIView!
    @IBOutlet weak var view_ZyvoServiceFee: UIView!
    @IBOutlet weak var viewFrom_mnt: UIView!
    @IBOutlet weak var viewFrom_AMPM: UIView!
    @IBOutlet weak var viewTo_hours: UIView!
    @IBOutlet weak var viewTo_mnt: UIView!
    @IBOutlet weak var viewTo_AMPM: UIView!
    @IBOutlet weak var collVH: NSLayoutConstraint!
    @IBOutlet weak var lbl_Distance: UILabel!
    @IBOutlet weak var view_ShowMoreAddOns: UIView!
    @IBOutlet weak var lbl_numberOfReview: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var lbl_propertyName: UILabel!
    @IBOutlet weak var lbl_BookingDate: UILabel!
    @IBOutlet weak var view_addMoreTime: UIView!
    @IBOutlet weak var lbl_CDate: UILabel!
    @IBOutlet weak var lbl_cyear: UILabel!
    @IBOutlet weak var lbl_cmonth: UILabel!
    @IBOutlet weak var lbl_cdate: UILabel!
    @IBOutlet weak var lbl_Abovehours: UILabel!
    @IBOutlet weak var lbl_belowhours: UILabel!
    @IBOutlet weak var lbl_finalPrice: UILabel!
    @IBOutlet weak var lbl_hoursPrice: UILabel!
    @IBOutlet weak var view_CleaningFee: UIView!
    @IBOutlet weak var lbl_AddOnsAmount: UILabel!
    @IBOutlet weak var lbl_tax: UILabel!
    @IBOutlet weak var lbl_ZyvoServiceFee: UILabel!
    @IBOutlet weak var lbl_CleaningFee: UILabel!
    @IBOutlet weak var viewBelow_SelectTime: UIView!
    @IBOutlet weak var lbl_discount: UILabel!
    
    @IBOutlet weak var view_TaxFee: UIView!
    let hoursDropdown = DropDown()
    let dateDropDown = DropDown()
    let monthDropDown = DropDown()
    let yearDropDown = DropDown()
    let yearStrings = stride(from: 2024, through: 2100, by: 1).map { String($0) }
    
    let daysArr = (1...31).map { String($0) }
    
    var monthNamesArr = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    let arrHours = ["1 hour","2 hours","3 hours","4 hours","5 hours","6 hours","7 hours","8 hours","9 hours","10 hours","11 hours","12 hours"]
    
    private let spacing:CGFloat = 16.0
    
    var Host_count = 4
    var showRefundPolicy = "no"
    var StartDatetime = ""
    var EndDatetime = ""
    var bookingHours : Int? = 0
    var bookingAmount : Double? = 0.0
    var propertyID = ""
    var profileIMGURL = ""
    var propertyIMGURL = ""
    var propertyName = ""
    var propertyRating = ""
    var propertyNumberofReview = ""
    var propertyDistanceInMiles = ""
    var hostName = ""
    var bookingID = ""
    var cardID = ""
    var property_id = ""
    var booking_start = ""
    var startTime = ""
    var endTime = ""
    var booking_end = ""
    var booking_date = ""
    var booking_hours : Int? = 0
    var perHourRate : Int? = 0
    var minBookhours : Int? = 0
    var total_amount : Double? = 0.0
    var booking_amount : Double? = 0.0
    var taxAmount : Double? = 0.0
    var DiscountAmount : Double? = 0.0
    var AddonOnsPrice : Double? = 0.0
    var ClearningFee : Double? = 0
    var zyvoServiceFee : Double? = 0
    var zyvoServicePercentage : Double? = 0
    var tax : Double? = 0
    var awardStatus : Bool = false
    var channelName = ""
    var DiscountPercentage : Double? = 0.0
    var taxPercentage : Double? = 0.0
    var parkDesc = ""
    var HostingRulesDesc = ""
    var hostProfileImg = ""
    var guestProfileImg = ""
    var isCardOpen = "no"
    var isParkingRulesOpen = "no"
    var isHostTingRulesOpen = "no"
    var guestName = ""
    var hostID = 0
    var card_id = ""
    var customerID = ""
    var indx : Int? = 0
    let addons = [[String: Any]]()
    var addOnsArr: [AddOn] = []
    var getCardArr : [Card]?
    var arrSelectedArr :[Int] = []
    var addOnsNeddToSend: [[String: Any]] = []
    var isReadMore: Bool = false
    var fulladdOnsArr: [AddOn] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private var viewModel = BookingPropertyViewModel()
    
    private var viewModel1 = BookingDetailsViewModel()
    
    var getJoinChannelDetails : JoinChanelModel?
    
    var bookingResult : BookingModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
        
        
        let addonsARRDATA = self.fulladdOnsArr
        if addonsARRDATA.count > 4 {
            
            self.view_ShowMoreAddOns.isHidden = false
            self.fulladdOnsArr = addonsARRDATA
            self.addOnsArr = Array(self.fulladdOnsArr.prefix(4))
            self.collecV_Host.reloadData()
            self.collVH.constant = 320
        } else {
            self.view_ShowMoreAddOns.isHidden = true
            self.addOnsArr = addonsARRDATA
            
        }
        
        if self.awardStatus == false {
            self.imgHostStar.isHidden = true
        } else {
            self.imgHostStar.isHidden = false
        }
        
        viewModel.apiForGetSavedCard()
        
        let guestID = Int(UserDetail.shared.getUserId())
        let hostID = self.hostID
        
        let id1 = min(guestID ?? 0 , hostID)
        let id2 = max(guestID ?? 0, hostID)
        
        self.channelName = "ZYVOOPROJ_\(id1)_\(id2)_\(self.property_id)"
        print(self.channelName,"self.channelName")
        print(id1,id2,self.propertyID,"ASDFASDF")
        
        let inputDate = "\(booking_date)"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: inputDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM, d yyyy"
            let outputDate = outputFormatter.string(from: date)
            
            print(outputDate) // Output: March, 4 2025
            self.lbl_BookingDate.text = "\(outputDate)"
        }
        
        if (booking_hours ?? 0) > 1 {
            self.lbl_Abovehours.text = "\(booking_hours ?? 0) hours"
            self.lbl_belowhours.text = "\(booking_hours ?? 0) hours"
        } else {
            self.lbl_Abovehours.text = "\(booking_hours ?? 0) hour"
            self.lbl_belowhours.text = "\(booking_hours ?? 0) hour"
        }
        
        let bookingAmount = self.booking_amount ?? 0.0
        let cleaningFee = self.ClearningFee ?? 0.0
        let serviceFee = self.zyvoServiceFee ?? 0.0
        let tax = self.taxAmount ?? 0.0
        let addOns = self.AddonOnsPrice ?? 0.0
        
        let AddTotalAmount = (bookingAmount + cleaningFee + serviceFee + tax + addOns).rounded(toPlaces: 2)
        
        let totalAmount = (AddTotalAmount -  (self.DiscountAmount ?? 0.0)).rounded(toPlaces: 2)
        let finalPrice = "\(totalAmount)"
        self.lbl_finalPrice.text = "$\(finalPrice.formattedPrice())"
        
        self.lbl_name.text = self.hostName
        
        self.lbl_timeFromTo.text = "\(self.startTime )" +  " \(self.endTime )"
        
        self.total_amount = totalAmount
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.layer.frame.height / 2
        self.imgProfile.contentMode = .scaleAspectFill
        self.imgProfile.layer.borderWidth = 1
        self.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        
        self.imgProfile.loadImage(from:profileIMGURL,placeholder: UIImage(named: "user"))
        
        self.imgProperty.layer.cornerRadius = 20
        self.imgProperty.contentMode = .scaleAspectFill
        
        self.imgProperty.loadImage(from:propertyIMGURL,placeholder: UIImage(named: "img1"))
        self.lbl_Distance.text = self.propertyDistanceInMiles  + " miles away"
        self.lbl_propertyName.text = self.propertyName
        self.lbl_rating.text  = self.propertyRating
        self.lbl_numberOfReview.text  = "(\(self.propertyNumberofReview))"
        
        self.lbl_parkingDesc.text = parkDesc
        self.lbl_HostRulesDesc.text = HostingRulesDesc
        
        self.lbl_propertyName.text = self.propertyName
        self.lbl_rating.text = self.propertyRating
        self.lbl_numberOfReview.text = self.propertyNumberofReview
        
        let hourPrice = "\(self.booking_amount ?? 0.0)"
        self.lbl_hoursPrice.text = "$\(hourPrice.formattedPrice())"
        let cleaningFees = "\(self.ClearningFee ?? 0.0)"
        view_CleaningFee.isHidden = true
       if cleaningFees != "0.0" {
           self.lbl_CleaningFee.text = "$\(cleaningFees.formattedPrice())"
           view_CleaningFee.isHidden = false
        }
       
        let zyvoServiceFees = "\(self.zyvoServiceFee ?? 0.0)"
        view_ZyvoServiceFee.isHidden = true
       if zyvoServiceFees != "0.0" {
           self.lbl_ZyvoServiceFee.text = "$\(zyvoServiceFees.formattedPrice())"
           view_ZyvoServiceFee.isHidden = false
        }
        
        
        let taxFees = "\(self.taxAmount ?? 0.0)"
        view_TaxFee.isHidden = true
       if taxFees != "0.0" {
           self.lbl_tax.text = "$\(taxFees.formattedPrice())"
           view_TaxFee.isHidden = false
        }
        
        let addonFees = "\(self.AddonOnsPrice ?? 0.0)"
        let addonPrice = "$\(addonFees.formattedPrice())"
        if addonFees == "0.0" {
            self.view_AddOns.isHidden = true
        } else {
            self.view_AddOns.isHidden = false
            self.lbl_AddOnsAmount.text = addonPrice }
        
        print(DiscountAmount ?? 0.0,"DiscountAmount")
        
        if DiscountAmount == 0.0 || DiscountAmount == nil {
            view_Discount.isHidden = true
        } else {
            view_Discount.isHidden = false
            let DiscountAmountFee = "\(self.DiscountAmount ?? 0.0)"
            let DiscountAmountFees = "$\(DiscountAmountFee.formattedPrice())"
            self.lbl_discount.text = "-$\(DiscountAmountFees)"
        }
        
        viewHold_MessageHost.isHidden = true
        view_MessageHost.layer.cornerRadius = 20
        view_MessageHost.layer.borderWidth = 1.5
        view_MessageHost.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_AddmoreTime.layer.cornerRadius = view_AddmoreTime.layer.frame.height / 2
        view_AddmoreTime.layer.borderWidth = 1.5
        view_AddmoreTime.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_AddmoreTime.isHidden = true
        
        view_IhaveDoubt.layer.cornerRadius = 10
        view_IhaveDoubt.layer.borderWidth = 1.5
        view_IhaveDoubt.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_availableDays.layer.cornerRadius = 10
        view_availableDays.layer.borderWidth = 1.5
        view_availableDays.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_otherReason.layer.cornerRadius = 10
        view_otherReason.layer.borderWidth = 1.5
        view_otherReason.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_MessageHostDesc.layer.cornerRadius = 10
        view_MessageHostDesc.layer.borderWidth = 1.5
        view_MessageHostDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_HostDesc.isHidden = true
        view_HostDesc.layer.cornerRadius = 20
        view_HostDesc.layer.borderWidth = 1.5
        view_HostDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_ParkingDesc.isHidden = true
        view_ParkingDesc.layer.cornerRadius = 20
        view_ParkingDesc.layer.borderWidth = 1.5
        view_ParkingDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Card.isHidden = true
        view_Card.layer.cornerRadius = 20
        view_Card.layer.borderWidth = 1.5
        view_Card.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        StackAbove.layer.cornerRadius = 15
        StackAbove.layer.borderWidth = 1.5
        StackAbove.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        tblV.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
        tblV.delegate = self
        tblV.dataSource = self
        
        self.tblV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        viewOutSideSelectDate.isHidden = true
        btnSaveChangesDates.layer.cornerRadius = 10
        
        view_SelectDate.layer.cornerRadius = 10
        view_SelectDate.layer.borderWidth = 1.5
        view_SelectDate.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_date.layer.cornerRadius = 10
        view_date.layer.borderWidth = 1.5
        view_date.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_month.layer.cornerRadius = 10
        view_month.layer.borderWidth = 1.5
        view_month.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_year.layer.cornerRadius = 10
        view_year.layer.borderWidth = 1.5
        view_year.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Hours.layer.cornerRadius = view_Hours.layer.frame.height / 2
        view_Hours.layer.borderWidth = 1.5
        view_Hours.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Calendar.layer.cornerRadius = view_Calendar.layer.frame.height / 2
        view_Calendar.layer.borderWidth = 1.5
        view_Calendar.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_time2.layer.cornerRadius = view_time2.layer.frame.height / 2
        view_time2.layer.borderWidth = 1.5
        view_time2.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_CreditDebitCard.layer.cornerRadius = view_CreditDebitCard.layer.frame.height / 2
        view_CreditDebitCard.layer.borderWidth = 1.5
        view_CreditDebitCard.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewMain_SelectTimeFromTo.isHidden = true
        
        viewBelow_SelectTime.layer.cornerRadius = 10
        viewBelow_SelectTime.layer.borderWidth = 1.5
        viewBelow_SelectTime.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        viewFrom_hours.layer.cornerRadius = 10
        viewFrom_hours.layer.borderWidth = 1.5
        viewFrom_hours.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewFrom_mnt.layer.cornerRadius = 10
        viewFrom_mnt.layer.borderWidth = 1.5
        viewFrom_mnt.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewFrom_AMPM.layer.cornerRadius = 10
        viewFrom_AMPM.layer.borderWidth = 1.5
        viewFrom_AMPM.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        viewTo_hours.layer.cornerRadius = 10
        viewTo_hours.layer.borderWidth = 1.5
        viewTo_hours.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewTo_mnt.layer.cornerRadius = 10
        viewTo_mnt.layer.borderWidth = 1.5
        viewTo_mnt.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewTo_AMPM.layer.cornerRadius = 10
        viewTo_AMPM.layer.borderWidth = 1.5
        viewTo_AMPM.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        btnConfirmPay.layer.cornerRadius = btnConfirmPay.layer.frame.height / 2
        btnAddNewCard.layer.cornerRadius = btnAddNewCard.layer.frame.height / 2
        view_RulesParking.layer.cornerRadius = 10
        view_RulesParking.layer.borderWidth = 1.0
        view_RulesParking.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_HostRules.layer.cornerRadius = 10
        view_HostRules.layer.borderWidth = 1.0
        view_HostRules.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        let nib = UINib(nibName: "CellHost", bundle: nil)
        collecV_Host?.register(nib, forCellWithReuseIdentifier: "CellHost")
        collecV_Host.delegate = self
        collecV_Host.dataSource = self
        collVH.constant = 80
        updateCollectionViewHeight()
        
        view_Details.layer.cornerRadius = 20
        view_Details.layer.borderWidth = 1.5
        view_Details.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        btnShowMessageHost.layer.cornerRadius = 10
        btnShowMessageHost.layer.borderWidth = 1
        btnShowMessageHost.layer.borderColor = UIColor.black.cgColor
        
    }
    
    private func updateCollectionViewHeight() {
        // Get the content size of the collection view
        
        collecV_Host.layoutIfNeeded()
        let contentHeight1 = collecV_Host.contentSize.height
        collVH.constant = contentHeight1
        // Update the layout of the view
        self.view.layoutIfNeeded()
    }
    // Helper function to format price
    func formatPrice(_ amount: Double?) -> String {
        return "$\(String(format: "%.2f", amount ?? 0.0))"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblV.layer.removeAllAnimations()
        tblVH_Const.constant = tblV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    @IBAction func btnIhaveDoubt_Tap(_ sender: UIButton) {
        view_IhaveDoubt.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        view_availableDays.backgroundColor = UIColor.white
        view_otherReason.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnAvailableDays_Tap(_ sender: UIButton) {
        
        view_IhaveDoubt.backgroundColor = UIColor.clear
        view_availableDays.backgroundColor =  UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        view_otherReason.backgroundColor = UIColor.clear
        
    }
    
    @IBAction func btnOtherReason_Tap(_ sender: UIButton) {
        view_IhaveDoubt.backgroundColor = UIColor.clear
        view_availableDays.backgroundColor = UIColor.clear
        view_otherReason.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
    }
    
    @IBAction func btnSendMessageHost_Tap(_ sender: UIButton) {
        viewHold_MessageHost.isHidden = true
    }
    
    @IBAction func btnParking_Tap(_ sender: UIButton) {
        if isParkingRulesOpen == "no" {
            view_ParkingDesc.isHidden = false
            isParkingRulesOpen = "Yes"
        } else {
            view_ParkingDesc.isHidden = true
            isParkingRulesOpen = "no"
        }
    }
    @IBAction func btnHostRules_Tap(_ sender: UIButton) {
        if isHostTingRulesOpen == "no" {
            view_HostDesc.isHidden = false
            isHostTingRulesOpen = "Yes"
        } else {
            view_HostDesc.isHidden = true
            isHostTingRulesOpen = "no"
        }
    }
    
    @IBAction func btnCreditDebit_Tap(_ sender: UIButton) {
        if isCardOpen == "no" {
            view_Card.isHidden = false
            isCardOpen = "yes"
            imgDownArrowDebitCard.image = UIImage(named: "União 106")
        } else {
            view_Card.isHidden = true
            isCardOpen = "no"
            imgDownArrowDebitCard.image = UIImage(named: "dropdownicon")
        }
    }
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddNewCard_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        vc.backAction = {
            self.viewModel.apiForGetSavedCard()
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func btnSelectDate_Tap(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnConfirmPay_Tap(_ sender: UIButton) {
        
        viewModel.property_id = self.property_id
        viewModel.booking_start = self.booking_start
        viewModel.booking_end = self.booking_end
        viewModel.booking_date = self.booking_date
        viewModel.booking_hours = self.booking_hours ?? 0
        viewModel.booking_amount =  self.booking_amount ?? 0.0
        
        let bookingAmount = self.booking_amount ?? 0.0
        let cleaningFee = self.ClearningFee ?? 0.0
        let serviceFee = self.zyvoServiceFee ?? 0.0
        let tax = self.taxAmount ?? 0.0
        let addOns = self.AddonOnsPrice ?? 0.0
        
        let AddTotalAmount = bookingAmount + cleaningFee + serviceFee + tax + addOns
        
        self.total_amount = AddTotalAmount -  (self.DiscountAmount ?? 0.0)
        
        viewModel.total_amount = self.total_amount ?? 0.0
        
        addOnsNeddToSend = arrSelectedArr.filter { $0 < addOnsArr.count }.map { index in
            let addOn = addOnsArr[index]
            return [
                // Replace with actual properties of AddOn
                "name": addOn.name ?? "",
                "price": addOn.price ?? ""
            ]
        }
        if self.getCardArr?.count == 0  || self.getCardArr?.count ==  nil {
            self.showAlert(for: "Please add card")
        }  else if self.getCardArr?.count == 1 {
            self.card_id = self.getCardArr?[0].cardID ?? ""
            viewModel.service_fee =  "\(self.zyvoServiceFee ?? 0.0)"
            viewModel.cardID = self.card_id
            viewModel.customer_id =  self.customerID
            viewModel.tax =  "\(self.taxAmount ?? 0.0)"
            viewModel.discount_amount =  "\(self.DiscountAmount ?? 0.0)"
            
            viewModel.apiForBookingProperty(adsOns:addOnsNeddToSend)
        }
        else {
            if let preferredCardID = getCardArr?.compactMap({ $0.isPreferred == true ? $0.cardID : nil }).first {
                print("Preferred Card ID: \(preferredCardID)")
                self.card_id = "\(preferredCardID)"
            } else {
                print("No preferred card found")
            }
            
            viewModel.cardID = self.card_id
            viewModel.customer_id =  self.customerID
            viewModel.service_fee =  "\(self.zyvoServiceFee ?? 0.0)"
            viewModel.discount_amount =  "\(self.DiscountAmount ?? 0.0)"
            viewModel.tax =  "\(self.taxAmount ?? 0.0)"
            viewModel.apiForBookingProperty(adsOns:addOnsNeddToSend)
        }
        
    }
    
    @IBAction func btnShowMessageHost_Tap(_ sender: UIButton) {
        let senderID = UserDetail.shared.getUserId()
        viewModel1.apiForJoinChannel(senderId: senderID, receiverId: "\(self.hostID )", groupChannel: self.channelName, userType: "guest")
    }
    
    @IBAction func btnHours_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnbelowSelectDate_Tap(_ sender: UIButton) {
        // Set up the dropdown
        
        dateDropDown.anchorView = sender // You can set it to a UIButton or any UIView
        dateDropDown.dataSource = daysArr
        dateDropDown.direction = .bottom
        
        dateDropDown.bottomOffset = CGPoint(x: 3, y:(dateDropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        dateDropDown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            
        }
        dateDropDown.show()
    }
    
    @IBAction func btnAddMoreTime_Tap(_ sender: UIButton) {
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoreTimePopUpVC") as! AddMoreTimePopUpVC
        //        vc.backAction = {
        //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TotalAmountPopUpVC") as! TotalAmountPopUpVC
        //            vc.modalPresentationStyle = .overCurrentContext
        //            self.present(vc, animated: true)
        //        }
        //        vc.modalPresentationStyle = .overCurrentContext
        //        self.present(vc, animated: true)
        
    }
    
    @IBAction func btnbelowMonth_Tap(_ sender: UIButton) {
        // Set up the dropdown
        
        monthDropDown.anchorView = sender // You can set it to a UIButton or any UIView
        monthDropDown.dataSource = monthNamesArr
        monthDropDown.direction = .bottom
        
        monthDropDown.bottomOffset = CGPoint(x: 3, y:(monthDropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        monthDropDown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            
        }
        monthDropDown.show()
    }
    @IBAction func btnbelowYear_Tap(_ sender: UIButton) {
        // Set up the dropdown
        
        yearDropDown.anchorView = sender // You can set it to a UIButton or any UIView
        yearDropDown.dataSource = yearStrings
        yearDropDown.direction = .bottom
        
        yearDropDown.bottomOffset = CGPoint(x: 3, y:(yearDropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        yearDropDown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            
        }
        yearDropDown.show()
    }
    
    @IBAction func showMoreRefundPolicyBtn(_ sender: UIButton){
        if showRefundPolicy == "no"{
            self.showRefundPolicy = "yes"
            sender.setTitle("Read less", for: .normal)
            self.refundPolicyLbl.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever the industry's standard dummy .Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever the industry's standard dummy .Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        }else{
            self.showRefundPolicy = "no"
            sender.setTitle("Read more", for: .normal)
            self.refundPolicyLbl.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever the industry's standard dummy."
        }
    }
    
    @IBAction func btnShowMore_Tap(_ sender: UIButton) {
       
            isReadMore.toggle()

              if isReadMore {
                  // See Less state — show all
                  addOnsArr = fulladdOnsArr
                  sender.setTitle("Show Less", for: .normal)

                  // Reload and update height
                  self.collecV_Host.reloadData()
                  self.collecV_Host.layoutIfNeeded()
                  let contentHeight = self.collecV_Host.collectionViewLayout.collectionViewContentSize.height
                  self.collVH.constant = contentHeight
              } else {
                  // See More state — show limited
                  addOnsArr = Array(fulladdOnsArr.prefix(4))
                  sender.setTitle("Show More", for: .normal)
                  self.collVH.constant = 320
              }

              UIView.animate(withDuration: 0.3) {
                  self.view.layoutIfNeeded()
              }

       
    }
    
    @IBAction func btnSelectTimeFromTo_Tap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveChangesTimeFromTo_Tap(_ sender: Any) {
        viewMain_SelectTimeFromTo.isHidden = true
    }
    
    @IBAction func btnSaveChangesSelectDate_Tap(_ sender: UIButton) {
        viewOutSideSelectDate.isHidden = true
    }
    
    func calculateFinalPriceWithDiscount(totalPrice: Double, discountPercent: Double, taxPercent: Double) -> (totalPrice: Double, discountAmount: Double, discountedPrice: Double, taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Discount Amount
        let discountAmount = totalPrice * (discountPercent / 100)
        
        // Step 2: Calculate Discounted Price after Deducting Discount Amount
        let discountedPrice = totalPrice - discountAmount
        
        // Step 3: Calculate Tax Amount
        let taxAmount = discountedPrice * (taxPercent / 100)
        
        let roundedTaxAmount = taxAmount.rounded(toPlaces: 2)
        print(roundedTaxAmount) // Output: 1.28
        
        // Step 4: Final Price after Adding Tax Amount
        let finalPrice = discountedPrice + taxAmount
        
        // Return All Values as a Tuple
        return (totalPrice, discountAmount, discountedPrice, roundedTaxAmount, finalPrice)
    }
    func calculateFinalPriceWithoutDiscount(totalPrice: Double, taxPercent: Double) -> (taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Tax Amount
        let taxAmount = totalPrice * (taxPercent / 100)
        
        let roundedTaxAmount = taxAmount.rounded(toPlaces: 2)
        print(roundedTaxAmount) // Output: 1.28
        
        // Step 2: Final Price after Tax
        let finalPrice = totalPrice + taxAmount
        
        return (roundedTaxAmount, finalPrice)
    }
}

extension CheckoutVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return addOnsArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        if collectionView == collecV_Host {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellHost", for: indexPath) as! CellHost
        let data = addOnsArr[indexPath.row]
        cell.lbl_title.text = data.name
        var hour = data.price ?? ""
        let price = hour.formattedPrice()
        if price != "" {
            cell.lbl_price.text = "$\(price) / Item"
        } else {
            cell.lbl_price.text = ""
        }
        if arrSelectedArr.contains(indexPath.row){
            cell.mainV.layer.borderColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
        }else{
            cell.mainV.layer.borderColor = UIColor.init(red: 177/255, green: 177/255, blue: 177/255, alpha: 1).cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collecV_Host{
            if arrSelectedArr.contains(indexPath.row){
                if let index = arrSelectedArr.firstIndex(of: indexPath.row) {
                    arrSelectedArr.remove(at: index)
                }
            }else{
                self.arrSelectedArr.append(indexPath.row)
            }
            updateTotalPrice(index : indexPath.row)
            
            self.collecV_Host.reloadData()
            
        }
    }
    func updateTotalPrice(index : Int) {
        
        let total = arrSelectedArr.reduce(0) { sum, index in
            let price = Double(addOnsArr[index].price ?? "0") ?? 0.0
            return sum + price
        }
        
        print("Total Price: $\(total)")
        self.AddonOnsPrice = total
        
        let bookingAmount = self.booking_amount ?? 0.0
        let cleaningFee = self.ClearningFee ?? 0.0
        let serviceFee = self.zyvoServiceFee ?? 0.0
        let tax = self.taxAmount ?? 0.0
        var addOns = self.AddonOnsPrice ?? 0.0
        
        let AddTotalAmount = bookingAmount + cleaningFee + serviceFee + tax + total
        
        let totalAmount = AddTotalAmount -  (self.DiscountAmount ?? 0.0)
        
        let totalsum = "\(totalAmount)"
        
        self.lbl_finalPrice.text = "$\(totalsum.formattedPrice())"
        
        self.total_amount = totalAmount
        let priceAddOn = "\(self.AddonOnsPrice ?? 0.0)"
        
        if priceAddOn == "0.0" {
            self.view_AddOns.isHidden = true
        }else {
            self.view_AddOns.isHidden = false
        }
        self.lbl_AddOnsAmount.text = "$\(priceAddOn.formattedPrice())"
        
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10 // Adjust spacing as needed
        let numberOfColumns: CGFloat = 1
        let totalSpacing = (numberOfColumns - 1) * spacing
        
        let itemWidth = (collecV_Host.bounds.width - totalSpacing) / numberOfColumns
        let itemHeight: CGFloat = 70 // Fixed height as per your code
        print(itemWidth,itemHeight,"itemWidth,itemHeight")
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between rows
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between columns
    }
}

extension CheckoutVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCardArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
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
extension CheckoutVC {
    
    func bindVC(){
        // get Guides Details
        viewModel.$bookingPropertyResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    print(response.message ?? "")
                    self.bookingResult = response.data
                    self.bookingID = "\(self.bookingResult?.booking?.id ?? 0)"
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutConfirmationVC") as! CheckOutConfirmationVC
                    vc.startTime = self.startTime
                    vc.channelName = self.channelName
                    vc.hostID = self.hostID
                    vc.endTime = self.endTime
                    vc.awardStatus = self.awardStatus
                    
                    vc.hostName = self.hostName
                    vc.propertyDistanceInMiles = self.propertyDistanceInMiles
                    vc.propertyName = self.propertyName
                    vc.propertyRating = self.propertyRating
                    vc.propertyNumberofReview =  self.propertyNumberofReview
                    vc.propertyIMGURL =  self.propertyIMGURL
                    vc.perHourRate = self.perHourRate
                    vc.booking_start = self.StartDatetime
                    vc.booking_end = self.EndDatetime
                    vc.booking_hours = self.booking_hours ?? 0
                    vc.booking_amount = self.booking_amount
                    vc.property_id = self.property_id
                    vc.propertyID = self.property_id
                    vc.booking_date = self.booking_date
                    vc.bookingID = self.bookingID
                    // vc.addOnsNeddToSend = self.addOnsNeddToSend
                    vc.taxAmount =  self.taxAmount
                    vc.minBookhours = self.minBookhours
                    vc.DiscountAmount = self.DiscountAmount
                    vc.ClearningFee = (self.ClearningFee ?? 0.0)
                    vc.zyvoServiceFee = self.zyvoServiceFee ?? 0.0
                    vc.AddonOnsPrice = self.AddonOnsPrice ?? 0.0
                    vc.addOnsArr = self.addOnsArr
                    vc.arrSelectedArr = self.arrSelectedArr
                    vc.profileIMGURL = self.profileIMGURL
                    vc.parkDesc = self.parkDesc
                    vc.HostingRulesDesc = self.HostingRulesDesc
                    vc.DiscountPercentage = self.DiscountPercentage
                    vc.taxPercentage = self.taxPercentage
                    vc.zyvoServicePercentage = self.zyvoServicePercentage
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                })
            }.store(in: &cancellables)
        
        
        viewModel.$getCardResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    
                    self.getCardArr = response.data?.cards
                    
                    self.customerID = response.data?.stripeCustomerID ?? ""
                    self.tblV.reloadData()
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
        
        viewModel1.$getJoinChannelResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    self.getJoinChannelDetails = response.data
                    
                    var senderID =  self.getJoinChannelDetails?.senderID ?? ""
                    var receiverID =  self.getJoinChannelDetails?.receiverID ?? ""
                    
                    let guestIMG = self.getJoinChannelDetails?.senderAvatar ?? ""
                    self.guestProfileImg = AppURL.imageURL + guestIMG
                    
                    let HostIMG = self.getJoinChannelDetails?.receiverAvatar ?? ""
                    self.hostProfileImg = AppURL.imageURL + HostIMG
                    
                    let stryB = UIStoryboard(name: "Chat", bundle: nil)
                    if let vc = stryB.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC {
                        vc.uniqueConversationName = self.channelName
                        vc.friend_id = "\(receiverID)"
                        vc.SenderID = senderID
                        vc.guestName = self.getJoinChannelDetails?.senderName ?? ""
                        vc.hostProfileImg = self.hostProfileImg
                        vc.guesttProfileImg =  self.guestProfileImg
                        self.tabBarController?.tabBar.isHidden = true
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                })
            }.store(in: &cancellables)
        
        
    }
}
