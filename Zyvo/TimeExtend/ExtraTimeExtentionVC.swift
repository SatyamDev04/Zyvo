//
//  ExtraTimeExtentionVC.swift
//  Zyvo
//
//  Created by ravi on 4/12/24.
//

import UIKit
import DropDown
import Combine

class ExtraTimeExtentionVC: UIViewController {
    var isCardOpen = "no"
    var isParkingRulesOpen = "no"
    var isHostTingRulesOpen = "no"
    @IBOutlet weak var view_ParkingDesc: UIView!
    @IBOutlet weak var viewHold_MessageHost: UIView!
    @IBOutlet weak var view_MessageHost: UIView!
    @IBOutlet weak var view_HostDesc: UIView!
    @IBOutlet weak var view_Card: UIView!
    @IBOutlet weak var imgDownArrowDebitCard: UIImageView!
    @IBOutlet weak var view_DebitCreditCard: UIView!
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
    @IBOutlet weak var collecV_BankingDetails: UICollectionView!
    
    @IBOutlet weak var lbl_hostName: UILabel!
    
    @IBOutlet weak var lbl_PropertyTitle: UILabel!
    @IBOutlet weak var imgProfileHost: UIImageView!
    
    @IBOutlet weak var imgProperty: UIImageView!
    
    @IBOutlet weak var lbl_rating: UILabel!
    
    @IBOutlet weak var lbl_DistanceInMiles: UILabel!
    @IBOutlet weak var lbl_numberOfReview: UILabel!
    
    @IBOutlet weak var lbl_Taxes: UILabel!
    @IBOutlet weak var lbl_ZyvoFee: UILabel!
    @IBOutlet weak var lbl_CleaningFee: UILabel!
    @IBOutlet weak var lbl_HoursBasedTotal: UILabel!
    @IBOutlet weak var lbl_AboveHours: UILabel!
    @IBOutlet weak var lbl_HostRulesDesc: UILabel!
    @IBOutlet weak var lbl_ParkingRulesDesc: UILabel!
    @IBOutlet weak var lbl_TimeFromTo: UILabel!
    @IBOutlet weak var lbl_BelowBookingHours: UILabel!
    @IBOutlet weak var lbl_BookedDate: UILabel!
    @IBOutlet weak var lbl_FinalPrice: UILabel!
    @IBOutlet weak var lbl_AddonPrice: UILabel!
    
    @IBOutlet weak var lbl_discount: UILabel!
    
    
    @IBOutlet weak var view_Details: UIView!
    @IBOutlet weak var btnShowMessageHost: UIButton!
    @IBOutlet weak var btnAddNewCard: UIButton!
    
    @IBOutlet weak var view_Calendar: UIView!
    
    @IBOutlet weak var view_Hours: UIView!
    
    @IBOutlet weak var view_time2: UIView!
    
    @IBOutlet weak var view_AddOns: UIView!
    @IBOutlet weak var imgHostStar: UIImageView!
    @IBOutlet weak var view_Discount: UIView!
    @IBOutlet weak var view_AddMore: UIView!
    @IBOutlet weak var view_AddmoreTime: UIView!
    let items = ["October 22, 2023   ", "From 01pm to 03pm", "2 Hours"]
    var imgArr = ["calenderblackicon","watchblackicon","watchblackicon"]
    
    var arrHost = ["Computer Screen","Bed Sheets","Phone charger","Ring Light"]
    
    private let spacing:CGFloat = 16.0
    
    let timeDropdown = DropDown()
    
    let hoursDropdown = DropDown()
    let arrHours = ["30 minutes","1 hour","2 hours","3 hours","4 hours","5 hours","6 hours","7 hours","8 hours","9 hours","10 hours","11 hours","12 hours"]
    
    var Times = ["Highest Review","Lowest Review","Recent Reviews"]
    var awardStatus : Bool = false
    var startTime = ""
    var endTime = ""
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
    var zyvoServiceFeePercentage : Double? = 0
    var tax : Double? = 0
    var StartDatetime = ""
    var EndDatetime = ""
    var addOnsArr: [AddOn] = []
    var arrSelectedArr :[Int] = []
    var DiscountPercentage : Double? = 0.0
    var taxPercentage : Double? = 0.0
    
    @IBOutlet weak var view_TaxFee: UIView!
    @IBOutlet weak var view_ZyvoServiceFee: UIView!
    @IBOutlet weak var view_CleaningFee: UIView!
    var parkDesc = ""
    var HostingRulesDesc = ""
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = BookingPropertyViewModel()
    
    private var viewModel2 = ExtraTimeViewModel()
    
    
    var hostID = 0
    var channelName = ""
    
    private var viewModel1 = BookingDetailsViewModel()
    
    var getJoinChannelDetails : JoinChanelModel?
    
    var hostProfileImg = ""
    
    var guestProfileImg = ""
    
    
    var getCardArr : [Card]?
    
    var card_id = ""
    
    var customerID = ""
    
    var indx : Int? = 0
    
    var ComingFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
        self.imgHostStar.isHidden = true
        if self.awardStatus == false {
            self.imgHostStar.isHidden = true
        } else {
            self.imgHostStar.isHidden = false
        }
        
        let guestID = Int(UserDetail.shared.getUserId())
        let hostID = self.hostID
        
        let id1 = min(guestID ?? 0 , hostID)
        let id2 = max(guestID ?? 0, hostID)
        
        self.channelName = "ZYVOOPROJ_\(id1)_\(id2)_\(self.property_id)"
        print(self.channelName,"self.channelName")
        print(id1,id2,self.propertyID,"ASDFASDF")
        
        viewModel.apiForGetSavedCard()
        print(zyvoServiceFeePercentage ?? 0.0,"zyvoServiceFeePercentage")
        
        if (booking_hours ?? 0) > 1 {
            self.lbl_AboveHours.text = "\(booking_hours ?? 0) hours"
            self.lbl_BelowBookingHours.text = "\(booking_hours ?? 0) hours"
        } else {
            self.lbl_AboveHours.text = "\(booking_hours ?? 0) hour"
            self.lbl_BelowBookingHours.text = "\(booking_hours ?? 0) hour"
        }
        
        let inputDate = "\(booking_date)"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: inputDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM, d yyyy"
            let outputDate = outputFormatter.string(from: date)
            
            print(outputDate) // Output: March, 4 2025
            self.lbl_BookedDate.text = "\(outputDate)"
        }
        print("\(booking_date) \(self.startTime) asdfsdfadsfasdf")
        self.lbl_TimeFromTo.text = "\(self.startTime)" + " \(self.endTime)"
        let bookingAmount = self.booking_amount ?? 0.0
        let cleaningFee = self.ClearningFee ?? 0.0
        let serviceFee = self.zyvoServiceFee ?? 0.0
        let tax = (self.taxAmount ?? 0.0).rounded(toPlaces: 2)
        let addOns = self.AddonOnsPrice ?? 0.0
        let AddTotalAmount = (bookingAmount + cleaningFee + serviceFee + tax + addOns).rounded(toPlaces: 2)
        let totalAmount = (AddTotalAmount -  (self.DiscountAmount ?? 0.0)).rounded(toPlaces: 2)
        let totalFee = "\(totalAmount)"
        self.lbl_FinalPrice.text = "$\(totalFee.formattedPrice())"
        self.lbl_hostName.text = self.hostName
        self.total_amount = totalAmount
        self.imgProfileHost.layer.cornerRadius = self.imgProfileHost.layer.frame.height / 2
        self.imgProfileHost.contentMode = .scaleAspectFill
        self.imgProfileHost.layer.borderWidth = 1
        self.imgProfileHost.layer.borderColor = UIColor.lightGray.cgColor
        self.imgProfileHost.loadImage(from:profileIMGURL,placeholder: UIImage(named: "user"))
        self.imgProperty.loadImage(from:propertyIMGURL,placeholder: UIImage(named: "img1"))
        self.lbl_DistanceInMiles.text = self.propertyDistanceInMiles  + " sqft"
        self.lbl_PropertyTitle.text = self.propertyName
        self.lbl_rating.text  = self.propertyRating
        self.lbl_numberOfReview.text  = "(\(self.propertyNumberofReview))"
        self.lbl_ParkingRulesDesc.text = parkDesc
        self.lbl_HostRulesDesc.text = HostingRulesDesc
        self.lbl_PropertyTitle.text = self.propertyName
        self.lbl_rating.text = self.propertyRating
        self.lbl_numberOfReview.text = self.propertyNumberofReview
        
        let BookingAmountFee = "\(self.booking_amount ?? 0.0)"
        if BookingAmountFee != "0.0" {
            self.lbl_HoursBasedTotal.text = "$\(BookingAmountFee.formattedPrice())"
        }
        let CleaninFees = "\(self.ClearningFee ?? 0.0)"
            view_CleaningFee.isHidden = true
            if CleaninFees != "0.0" {
                self.lbl_CleaningFee.text = "$\(CleaninFees.formattedPrice())"
            view_CleaningFee.isHidden = false
          }
        
        let zyvoServiceFees = "\(self.zyvoServiceFee ?? 0.0)"
            view_ZyvoServiceFee.isHidden = true
           if zyvoServiceFees != "0.0" {
               self.lbl_ZyvoFee.text = "$\(zyvoServiceFees.formattedPrice())"
           view_ZyvoServiceFee.isHidden = false
          }
       
        let taxFees = "\(self.taxAmount ?? 0.0)"
            view_TaxFee.isHidden = true
           if taxFees != "0.0" {
               self.lbl_Taxes.text = "$\(taxFees.formattedPrice())"
               view_TaxFee.isHidden = false
          }
       
        
        let addonPrice = "\(self.AddonOnsPrice ?? 0.0)"
        if addonPrice == "0.0" {
            self.view_AddOns.isHidden = true
        } else {
            self.view_AddOns.isHidden = false
            self.lbl_AddonPrice.text = "$\(addonPrice.formattedPrice())" }
        
        print(DiscountAmount ?? 0.0,"DiscountAmount")
        if DiscountAmount == 0.0 || DiscountAmount == nil {
            view_Discount.isHidden = true
        } else {
            view_Discount.isHidden = false
            let DiscountFee = "\(self.DiscountAmount ?? 0.0)"
            self.lbl_discount.text = "-$\(DiscountFee.formattedPrice())"
        }
        view_AddMore.layer.cornerRadius = view_AddMore.layer.frame.height / 2
        view_AddMore.layer.borderWidth = 1.5
        view_AddMore.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Hours.layer.cornerRadius = view_Hours.layer.frame.height / 2
        view_Hours.layer.borderWidth = 1.5
        view_Hours.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Calendar.layer.cornerRadius = view_Calendar.layer.frame.height / 2
        view_Calendar.layer.borderWidth = 1.5
        view_Calendar.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_time2.layer.cornerRadius = view_time2.layer.frame.height / 2
        view_time2.layer.borderWidth = 1.5
        view_time2.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_AddmoreTime.layer.cornerRadius = view_AddmoreTime.layer.frame.height / 2
        view_AddmoreTime.layer.borderWidth = 1.5
        view_AddmoreTime.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewHold_MessageHost.isHidden = true
        view_MessageHost.layer.cornerRadius = 20
        view_MessageHost.layer.borderWidth = 1.5
        view_MessageHost.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
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
        
        
        view_DebitCreditCard.layer.cornerRadius = view_DebitCreditCard.layer.frame.height / 2
        view_DebitCreditCard.layer.borderWidth = 1.5
        view_DebitCreditCard.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
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
        
        
        StackAbove.layer.cornerRadius = 20
        StackAbove.layer.borderWidth = 1.5
        StackAbove.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        tblV.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
        tblV.delegate = self
        tblV.dataSource = self
        
        self.tblV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        btnConfirmPay.layer.cornerRadius = btnConfirmPay.layer.frame.height / 2
        
        btnAddNewCard.layer.cornerRadius = btnAddNewCard.layer.frame.height / 2
        
        view_RulesParking.layer.cornerRadius = 10
        view_RulesParking.layer.borderWidth = 1.0
        view_RulesParking.layer.borderColor = UIColor.lightGray.cgColor
        
        view_HostRules.layer.cornerRadius = 10
        view_HostRules.layer.borderWidth = 1.0
        view_HostRules.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Details.layer.cornerRadius = 30
        view_Details.layer.borderWidth = 0.5
        view_Details.layer.borderColor = UIColor.lightGray.cgColor
        
        btnShowMessageHost.layer.cornerRadius = 10
        btnShowMessageHost.layer.borderWidth = 1
        btnShowMessageHost.layer.borderColor = UIColor.black.cgColor
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblV.layer.removeAllAnimations()
        tblVH_Const.constant = tblV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    @IBAction func btnAddMoreTime_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoreTimePopUpVC") as! AddMoreTimePopUpVC
        vc.perHourRate = self.perHourRate ?? 0
        vc.backAction = {  str, str2 in
            
            self.booking_hours = str
            self.booking_amount = Double(str2)
            print(str,str2,"dataReceived")
          
            // Sample date string
            let dateString = "\(self.booking_date) \(self.startTime)"//2025-09-16 09:24 PM"

            // Date formatter for parsing the input
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"

            // Convert the string to a Date object
            if let startTime = dateFormatter.date(from: dateString) {
                
                // Add 4 hours to the start time
                let calendar = Calendar.current
                if let endTime = calendar.date(byAdding: .hour, value: str, to: startTime) {
                    
                    // Convert the end time to just the time part
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "hh:mm a"
                    
                    let endTimeString = timeFormatter.string(from: endTime)
                    
                    print("End Time: \(endTimeString)")
                    self.lbl_TimeFromTo.text = "\(self.startTime) - \(endTimeString)"
                }
            }

            if (self.booking_hours ?? 0) > (self.minBookhours ?? 0) {
                let result = self.calculateFinalPriceWithDiscount(totalPrice: self.booking_amount ?? 0.0, discountPercent: self.DiscountPercentage ?? 0.0, taxPercent: self.taxPercentage ?? 0.0)
                print("================================WithDiscount====================================")
                // Printing the Result
                print("Total Price: \(result.totalPrice)")
                print("Discount Amount (\(String(describing: self.DiscountPercentage))%) : \(result.discountAmount)")
                print("Discounted Price: \(result.discountedPrice)")
                print("Tax Amount (\(String(describing: self.taxPercentage ?? 0.0))%): \(result.taxAmount )")
                self.taxAmount = result.taxAmount
                self.DiscountAmount = result.discountAmount
                print("Final Price: \(result.finalPrice)")
                self.view_Discount.isHidden = false
                
            } else {
                let result = self.calculateFinalPriceWithoutDiscount(totalPrice: self.booking_amount ?? 0.0, taxPercent: self.taxPercentage ?? 0.0)
                
                print("================================WithoutDiscount====================================")
                print("Tax Amount: \(result.taxAmount)")
                self.taxAmount = result.taxAmount// 45.0
                self.DiscountAmount = 0.0
                self.view_Discount.isHidden = true
                print("Final Price After Tax: \(result.finalPrice)") // 945.0
            }
            
            let zyvoFeePercentage = Double(self.zyvoServiceFeePercentage ?? 0.0)
            let bookingAmount = self.booking_amount ?? 0.0
            self.zyvoServiceFee = ((bookingAmount * zyvoFeePercentage) / 100.0).rounded(toPlaces: 2)
            
            print(self.zyvoServiceFee ?? 0.0,"self.zyvoServiceFee")
            let cleaningFee = self.ClearningFee ?? 0.0
            let serviceFee = self.zyvoServiceFee ?? 0.0
            let tax = self.taxAmount ?? 0.0
            let addonPrice = self.AddonOnsPrice ?? 0.0
            if (self.booking_hours ?? 0) > 1 {
                self.lbl_AboveHours.text = "\(self.booking_hours ?? 0) hours"
                self.lbl_BelowBookingHours.text = "\(self.booking_hours ?? 0) hours"
            } else {
                self.lbl_AboveHours.text = "\(self.booking_hours ?? 0) hour"
                self.lbl_BelowBookingHours.text = "\(self.booking_hours ?? 0) hour"
            }
            
            let hourBasedTotal = "\(self.booking_amount ?? 0.0)"
            if hourBasedTotal != "0.0" {
                self.lbl_HoursBasedTotal.text = "$\(hourBasedTotal.formattedPrice())"
            }
            
            let cleaningFees = "\(cleaningFee)"
            self.view_CleaningFee.isHidden = true
                 if cleaningFees != "0.0" {
                     self.lbl_CleaningFee.text = "$\(cleaningFees.formattedPrice())"
                     self.view_CleaningFee.isHidden = false
                  }
           
            let zyvoServiceFees = "\(self.zyvoServiceFee ?? 0.0)"
            self.view_ZyvoServiceFee.isHidden = true
                 if zyvoServiceFees != "0.0" {
                     self.lbl_ZyvoFee.text = "$\(zyvoServiceFees.formattedPrice())"
                     self.view_ZyvoServiceFee.isHidden = true
                  }
            
            let taxFees = "\(self.taxAmount ?? 0.0)"
            self.view_TaxFee.isHidden = true
                 if taxFees != "0.0" {
                     self.lbl_Taxes.text = "$\(taxFees.formattedPrice())"
                     self.view_TaxFee.isHidden = false
                  }
            
            let addOnFees = "\(self.AddonOnsPrice ?? 0.0)"
            self.view_AddOns.isHidden = true
                 if addOnFees != "0.0" {
                     self.lbl_AddonPrice.text = "\(addOnFees.formattedPrice())"
                     self.view_AddOns.isHidden = false
                  }
           
            
            let AddTotalAmount = (self.booking_amount ?? 0.0 + cleaningFee + serviceFee + tax + addonPrice).rounded(toPlaces: 2)
            
            self.total_amount = AddTotalAmount -  (self.DiscountAmount ?? 0.0)
            let totalFees = "\(self.total_amount ?? 0.0)"
            self.lbl_FinalPrice.text = "$\(totalFees.formattedPrice())"
            
        }
        
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
        
    }
    
    func calculateFinalPriceWithDiscount(totalPrice: Double, discountPercent: Double, taxPercent: Double) -> (totalPrice: Double, discountAmount: Double, discountedPrice: Double, taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Discount Amount
        let discountAmount = (totalPrice * (discountPercent / 100)).rounded(toPlaces: 2)
        
        
        // Step 2: Calculate Discounted Price after Deducting Discount Amount
        let discountedPrice = (totalPrice - discountAmount).rounded(toPlaces: 2)
        
        // Step 3: Calculate Tax Amount
        let taxAmount = (discountedPrice * (taxPercent / 100)).rounded(toPlaces: 2)
        
        // Step 4: Final Price after Adding Tax Amount
        let finalPrice = (discountedPrice + taxAmount).rounded(toPlaces: 2)
        
        // Return All Values as a Tuple
        return (totalPrice, discountAmount, discountedPrice, taxAmount, finalPrice)
    }
    func calculateFinalPriceWithoutDiscount(totalPrice: Double, taxPercent: Double) -> (taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Tax Amount
        let taxAmount = (totalPrice * (taxPercent / 100)).rounded(toPlaces: 2)
        // Step 2: Final Price after Tax
        let finalPrice = (totalPrice + taxAmount).rounded(toPlaces: 2)
        return (taxAmount, finalPrice)
    }
    
    @IBAction func btnHours_Tap(_ sender: UIButton) {
        
        // Set up the dropdown
        
        hoursDropdown.anchorView = sender // You can set it to a UIButton or any UIView
        hoursDropdown.dataSource = arrHours
        hoursDropdown.direction = .bottom
        
        hoursDropdown.bottomOffset = CGPoint(x: 3, y:(hoursDropdown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        hoursDropdown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            
            let text = "\(item)"
            let numberOnly = text.filter { $0.isNumber }
            print(numberOnly)
            
            self?.booking_hours = Int(numberOnly)
            
            self?.booking_amount = Double(((self?.booking_hours ?? 0) * (self?.perHourRate ?? 0)))
            
        }
        hoursDropdown.show()
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
        
        let senderID = UserDetail.shared.getUserId()
        viewModel1.apiForJoinChannel(senderId: senderID, receiverId: "\(self.hostID )", groupChannel: self.channelName, userType: "guest")
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
        print("HELLO")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddNewCard_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        self.present(vc, animated: true)
    }
    
    @IBAction func btnPositiveRating_Tap(_ sender: UIButton) {
        // Set up the dropdown
        
        timeDropdown.anchorView = sender // You can set it to a UIButton or any UIView
        timeDropdown.dataSource = Times
        timeDropdown.direction = .bottom
        
        timeDropdown.bottomOffset = CGPoint(x: 3, y:(timeDropdown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        timeDropdown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            
        }
        timeDropdown.show()
    }
    
    @IBAction func btnShowMessageHost_Tap(_ sender: UIButton) {
        viewModel1
        viewHold_MessageHost.isHidden = false
        
    }
    @IBAction func btnConfirmPay_Tap(_ sender: UIButton) {
        viewModel2.extension_time = self.booking_hours ?? 0
        viewModel2.service_fee = "\(self.zyvoServiceFee ?? 0.0)"
        viewModel2.tax = "\(self.taxAmount ?? 0.0)"
        viewModel2.cleaning_fee = "\(self.ClearningFee ?? 0.0)"
        
        let bookingAmount = self.booking_amount ?? 0.0
        let cleaningFee = self.ClearningFee ?? 0.0
        let serviceFee = self.zyvoServiceFee ?? 0.0
        let tax = self.taxAmount ?? 0.0
        let AddTotalAmount = bookingAmount + cleaningFee + serviceFee + tax
        
        self.total_amount = AddTotalAmount -  (self.DiscountAmount ?? 0.0)
        
        viewModel2.extension_total_amount = "\(self.total_amount ?? 0.0)"
        
        viewModel2.extension_booking_amount = "\(self.booking_amount ?? 0.0)"
        if self.getCardArr?.count == 0  || self.getCardArr?.count ==  nil {
            self.showAlert(for: "Please add card")
        }  else if self.getCardArr?.count == 1 {
            self.card_id = self.getCardArr?[0].cardID ?? ""
            
            viewModel2.customer_id =  self.customerID
            viewModel2.service_fee =  "\(self.zyvoServiceFee ?? 0.0)"
            viewModel2.discount_amount =  "\(self.DiscountAmount ?? 0.0)"
            viewModel2.tax =  "\(self.taxAmount ?? 0.0)"
            viewModel2.apiForGetExtraTime(BookingID: self.bookingID)
            
        }
        else {
            if let preferredCardID = getCardArr?.compactMap({ $0.isPreferred == true ? $0.cardID : nil }).first {
                print("Preferred Card ID: \(preferredCardID)")
                self.card_id = "\(preferredCardID)"
            } else {
                print("No preferred card found")
            }
            
            viewModel2.cardID = self.card_id
            viewModel2.customer_id =  self.customerID
            viewModel2.service_fee =  "\(self.zyvoServiceFee ?? 0.0)"
            viewModel2.discount_amount =  "\(self.DiscountAmount ?? 0.0)"
            viewModel2.tax =  "\(self.taxAmount ?? 0.0)"
            viewModel2.apiForGetExtraTime(BookingID: self.bookingID)
            
        }
    }
}

extension ExtraTimeExtentionVC :UITableViewDelegate,UITableViewDataSource {
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

extension ExtraTimeExtentionVC {
    
    func bindVC(){
        
        viewModel1.$getJoinChannelResult
                  .receive(on: DispatchQueue.main)
                  .sink { [weak self] result in
                      guard let self = self else{return}
                      result?.handle(success: { response in
                          self.getJoinChannelDetails = response.data
                          let senderID =  self.getJoinChannelDetails?.senderID ?? ""
                          let receiverID =  self.getJoinChannelDetails?.receiverID ?? ""
                          
                          let guestIMG = self.getJoinChannelDetails?.senderAvatar ?? ""
                          self.guestProfileImg = AppURL.imageURL + guestIMG
                          
                          let HostIMG = self.getJoinChannelDetails?.receiverAvatar ?? ""
                          self.hostProfileImg = AppURL.imageURL + HostIMG
                          
                          let stryB = UIStoryboard(name: "Chat", bundle: nil)
                          if let vc = stryB.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC {
                          vc.uniqueConversationName = self.channelName
                          vc.SenderID = senderID
                          vc.friend_id = "\(receiverID)"
                          vc.guestName = self.getJoinChannelDetails?.senderName ?? ""
                          vc.hostProfileImg = self.hostProfileImg
                          vc.guesttProfileImg =  self.guestProfileImg
                          self.tabBarController?.tabBar.isHidden = true
                          vc.hidesBottomBarWhenPushed = true
                          self.navigationController?.pushViewController(vc, animated: true)
                          }
                      })
                  }.store(in: &cancellables)
        
        viewModel.$getCardResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
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
        
        //getExtratimeRsult
        viewModel2.$getExtratimeResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    
                    if self.ComingFrom == "Discover" {
                        UserDetail.shared.setisTimeExtend("Yes")
                    }
                    self.tabBarController?.selectedIndex = 2
                })
            }.store(in: &cancellables)
    }
}
