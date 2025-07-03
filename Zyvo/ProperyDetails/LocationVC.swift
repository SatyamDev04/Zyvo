//
//  LocationVC.swift
//  Zyvo
//
//  Created by ravi on 29/11/24.
//

import UIKit
import DropDown
import FSCalendar
import Combine
import GoogleMaps
import AppsFlyerLib
import SDWebImage

class LocationVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate, CircularSeekBarDelegate,GMSMapViewDelegate,UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var btnShowMoreAddOns: UIButton!
    @IBOutlet weak var btnReadMore_AboutSpace: UIButton!
    @IBOutlet weak var view_BtnReadAboutSpace: UIView!
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var imgHostStar: UIImageView!
    @IBOutlet weak var lbl_TimeForFreeCancel: UILabel!
    @IBOutlet weak var imgWishlist: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var viewImage3: UIView!
    @IBOutlet weak var viewImage2: UIView!
    @IBOutlet weak var viewImage1: UIView!
    @IBOutlet weak var lbl_bookingAmount: UILabel!
    @IBOutlet weak var lbl_mapAddress: UILabel!
    @IBOutlet weak var mapv1: GMSMapView!
    @IBOutlet weak var lbl_BookingHours: UILabel!
    @IBOutlet weak var lbl_reviewBelow: UILabel!
    @IBOutlet weak var lbl_sortType: UILabel!
    @IBOutlet weak var lbl_reviewRatings: UILabel!
    @IBOutlet weak var lbl_HostRules: UILabel!
    @IBOutlet weak var lbl_DescParking: UILabel!
    @IBOutlet weak var lbl_noofReview: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_hostBy: UILabel!
    @IBOutlet weak var lbl_HourDiscount: UILabel!
    @IBOutlet weak var lbl_OffDiscount: UILabel!
    @IBOutlet weak var lbl_PerHour: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var lbl_distance: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var StackV_Above: UIStackView!
    @IBOutlet weak var btnChooseDays: UIButton!
    @IBOutlet weak var btnChooseHours: UIButton!
    @IBOutlet weak var btnshowMore: UIButton!
    @IBOutlet weak var view_RulesParking: UIView!
    @IBOutlet weak var view_HostRules: UIView!
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var stack_Discount: UIStackView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblVH_Const: NSLayoutConstraint!
    @IBOutlet weak var btnSortPositiveRating: UIButton!
    @IBOutlet weak var scrollV: UIScrollView!
    @IBOutlet weak var collecV_Host: UICollectionView!
    @IBOutlet weak var view_msgV: UIView!
    @IBOutlet weak var btnMessageHost: UIButton!
    @IBOutlet weak var btnReviewBooking: UIButton!
    @IBOutlet weak var time1Lbl: UILabel!
    @IBOutlet weak var time2Lbl: UILabel!
    @IBOutlet weak var view_holdCalendarWatch: UIView!
    @IBOutlet weak var view_Parking: UIView!
    @IBOutlet weak var view_wifi: UIView!
    @IBOutlet weak var view_rooms: UIView!
    @IBOutlet weak var view_Tables: UIView!
    @IBOutlet weak var view_Chairs: UIView!
    @IBOutlet weak var view_Kitchen: UIView!
    @IBOutlet weak var view_HostDesc: UIView!
    @IBOutlet weak var view_ParkingDesc: UIView!
    @IBOutlet weak var viewHold_MessageHost: UIView!
    @IBOutlet weak var view_otherReason: UIView!
    @IBOutlet weak var view_availableDays: UIView!
    @IBOutlet weak var view_IhaveDoubt: UIView!
    @IBOutlet weak var btnMsgHost: UIButton!
    @IBOutlet weak var view_ZyvoShield: UIView!
    @IBOutlet weak var btnShowMsgHost: UIButton!
    @IBOutlet weak var btnReadmoreReview: UIButton!
    @IBOutlet weak var view_ShareMessage: UIView!
    @IBOutlet weak var view_AboutTheSpace: UIView!
    @IBOutlet weak var view_time1: UIView!
    @IBOutlet weak var view_time2: UIView!
    @IBOutlet weak var view_Hour: UIView!
    @IBOutlet weak var view_Price: UIView!
    @IBOutlet weak var view_Calendar: FSCalendar!
    @IBOutlet weak var view_CircularTime: CircularSeekBar!
    @IBOutlet weak var view_BackGroundChooseHours: UIView!
    @IBOutlet weak var btnStartBooking: UIButton!
    @IBOutlet weak var infoBtnO: UIButton!
    @IBOutlet weak var aboutSpaceLbl: UILabel!
    @IBOutlet weak var collVH: NSLayoutConstraint!
    @IBOutlet weak var selectTimeV: UIView!
    @IBOutlet weak var selectHourPriceV: UIView!
    @IBOutlet weak var bgCelenderV: UIView!
    
    @IBOutlet weak var view_ShowMoreAddOns: UIView!
    @IBOutlet weak var lbl_minBookingHours: UILabel!
    @IBOutlet weak var view_SeeMore: UIView!
    @IBOutlet weak var btnNextMonth: UIButton!
    @IBOutlet weak var btnPrevMoth: UIButton!
    var arrHost = ["Computer Screen","Bed Sheets","Phone charger","Ring Light"]
    private let spacing:CGFloat = 16.0
    var showDes = "no"
    let timeDropdown = DropDown()
    @IBOutlet weak var imgHConst: NSLayoutConstraint!
    @IBOutlet weak var collecV_IncludedServices: UICollectionView!
    var Times = ["Highest Review","Lowest Review","Recent Reviews"]
    let infoLabel = UILabel()
    var viewModel = PropertyDetailsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var getPropertyDetails : PropertyDetailsModel?
    private var viewModel1 = BookingDetailsViewModel()
    var getJoinChannelDetails : JoinChanelModel?
    var reviewsArr: [FilterModel]?
    var reviewsSubArr: [FilterModel]?
    var addOnsArr: [AddOn] = []
    var isReadMore: Bool = false
    var fulladdOnsArr: [AddOn] = []
    var IncludesServiceArr: [String] = []
    var arrSelectedArr :[Int] = []
    var addOnsNeddToSend: [[String: Any]] = []
    var ClearningFee : Double? = 0.0
    var DiscountPercentage : Double? = 0.0
    var taxPercentage : Double? = 0.0
    var zyvoServiceFee : Double? = 0.0
    var zyvoServicePercentage : Double? = 0.0
    var tax : Double? = 0.0
    var bookingAmount : Double? = 0.0
    var AddOnPrice : Double? = 0.0
    var backAction:(_ str : String ) -> () = { str in}
    var StartDatetime = ""
    var startTime = ""
    var endTime = ""
    var EndDatetime = ""
    var bookingDate = ""
    var bookingHours : Int? = 0
    var totalAmount = ""
    let addOns = [[String: Any]]()
    var perHourRate : Int? = 0
    var SelectedDate = ""
    var parkDesc = ""
    var HostingRulesDesc = ""
    var isParkingRulesOpen = "no"
    var isHostTingRulesOpen = "no"
    var awardStatus : Bool = false
    var fullDescription = "" // Store full description
    var shortDescription = "" // Store short version
    var isRewReadMore = "yes"
    var propertyDistanceInMiles = ""
    var count = 5
    var countMonth = 0
    let items = ["October 22, 2023   ", "From 01pm to 03pm", "2 Hours"]
    var imgArr = ["calenderblackicon","watchblackicon","watchblackicon"]
    let hoursArray = (2...24).map { "\($0) hour\($0 > 1 ? "s" : "")" }
   
    var Host_count = 4
    var profileIMGURL = ""
    var propertyIMGURL = ""
    var propertyID = ""
    var page = 1
    var totalPage : Int? = 0
    var reviewType = "highest_review"
    var channelName = ""
    var comingFrom = ""
    var hostID = 0
    var hostProfileImg = ""
    var guestProfileImg = ""
    var heartStatus : Int? = 0
    var imagesArr = [String]()
    var isExpanded = false
    let fullText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tblV.estimatedRowHeight = 100
        view_Calendar.appearance.todayColor = nil
        view_Calendar.appearance.titleTodayColor = view_Calendar.appearance.titleDefaultColor
        
        view_Calendar.select(Date())                  // ✅ Select today
        view_Calendar.setCurrentPage(Date(), animated: false)
        
        self.view_SeeMore.isHidden = true
        self.btnshowMore.isHidden = true
        
        bindVC()
        
        viewModel.apiForGetPropertyDetails(propertyId: self.propertyID)
        viewModel.apiForFilterData(propertyId: self.propertyID , filter: self.reviewType , page: self.page )
        
        self.lbl_sortType.text = "Sort by: Highest Review"
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.layer.frame.height / 2
        self.imgProfile.contentMode = .scaleAspectFill
        self.imgProfile.layer.borderWidth = 1
        self.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        
        // Register the WishlistCell nib file
        
        let nibs = UINib(nibName: "ServiceCell", bundle: nil)
        collecV_IncludedServices.register(nibs, forCellWithReuseIdentifier: "ServiceCell")
        
        collecV_IncludedServices.delegate = self
        collecV_IncludedServices.dataSource = self
        
        self.mapv1.delegate = self
        // Setup CircularSeekBar
        view_CircularTime.delegate = self
        view_CircularTime.layer.cornerRadius = view_CircularTime.frame.width/2
        
        view_Calendar.placeholderType = .none
        view_Calendar.delegate = self
        view_Calendar.dataSource = self
        view_Calendar.bringSubviewToFront(btnNextMonth)
        view_Calendar.bringSubviewToFront(btnPrevMoth)
        view_BtnReadAboutSpace.isHidden = true
        viewHold_MessageHost.isHidden = true
        selectHourPriceV.isHidden = false
        selectTimeV.isHidden = true
        view_IhaveDoubt.layer.cornerRadius = 10
        view_IhaveDoubt.layer.borderWidth = 1.5
        view_IhaveDoubt.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_availableDays.layer.cornerRadius = 10
        view_availableDays.layer.borderWidth = 1.5
        view_availableDays.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_otherReason.layer.cornerRadius = 10
        view_otherReason.layer.borderWidth = 1.5
        view_otherReason.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        btnShowMsgHost.layer.cornerRadius = 10
        btnShowMsgHost.layer.borderWidth = 1
        btnShowMsgHost.layer.borderColor = UIColor.black.cgColor
        
        view_ShareMessage.layer.cornerRadius = 20
        view_ShareMessage.layer.borderWidth = 1.5
        view_ShareMessage.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        StackV_Above.layer.cornerRadius = 20
        StackV_Above.layer.borderWidth = 1.5
        StackV_Above.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_HostDesc.isHidden = true
        view_HostDesc.layer.cornerRadius = 20
        view_HostDesc.layer.borderWidth = 1.5
        view_HostDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_ParkingDesc.isHidden = true
        view_ParkingDesc.layer.cornerRadius = 20
        view_ParkingDesc.layer.borderWidth = 1.5
        view_ParkingDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        stack_Discount.layer.cornerRadius = 10
        stack_Discount.layer.borderWidth = 1.0
        stack_Discount.layer.borderColor = UIColor.lightGray.cgColor
        
        btnMsgHost.layer.cornerRadius =  10
        
        view_BackGroundChooseHours.layer.cornerRadius = view_BackGroundChooseHours.layer.frame.height / 2
        
        btnChooseHours.layer.cornerRadius = btnChooseHours.layer.frame.height / 2
        btnChooseDays.layer.cornerRadius = btnChooseDays.layer.frame.height / 2
        
        tblV.register(UINib(nibName: "RatingCell", bundle: nil), forCellReuseIdentifier: "RatingCell")
        tblV.delegate = self
        tblV.dataSource = self
        
        self.tblV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        view_Calendar.isHidden = true
        view_time1.layer.cornerRadius = view_time1.layer.frame.height / 2
        view_time1.layer.borderWidth = 1.0
        view_time1.layer.borderColor = UIColor.lightGray.cgColor
        
        view_time2.layer.cornerRadius = view_time2.layer.frame.height / 2
        view_time2.layer.borderWidth = 1.0
        view_time2.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Hour.layer.cornerRadius = view_Hour.layer.frame.height / 2
        view_Hour.layer.borderWidth = 1.0
        view_Hour.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Price.layer.cornerRadius = view_Price.layer.frame.height / 2
        view_Price.layer.borderWidth = 1.0
        view_Price.layer.borderColor = UIColor.lightGray.cgColor
        
        view_holdCalendarWatch.layer.cornerRadius = 10
        view_holdCalendarWatch.layer.borderWidth = 2.0
        view_holdCalendarWatch.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1).cgColor
        
        btnshowMore.layer.cornerRadius = btnshowMore.layer.frame.height / 2
        btnshowMore.layer.borderWidth = 1.0
        btnshowMore.layer.borderColor = UIColor.lightGray.cgColor
        
        view_RulesParking.layer.cornerRadius = 10
        view_RulesParking.layer.borderWidth = 1.0
        view_RulesParking.layer.borderColor = UIColor.lightGray.cgColor
        
        view_HostRules.layer.cornerRadius = 10
        view_HostRules.layer.borderWidth = 1.0
        view_HostRules.layer.borderColor = UIColor.lightGray.cgColor
        
        
        let nib = UINib(nibName: "CellHost", bundle: nil)
        collecV_Host?.register(nib, forCellWithReuseIdentifier: "CellHost")
        collecV_Host.delegate = self
        collecV_Host.dataSource = self
        
        btnMessageHost.layer.cornerRadius = 10
        btnMessageHost.layer.borderWidth = 1
        btnMessageHost.layer.borderColor = UIColor.black.cgColor
        
        btnReviewBooking.layer.cornerRadius = 10
        btnReviewBooking.layer.borderWidth = 1
        btnReviewBooking.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1).cgColor
        
        infoLabel.text = "Your safety and peace of mind are our top priorities. ZYVO is  proud to provide comprehensive liability insurance coverage for all bookings"
        
        // Set custom font "Poppins" with size 15
        if let customFont = UIFont(name: "Poppins-Regular", size: 14){
            infoLabel.font = customFont
        } else {
            print("Custom font 'Poppins-Regular' not found. Ensure it's added to the project.")
        }
        
        infoLabel.textAlignment = .center
        infoLabel.backgroundColor = UIColor.white
        infoLabel.textColor = .black
        infoLabel.layer.cornerRadius = 8
        infoLabel.layer.borderWidth = 1
        infoLabel.numberOfLines = 4
        infoLabel.layer.borderColor = UIColor.lightGray.cgColor
        infoLabel.clipsToBounds = true
        
        infoLabel.frame = CGRect(x: infoBtnO.frame.midX - 190 , y: infoBtnO.frame.maxY - 110 , width: 280, height: 96)
        
        // Print current date when the view loads
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print("Current Date: \(dateFormatter.string(from: currentDate))")
        SelectedDate = "\(dateFormatter.string(from: currentDate))"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func updateUI() {
        let words = self.fullDescription.split(separator: " ")
        if words.count > 20 {
            self.shortDescription = words.prefix(20).joined(separator: " ") + "..."
            self.view_BtnReadAboutSpace.isHidden = false
            self.aboutSpaceLbl.text = self.shortDescription
            
        } else {
            
            self.aboutSpaceLbl.text = self.fullDescription
            self.view_BtnReadAboutSpace.isHidden = true
        }
    }
    
    private func updateCollectionViewHeight() {
        // Get the content size of the collection view
        collecV_IncludedServices.layoutIfNeeded()
        let contentHeight = collecV_IncludedServices.contentSize.height
        // Update the height constraint
        collectionViewHeightConstraint.constant = contentHeight
        
        collecV_Host.layoutIfNeeded()
        let contentHeight1 = collecV_Host.contentSize.height
        collVH.constant = contentHeight1
        // Update the layout of the view
        self.view.layoutIfNeeded()
    }
    
private func updateAddOnsCollectionViewHeight() {
    collecV_Host.layoutIfNeeded()
    let contentHeight1 = collecV_Host.contentSize.height
    collVH.constant = contentHeight1
    // Update the layout of the view
    self.view.layoutIfNeeded()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblV.layer.removeAllAnimations()
        tblVH_Const.constant = tblV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    // Delegate method to detect date selection
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let selectedDateString = dateFormatter.string(from: date)
        print("Selected Date: \(selectedDateString)")
        
        let today = Date()
        let calendarComponent = Calendar.current
        
        // Remove time components to compare only dates
        let selectedDate = calendarComponent.startOfDay(for: date)
        let currentDate = calendarComponent.startOfDay(for: today)
        
        if selectedDate < currentDate {
            // **Show Alert for Past Date**
            showAlert(for: "You cannot select a past date from the calendar.")
            calendar.deselect(date) //Deselect the past date
        } else {
            // **Allow Selection for Current and Future Dates**
            self.bookingDate = selectedDateString
            self.SelectedDate = selectedDateString
            self.time1Lbl.text = "Start Time"
            self.time2Lbl.text = "End Time"
            self.StartDatetime = ""
            self.EndDatetime = ""
            //self.view_Calendar.reloadData()
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return date < Date().startOfDay() ? UIColor.gray : UIColor.black
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if date < Date().startOfDay() {
            return UIColor.lightGray.withAlphaComponent(0.3) // Light gray background
        }
        return nil // No background for current/future dates
    }
    
    @IBAction func btnAddToWishlist_Tap(_ sender: UIButton) {
        
        
        if heartStatus == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddToWishListPopUpVC") as! AddToWishListPopUpVC
            vc.propertyID = "\(self.propertyID)"
            vc.backAction = { str in
                print(str,"Data Recieved")
                if str == "SaveItemInWishlist" {
                    self.viewModel.apiForGetPropertyDetails(propertyId: self.propertyID)
                }
                if str == "Ravi" {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateWishListVC") as! CreateWishListVC
                    vc.propertyID = "\(self.propertyID)"
                    vc.backAction = { str in
                        print(str,"Created")
                        self.viewModel.apiForGetPropertyDetails(propertyId: self.propertyID)
                        
                    }
                    self.present(vc, animated:  false)
                }
            }
            self.present(vc, animated:  false)
        } else {
            print("Remove From wishlist")
            
            self.viewModel.apiforRemoveFromWishlist(propertyID: "\(self.propertyID)")
        }
        
    }
    
    @IBAction func btnInfo_Tap(_ sender: UIButton) {
        
        if sender.isSelected == false{
            sender.isSelected = true
            view_msgV.addSubview(infoLabel)
            view_msgV.isHidden = false
        }else{
            sender.isSelected = false
            infoLabel.removeFromSuperview()
            view_msgV.isHidden = false
        }
        
    }
    
    @IBAction func btnFilter_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnIhaveDoubt_Tap(_ sender: UIButton) {
        view_IhaveDoubt.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        view_availableDays.backgroundColor = UIColor.white
        view_otherReason.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnShowImage_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImagePopUpVC") as! ImagePopUpVC
        vc.imagesArr = self.imagesArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnAvailableDays_Tap(_ sender: UIButton) {
        
        view_IhaveDoubt.backgroundColor = UIColor.clear
        view_availableDays.backgroundColor =  UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        view_otherReason.backgroundColor = UIColor.clear
        
    }
    
    @IBAction func showMoreDesBtn(_ sender: UIButton){
        if showDes == "no"{
            self.showDes = "yes"
            sender.setTitle("Read Less", for: .normal)
            self.aboutSpaceLbl.text = fullDescription
        }else{
            self.showDes = "no"
            sender.setTitle("Read More", for: .normal)
            self.aboutSpaceLbl.text = shortDescription
        }
    }
    
    @IBAction func btnOtherReason_Tap(_ sender: UIButton) {
        view_IhaveDoubt.backgroundColor = UIColor.clear
        view_availableDays.backgroundColor = UIColor.clear
        view_otherReason.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
    }
    
    @IBAction func btnshowMessageHost_Tap(_ sender: UIButton) {
        
        let senderID = UserDetail.shared.getUserId()
        
        viewModel1.apiForJoinChannel(senderId: senderID, receiverId: "\(self.hostID )", groupChannel: self.channelName, userType: "guest")
    }
    
    @IBAction func btnSendMessageHost_Tap(_ sender: UIButton) {
        viewHold_MessageHost.isHidden = true
    }
    
    @IBAction func btnChooseHours_Tap(_ sender: UIButton) {
        btnChooseHours.backgroundColor = UIColor.white
        btnChooseDays.backgroundColor = UIColor.clear
        view_CircularTime.isHidden = false
        bgCelenderV.isHidden = false
        view_Calendar.isHidden = true
        selectHourPriceV.isHidden = false
        selectTimeV.isHidden = true
    }
    
    func generateInviteLink(completion: @escaping (String) -> Void) {
        let baseURL = "https://zyvobusiness.onelink.me/bmcQ" // Replace with your OneLink template
        let userID = UserDetail.shared.getUserId() // Dynamic user ID
        
        // Prepare parameters
        let parameters: [String: String] = [
            "af_user_id": userID,
            "propertyID": self.propertyID,
            "propertyName": self.lbl_title.text ?? "",
            "imageURL": self.propertyIMGURL // renamed to imageURL (standard naming)
        ]
        
        // Add parameters to the URL
        var components = URLComponents(string: baseURL)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        // Generate full link
        if let fullURL = components?.url?.absoluteString {
            completion(fullURL)
        } else {
            print("❌ Failed to create invite link.")
        }
    }
    
    
    func generateDeepLink(propertyId: String, imageUrl: String?, viewController: UIViewController) {
        let oneLinkSubdomain = "zyvobusiness"
        let oneLinkId = "scFp"
        let campaignName = "property_share"
        
        let deepLink = "zyvoo://property?propertyId=\(propertyId)"
        let webFallbackLink = "https://zyvo.tgastaging.com/property/\(propertyId)"
        
        // ✅ Return the configured link generator from the closure
        AppsFlyerShareInviteHelper.generateInviteUrl(linkGenerator: { generator in
            generator.setBaseDeeplink("https://zyvobusiness.onelink.me/bmcQ")
            generator.setCampaign(campaignName)
            generator.addParameterValue(deepLink, forKey: "af_dp")
            generator.addParameterValue(webFallbackLink, forKey: "af_web_dp")
            return generator // 🔥 This line was missing!
        }) { url in
            guard let url = url else {
                print("Error: URL is nil.")
                return
            }
            
            let message = "Check out this property: \(url.absoluteString)"
            
            if let imageUrl = imageUrl, let imageURL = URL(string: imageUrl) {
                self.shareLinkWithImage(message: message, imageURL: imageURL, from: viewController)
            } else {
                self.shareTextOnly(message: message, from: viewController)
            }
        }
    }
    
    func shareTextOnly(message: String, from viewController: UIViewController) {
        let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        viewController.present(activityVC, animated: true)
    }
    
    func shareLinkWithImage(message: String, imageURL: URL, from viewController: UIViewController) {
        SDWebImageDownloader.shared.downloadImage(with: imageURL) { image, _, error, _ in
            guard let image = image, error == nil else {
                print("Image download failed: \(error?.localizedDescription ?? "Unknown error")")
                self.shareTextOnly(message: message, from: viewController)
                return
            }
            
            let tempDir = FileManager.default.temporaryDirectory
            let imageFile = tempDir.appendingPathComponent("property_share.jpg")
            
            if let data = image.jpegData(compressionQuality: 1.0) {
                try? data.write(to: imageFile)
                let activityVC = UIActivityViewController(activityItems: [message, imageFile], applicationActivities: nil)
                viewController.present(activityVC, animated: true)
            } else {
                self.shareTextOnly(message: message, from: viewController)
            }
        }
    }
    
    @IBAction func shareBtn(_ sender: UIButton){
        
        print(self.propertyID)
        print(self.propertyIMGURL)
        print("yahi hai data")
        
        generateInviteLink { inviteLink in
            var itemsToShare: [Any] = [inviteLink]
            let imageURLString = self.propertyIMGURL
            
            if let imageURL = URL(string: imageURLString) {
                // Load image asynchronously
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        itemsToShare.append(image)
                    } else if let localImage = UIImage(named: imageURLString) {
                        itemsToShare.append(localImage)
                    }
                    
                    // Present UI on main thread
                    DispatchQueue.main.async {
                        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
                        activityVC.popoverPresentationController?.sourceView = self.view
                        self.present(activityVC, animated: true)
                    }
                }.resume()
            } else {
                // Fallback if URL is invalid or image is local
                if let localImage = UIImage(named: imageURLString) {
                    itemsToShare.append(localImage)
                }
                DispatchQueue.main.async {
                    let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
                    activityVC.popoverPresentationController?.sourceView = self.view
                    self.present(activityVC, animated: true) }
            }
        }
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.backAction("Ravi")
        self.navigationController?.popViewController(animated: true)
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
    @IBAction func btnStartBooking_Tap(_ sender: UIButton) {
        
        if comingFrom == "WithoutLogin" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            if UserDetail.shared.getUserId() == ""{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated: false)
            }else{
                
                if sender.currentTitle == "Proceed to Checkout" {
                    
                    if bookingHours == 0 {
                        self.showToast("Please select Booking hours")
                    }  else if SelectedDate == "" {
                        self.showToast("Please select Booking date")
                    }
                    else if StartDatetime == "" {
                        self.showToast("Please select Booking Start time")
                    }
                    else if EndDatetime == "" {
                        self.showToast("Please select Booking End time")
                    }else  {
                        
                        var startdatetime = ""
                        var enddatetime = ""
                        
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
                        
                        let outputFormatter = DateFormatter()
                        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        if let date = inputFormatter.date(from: "\(self.StartDatetime)") {
                            let formattedString = outputFormatter.string(from: date)
                            print(formattedString) // Output: "2025-06-15 10:00:00"
                            startdatetime = formattedString
                        }
                        
                        if let dates = inputFormatter.date(from: "\(self.EndDatetime)") {
                            let formattedString = outputFormatter.string(from: dates)
                            print(formattedString) // Output: "2025-06-15 10:00:00"
                            enddatetime = formattedString
                        }
                        
                        viewModel.apiforCheckAvailibity(propertyID: self.propertyID, start_time: startdatetime, end_time: enddatetime)
                        
                    }
                }
                btnStartBooking.setTitle("Proceed to Checkout", for: .normal)
                btnChooseDays.backgroundColor = UIColor.white
                btnChooseHours.backgroundColor = UIColor.clear
                view_CircularTime.isHidden = true
                bgCelenderV.isHidden = true
                view_Calendar.isHidden = false
                selectHourPriceV.isHidden = true
                selectTimeV.isHidden = false
            }
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
    
    @IBAction func btnChooseDays_Tap(_ sender: UIButton) {
        btnChooseDays.backgroundColor = UIColor.white
        btnChooseHours.backgroundColor = UIColor.clear
        view_CircularTime.isHidden = true
        bgCelenderV.isHidden = true
        view_Calendar.isHidden = false
        selectHourPriceV.isHidden = true
        selectTimeV.isHidden = false
    }
    @IBAction func btnReviewBooking_Tap(_ sender: UIButton) {
        
        btnMessageHost.layer.borderColor = UIColor.black.cgColor
        btnMessageHost.backgroundColor = UIColor.clear
        btnMessageHost.setTitleColor(.black, for: .normal)
        
        btnReviewBooking.backgroundColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1)
        btnReviewBooking.setTitleColor(.white, for: .normal)
        
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
            // "Highest Review","Lowest Review","Recent Reviews"]
            var str = ""
            if "\(item)" ==   "Highest Review"{
                str = "highest_review"
                self?.reviewType = str
                self?.lbl_sortType.text = "Sort by: Highest Review"
                
            } else if "\(item)" ==   "Lowest Review" {
                str = "lowest_review"
                self?.reviewType = str
                self?.lbl_sortType.text = "Sort by: Lowest Review"
            } else if "\(item)" ==   "Recent Reviews" {
                str = "recent_review"
                self?.reviewType = str
                self?.lbl_sortType.text = "Sort by: Recent Reviews"
            }
            self?.isRewReadMore = "no"
            self?.page = 1
            self?.viewModel.apiForFilterData(propertyId: self?.propertyID ?? "0", filter: self?.reviewType ?? "highest_review", page: nil)
            
        }
        timeDropdown.show()
    }
    
    @IBAction func btnHourDrop_Tap(_ sender: UIButton) {
        
        timeDropdown.anchorView = sender // You can set it to a UIButton or any UIView
        timeDropdown.dataSource = hoursArray
        timeDropdown.direction = .bottom
        
        timeDropdown.bottomOffset = CGPoint(x: 3, y:(timeDropdown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        timeDropdown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            
            print(item,"Hours from dropDown")
            
            let text = "\(item)"
            let numberOnly = text.filter { $0.isNumber }
            print(numberOnly)
            
            self?.bookingHours = Int(numberOnly)
            
            self?.view_CircularTime.setHour(self?.bookingHours ?? 0)
            
            if Int(numberOnly) == 1 {
                self?.lbl_BookingHours.text = "\(self?.bookingHours ?? 0) hour"
            } else {
                self?.lbl_BookingHours.text = "\(self?.bookingHours ?? 0) hours"
            }
            
            self?.lbl_bookingAmount.text = "$ \((self?.bookingHours ?? 0) * (self?.perHourRate ?? 0))"
            
            self?.bookingAmount = Double(((self?.bookingHours ?? 0) * (self?.perHourRate ?? 0)))
            
            print(self?.bookingHours ?? 0,"self?.bookingHours from Dropdown")
            
            self?.time1Lbl.text = "Start Time"
            self?.time2Lbl.text = "End Time"
            self?.StartDatetime = ""
            self?.EndDatetime = ""
            
        }
        timeDropdown.show()
    }
    
    @IBAction func btnMessageHost_Tap(_ sender: UIButton) {
        
        btnReviewBooking.layer.borderColor = UIColor.black.cgColor
        btnReviewBooking.backgroundColor = UIColor.clear
        btnReviewBooking.setTitleColor(.black, for: .normal)
        
        btnMessageHost.backgroundColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1)
        btnMessageHost.setTitleColor(.white, for: .normal)
        
    }
    @IBAction func btnNextMonth_Tap(_ sender: UIButton) {
        print("Next")
        let _calendar = Calendar.current
        var dateComponents = DateComponents()
        countMonth += 1
        dateComponents.month = countMonth // For next button
        //        dateComponents.month = -1 // For prev button
        //        _calendar.date(byAdding: dateComponents, to: Date())
        let currentPage = _calendar.date(byAdding: dateComponents, to: Date())!
        self.view_Calendar.setCurrentPage(currentPage, animated: true)
        
    }
    @IBAction func btnPreviousMonth_Tap(_ sender: UIButton) {
        print("Back")
        let _calendar = Calendar.current
        var dateComponents = DateComponents()
        countMonth -= 1
        dateComponents.month = countMonth // For nefxt button
        //dateComponents.month = -1 // For prev button
        //_calendar.date(byAdding: dateComponents, to: Date())
        let currentPage = _calendar.date(byAdding: dateComponents, to: Date())!
        self.view_Calendar.setCurrentPage(currentPage, animated: true)
        
    }
    
    @available(iOS 13.4, *)
    @IBAction func startTimeBtn(_ sender: UIButton){
        // Create the alert controller
        let alertController = UIAlertController(title: "Select Time", message: nil, preferredStyle: .actionSheet)
        
        // Create the UIDatePicker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Set 24-hour format
        // datePicker.locale = Locale(identifier: "en_GB") // Ensures 24-hour format
        datePicker.locale = Locale(identifier: "en_US") // Ensures 12-hour format
        
        // Add the UIDatePicker to the alert controller
        alertController.view.addSubview(datePicker)
        
        // Add constraints to position the date picker
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 50),
            datePicker.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // Add an OK action
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let selectedTime = datePicker.date
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            //                  formatter.dateFormat = "HH:mm:ss"
            formatter.dateFormat = "hh:mm a" // 12-hour format with AM/PM
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            print("Selected Time: \(formatter.string(from: selectedTime))")
            self.time1Lbl.text = "\(formatter.string(from: selectedTime))"
            
            self.StartDatetime = self.SelectedDate + " \(formatter.string(from: selectedTime))"
            self.startTime = " \(formatter.string(from: selectedTime))"
            
            let startTimeString = formatter.string(from: selectedTime) // Convert Date to String
            
            if let endTime = self.calculateEndTime(startTime: startTimeString, hoursToAdd: self.bookingHours ?? 0) {
                print("End Time: \(endTime)") // Example: "05:53:16 PM"
                self.endTime =  "\(endTime)"
                self.time2Lbl.text = endTime
                self.EndDatetime = "\(self.SelectedDate) \(endTime)"
            } else {
                print("Error calculating end time")
            }
        }))
        
        // Add a Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Adjust the height of the alert to fit the date picker
        let height = NSLayoutConstraint(item: alertController.view!,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: 300)
        alertController.view.addConstraint(height)
        
        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    func calculateEndTime(startTime: String, hoursToAdd: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" // 12-hour format with AM/PM
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        // Convert the input string to a Date object
        if let startDate = dateFormatter.date(from: startTime) {
            let calendar = Calendar.current
            if let endDate = calendar.date(byAdding: .hour, value: hoursToAdd, to: startDate) {
                return dateFormatter.string(from: endDate) // Convert back to string format
            }
        }
        return nil // Return nil if conversion fails
    }
    
    
    @available(iOS 13.4, *)
    @IBAction func endTimeBtn(_ sender: UIButton){
        
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
    
    @IBAction func btnInfoDiscount_Tap(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Host", bundle: nil)
        let popoverContent = storyboard.instantiateViewController(withIdentifier: "InfoPopVC") as! InfoPopVC
        popoverContent.msg = "Before you can book or host  on the platform the name on Id must match verification documents."
        popoverContent.modalPresentationStyle = .popover
        if let popover = popoverContent.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds // Attach to the button bounds
            popover.permittedArrowDirections = .down // Force the popover to show below the button
            popover.delegate = self
            popoverContent.preferredContentSize = CGSize(width: 230, height: 80)
        }
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Ensures the popover does not change to fullscreen on compact devices.
    }
    @IBAction func btnReadMore_Tap(_ sender: UIButton) {
        
        self.page = page + 1
        
        if self.isRewReadMore == "no" {
            self.isRewReadMore = "yes"
        }
        self.viewModel.apiForFilterData(propertyId: self.propertyID , filter: self.reviewType, page: self.page )
        
    }
    
    // MARK: - CircularSeekBarDelegate
    func circularSeekBarDidStartDragging() {
        scrollV.isScrollEnabled = false
        
    }
    
    func circularSeekBarDidEndDragging() {
        scrollV.isScrollEnabled = true
    }
    
    func didUpdateCenterLabel(Hours :String) {
        print(Hours,"")
        
        let hoursInt = Int(Hours )
        print(hoursInt ?? 0,"hoursInt")
        self.bookingHours = hoursInt
        self.lbl_BookingHours.text = "\(Hours) hour"
        
        self.lbl_bookingAmount.text = "$ \((hoursInt ?? 0) * (self.perHourRate ?? 0))"
        
        self.bookingAmount = Double(((hoursInt ?? 0) * (self.perHourRate ?? 0)))
        
        self.time1Lbl.text = "Start Time"
        self.time2Lbl.text = "End Time"
        self.StartDatetime = ""
        self.EndDatetime = ""
        
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
        return (totalPrice, discountAmount, discountedPrice, roundedTaxAmount, finalPrice)
    }
    func calculateFinalPriceWithoutDiscount(totalPrice: Double, taxPercent: Double) -> (taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Tax Amount
        let taxAmount = totalPrice * (taxPercent / 100)
        
        let roundedTaxAmount = taxAmount.rounded(toPlaces: 2)
        print(roundedTaxAmount) // Output: 1.28
        print(roundedTaxAmount) // Output: 1.28
        print(roundedTaxAmount) // Output: 1.28d
        
        // Step 2: Final Price after Tax
        let finalPrice = totalPrice + taxAmount
        
        return (roundedTaxAmount, finalPrice)
    }
}

extension LocationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collecV_Host {
            return addOnsArr.count
        }else  if collectionView == collecV_IncludedServices {
            return IncludesServiceArr.count
        } else {
            return items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collecV_Host {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellHost", for: indexPath) as! CellHost
            let data = addOnsArr[indexPath.row]
            cell.lbl_title.text = data.name//arrHost[indexPath.row]
            
            let hour = data.price ?? ""
            let price = hour.formattedPrice()
           print(price,"YAHI HAI PRICE")
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
        } else  if collectionView == collecV_IncludedServices {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
            cell.lbl_serviceName.text = IncludesServiceArr[indexPath.row]
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BankingDetailsCell", for: indexPath) as! BankingDetailsCell
            cell.lbl_title.text = items[indexPath.item]
            cell.img.image = UIImage(named: imgArr[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collecV_Host{
            var data = addOnsArr[indexPath.item]
            
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
        self.AddOnPrice = Double(total)
        print("Total Price: $\(total)")
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = 70
        var cellWidth: CGFloat = 90  // Default width
        if collectionView == collecV_Host{
            let spacing: CGFloat = 10 // Adjust spacing as needed
            let numberOfColumns: CGFloat = 1
            let totalSpacing = (numberOfColumns - 1) * spacing
            
            let itemWidth = (collecV_Host.bounds.width - totalSpacing) / numberOfColumns
            let itemHeight: CGFloat = 70 // Fixed height as per your code
            print(itemWidth,itemHeight,"itemWidth,itemHeight")
            return CGSize(width: itemWidth, height: itemHeight)
        } else if collectionView == collecV_IncludedServices {
            
            let padding: CGFloat = 10 // Spacing between cells
            let itemsPerRow: CGFloat = 3.1
            let totalPadding = (itemsPerRow - 1) * padding
            let availableWidth = collectionView.frame.width - totalPadding
            let cellWidth = availableWidth / itemsPerRow
            
            return CGSize(width: cellWidth, height: 80)
            
        }
        else{
            let spacing: CGFloat = 10 // Adjust spacing as needed
            let numberOfColumns: CGFloat = 1
            let totalSpacing = (numberOfColumns - 1) * spacing
            
            let itemWidth = (collecV_Host.bounds.width - totalSpacing) / numberOfColumns
            let itemHeight: CGFloat = 70 // Fixed height as per your code
            print(itemWidth,itemHeight,"itemWidth,itemHeight")
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between rows
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between columns
    }
    
    func getSizeForCollectionView(dataArray: [String], indexPath: IndexPath, defaultWidth: CGFloat, cellHeight: CGFloat) -> CGSize {
        guard indexPath.item < dataArray.count else {
            return CGSize(width: defaultWidth, height: cellHeight)
        }
        
        let text = dataArray[indexPath.item]
        let cellWidth = calculateWidth(for: text) ?? defaultWidth
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
}

extension LocationVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let data = reviewsArr?[indexPath.row]
        if data?.reviewMessage == nil  {
            return 70 // Fixed height when description is missing
        }
        return UITableView.automaticDimension
        // return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = reviewsArr?[indexPath.row]
        let cell = tblV.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
        
        if let doubleValue = Double(data?.reviewRating ?? "0") {
            let intValue = Int(doubleValue)
            cell.viewRating.rating = Double(intValue)
        }
        cell.lbl_name.text = data?.reviewerName ?? ""
        cell.lbl_date.text = data?.reviewDate ?? ""
        cell.lbl_desc.text = data?.reviewMessage ?? ""
        let image = data?.profileImage ?? ""
        let imgURL = AppURL.imageURL + image
        cell.img.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
        DispatchQueue.main.async {
            self.tblVH_Const.constant = self.tblV.contentSize.height
            self.tblV.layoutIfNeeded()
        }
        return cell
    }
}
extension LocationVC {
    func bindVC() {
        viewModel.$getPropertyDetailsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.getPropertyDetails = response.data
                    print(self.getPropertyDetails ?? [],"self.getPropertyDetails")
                    
                    self.addOnsArr.removeAll()
                    
                    let addonsARRDATA = self.getPropertyDetails?.addOnsP ?? []
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
                    
                    self.awardStatus = self.getPropertyDetails?.isStarHost ?? false
                    
                    if self.awardStatus == false {
                        self.imgHostStar.isHidden = true
                    } else {
                        self.imgHostStar.isHidden = false
                    }
                    
                    let cancellationTime = self.getPropertyDetails?.cancellationTime ?? 0
                    
                    print(self.formatCancellationTime(hours: cancellationTime))
                    
                    self.lbl_TimeForFreeCancel.text = "Cancel for free within \(self.formatCancellationTime(hours: cancellationTime))"
                    
                    let AddONS = self.getPropertyDetails?.addOns ?? []
                    
                    self.hostID =  self.getPropertyDetails?.hostID ?? 0
                    
                    let guestID = Int(UserDetail.shared.getUserId())
                    
                    let id1 = min(guestID ?? 0 , self.hostID)
                    let id2 = max(guestID ?? 0, self.hostID)
                    
                    self.channelName = "ZYVOOPROJ_\(id1)_\(id2)_\(self.propertyID)"
                    print(self.channelName,"self.channelName")
                    print(id1,id2,self.propertyID,"ASDFASDF")
                    
                    self.IncludesServiceArr = self.getPropertyDetails?.amenities ?? []
                    
                    self.collecV_IncludedServices.reloadData()
                    
                    let img = self.getPropertyDetails?.images ?? []
                    
                    // if img.count > 2  {
                    
                    self.imagesArr = img
                    //  }
                    
                    print(img,"IMAGE RAVI")
                    
                    let bulkDiscountRateString = (self.getPropertyDetails?.bulkDiscountRate ?? "0")
                    
                    // Convert to Double first, then to Int
                    if let discountRateDouble = Double(bulkDiscountRateString) {
                        let discountRateInt = Int(discountRateDouble)
                        print("Discount Rate: \(discountRateInt)")
                        self.lbl_OffDiscount.text = "\(discountRateInt)% Off"
                    } else {
                        print("Invalid number format")
                    }
                    
                    if img.count == 1 {
                        self.imgHConst.constant = 300
                        self.view_SeeMore.isHidden = true
                        let image = img[0]
                        let imgURL = AppURL.imageURL + image
                        self.img1.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
                        self.propertyIMGURL = imgURL
                        self.viewImage1.isHidden = false
                        self.viewImage2.isHidden = true
                        self.viewImage3.isHidden = true
                    }  else if img.count == 2 {
                        self.view_SeeMore.isHidden = true
                        self.viewImage1.isHidden = false
                        self.viewImage2.isHidden = false
                        self.viewImage3.isHidden = true
                        let image = img[0]
                        let imgURL = AppURL.imageURL + image
                        self.img1.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
                        self.propertyIMGURL = imgURL
                        let image2 = img[1]
                        let imgURL2 = AppURL.imageURL + image2
                        self.img2.loadImage(from:imgURL2,placeholder: UIImage(named: "img1"))
                        self.imgHConst.constant = 250
                        
                    } else if img.count > 2 {
                        self.imgHConst.constant = 290
                        self.view_SeeMore.isHidden = false
                        
                        self.viewImage1.isHidden = true
                        self.viewImage3.isHidden = false
                        self.viewImage2.isHidden = false
                        let image = img[0]
                        let imgURL = AppURL.imageURL + image
                        print(imgURL,"imgURL")
                        self.img2.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
                        self.propertyIMGURL = imgURL
                        let image2 = img[1]
                        let imgURL2 = AppURL.imageURL + image2
                        self.img3.loadImage(from:imgURL2,placeholder: UIImage(named: "img1"))
                        print(imgURL2,"imgURL2")
                        let image3 = img[2]
                        let imgURL4 = AppURL.imageURL + image3
                        print(imgURL4,"imgURL4")
                        self.img4.loadImage(from:imgURL4,placeholder: UIImage(named: "img1")) }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.collecV_IncludedServices.reloadData()
                        self.collecV_Host.reloadData()
                        self.updateCollectionViewHeight()
                    }
                    var image = self.getPropertyDetails?.hostProfileImage ?? ""
                    let imgURL = AppURL.imageURL + image
                    self.profileIMGURL = imgURL
                    self.imgProfile.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
                    
                    self.lbl_title.text = self.getPropertyDetails?.propertyTitle ?? ""
                    
                    self.lbl_distance.text = "\(self.getPropertyDetails?.propertySize ?? 0)" + " sqft"
                    var rating = self.getPropertyDetails?.reviewsTotalRating ?? ""
                    if rating == "0" {
                        self.lbl_rating.text = "0"
                        self.lbl_reviewRatings.text = "0"
                    } else {
                        self.lbl_rating.text = rating.formattedToDecimal()
                        self.lbl_reviewRatings.text = rating.formattedToDecimal()
                    }
                    self.lbl_noofReview.text = "(\(self.getPropertyDetails?.reviewsTotalCount ?? "") reviews)"
                    
                    self.lbl_reviewBelow.text = "Reviews(\(self.getPropertyDetails?.reviewsTotalCount ?? "0"))"
                    self.lbl_reviewBelow.text = "Reviews(\(self.getPropertyDetails?.reviewsTotalCount ?? "0"))"
                    
                    if let hourlyRateString = self.getPropertyDetails?.hourlyRate,
                       let hourlyRateInt = (Double(hourlyRateString)) {
                        print("Hourly Rate: \(hourlyRateInt)")
                        self.perHourRate = Int(hourlyRateInt)
                        
                        self.lbl_PerHour.text = "$\(self.perHourRate ?? 0)/hr"
                        
                    } else {
                        print("Invalid hourly rate")
                    }
                    
                    print(self.perHourRate ?? 0,"perHourRate")
                    
                    self.lbl_HourDiscount.text = "\(self.getPropertyDetails?.bulkDiscountHour ?? 0)"  + "+ hour discount"
                    
                    // Set descriptions
                    self.fullDescription =  self.getPropertyDetails?.propertyDescription ?? ""
                    self.shortDescription =  String(self.fullDescription.prefix(100)) + "..." // Show first 100 chars
                    
                    self.updateUI()
                    
                    self.lbl_hostBy.text = self.getPropertyDetails?.hostedBy ?? ""
                    // self.lbl_sortType.text = self.getPropertyDetails.s
                    self.lbl_HostRules.text = self.getPropertyDetails?.hostRules ?? ""
                    self.lbl_DescParking.text = self.getPropertyDetails?.parkingRules ?? ""
                    self.HostingRulesDesc = self.getPropertyDetails?.hostRules ?? ""
                    self.parkDesc = self.getPropertyDetails?.parkingRules ?? ""
                    
                    let minBookingHoursString = "\(self.getPropertyDetails?.minBookingHours ?? "0")"
                    
                    // Convert to Double
                    if let hoursDouble = Double(minBookingHoursString) {
                        let hours = Int(hoursDouble)
                        let minutes = Int((hoursDouble - Double(hours)) * 60)
                        
                        // Format string conditionally
                        var formattedTime = "\(hours) hr"
                        if minutes > 0 {
                            formattedTime += " \(minutes) min"
                        }
                        print(formattedTime)
                        self.lbl_Time.text = formattedTime
                        
                        self.lbl_minBookingHours.text = "\(hours) hr minimum"
                        self.bookingHours = hours
                        
                    } else {
                        print("Invalid number format")
                    }
                    
                    print(self.bookingHours ?? 0)
                    print((self.perHourRate ?? 0))
                    
                    self.view_CircularTime.setHour(self.bookingHours ?? 0)
                    
                    self.lbl_bookingAmount.text = "$ \((self.bookingHours ?? 0) * (self.perHourRate ?? 0))"
                    
                    self.bookingAmount = (Double((self.bookingHours ?? 0)) * Double((self.perHourRate ?? 0)))
                    
                    self.lbl_BookingHours.text = "\(self.bookingHours ?? 0) hr"
                    self.heartStatus = self.getPropertyDetails?.isInWishlist ?? 0
                    if self.heartStatus == 0 {
                        self.imgWishlist.image = UIImage(named: "hearticons")
                    } else {
                        self.imgWishlist.image = UIImage(named: "day")
                    }
                    self.lbl_mapAddress.text = self.getPropertyDetails?.address
                    let latitude = Double(self.getPropertyDetails?.latitude ?? "")
                    let longitude = Double(self.getPropertyDetails?.longitude ?? "")
                    
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
                    let centeredCamera = GMSCameraPosition.camera(withLatitude: latitude ?? 0.0, longitude: longitude ?? 0.0, zoom: self.mapv1.camera.zoom)
                    self.mapv1.animate(to: centeredCamera)
                    marker.map = self.mapv1
                })
            }.store(in: &cancellables)
        
        viewModel.$getFilterDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.reviewsSubArr?.removeAll()
                    self.reviewsSubArr = response.data
                    if self.isRewReadMore == "yes" {
                        self.reviewsArr = (self.reviewsArr ?? []) + (self.reviewsSubArr ?? [])
                    } else {
                        self.reviewsArr = self.reviewsSubArr ?? []
                    }
                    let pagination = response.pagination
                    self.totalPage = pagination?.totalPages ?? 0
                    print(pagination ?? 0,"pagination")
                    print(self.totalPage ?? 0,"self.totalPage")
                    if self.page == (self.totalPage  ?? 0) {
                        self.btnshowMore.isHidden = true
                    } else if self.reviewsArr?.count == 0 && self.totalPage == 0 {
                        self.btnshowMore.isHidden = true  }
                    else {
                        self.btnshowMore.isHidden = false
                    }
                    self.tblV.reloadData()
                })
            }.store(in: &cancellables)
        
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
        
        viewModel.$getWishlistRemoveResult
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] result in
                
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.showToast(response.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.viewModel.apiForGetPropertyDetails(propertyId: self.propertyID)
                    }
                })
            }.store(in: &cancellables)
        
        
        viewModel.$bookPropertyAvailibityResult
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] result in
                
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    //self.showToast("\(response.code ?? 0)")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutVC") as! CheckoutVC
                        vc.propertyDistanceInMiles = self.propertyDistanceInMiles
                        self.ClearningFee = Double(self.getPropertyDetails?.cleaningFee ?? "")
                        print(self.ClearningFee,self.zyvoServiceFee,"self.ClearningFee,self.zyvoServiceFee")
                        var minBookhours : Int? = 0
                        var taxAmount : Double? = 0.0
                        var DiscountAmount : Double? = 0.0
                        let str = "\(self.getPropertyDetails?.bulkDiscountHour ?? 0)"
                        if let doubleValue = Double(str) {
                            let intValue = Int(doubleValue)
                            print(intValue) // Output: 3
                            minBookhours = intValue
                        }
                        
                        // Example Usage
                        let totalPrice = Double(self.bookingAmount ?? 0.0)
                        
                        let zyvoFeePercentage = Double(self.getPropertyDetails?.serviceFee ?? "0.0") ?? 0.0
                        self.zyvoServicePercentage = zyvoFeePercentage
                        self.zyvoServiceFee = (totalPrice * zyvoFeePercentage) / 100.0
                        let discountPercent = Double(self.getPropertyDetails?.bulkDiscountRate ?? "") //10.0   // 10% discount
                        self.DiscountPercentage = discountPercent
                        let taxPercent = Double(self.getPropertyDetails?.tax ?? "")
                        self.taxPercentage = taxPercent// 5% tax
                        print(self.bookingHours ?? 0)
                        print(minBookhours ?? 0)
                        if (self.bookingHours ?? 0) > (minBookhours ?? 0)   {
                            
                            let result = self.calculateFinalPriceWithDiscount(totalPrice: totalPrice ?? 0.0, discountPercent: discountPercent ?? 0.0, taxPercent: taxPercent ?? 0.0)
                            print("================================WithDiscount====================================")
                            // Printing the Result
                            print("Total Price: \(result.totalPrice)")
                            print("Discount Amount (\(String(describing: discountPercent))%) : \(result.discountAmount)")
                            print("Discounted Price: \(result.discountedPrice)")
                            print("Tax Amount (\(String(describing: taxPercent ?? 0.0))%): \(result.taxAmount )")
                            taxAmount = result.taxAmount
                            DiscountAmount = result.discountAmount
                            print("Final Price: \(result.finalPrice)")
                            
                        } else {
                            let result = self.calculateFinalPriceWithoutDiscount(totalPrice: totalPrice, taxPercent: taxPercent ?? 0.0)
                            
                            print("================================WithoutDiscount====================================")
                            print("Tax Amount: \(result.taxAmount)")
                            taxAmount = result.taxAmount// 45.0
                            print("Final Price After Tax: \(result.finalPrice)") // 945.0
                        }
                        vc.hostID = self.getPropertyDetails?.hostID ?? 0
                        
                        vc.hostName = self.getPropertyDetails?.hostedBy ?? ""
                        vc.propertyDistanceInMiles = self.propertyDistanceInMiles
                        vc.propertyName = self.lbl_title.text ?? ""
                        vc.propertyRating = self.lbl_rating.text ?? ""
                        vc.propertyNumberofReview =  self.lbl_noofReview.text ?? ""
                        vc.propertyIMGURL =  self.propertyIMGURL
                        vc.perHourRate = self.perHourRate
                        vc.booking_start = self.StartDatetime
                        vc.booking_end = self.EndDatetime
                        vc.booking_hours = self.bookingHours ?? 0
                        vc.startTime = self.startTime
                        vc.endTime = self.endTime
                        vc.booking_amount = self.bookingAmount
                        vc.property_id = self.propertyID
                        vc.booking_date = self.SelectedDate
                        vc.taxAmount =  taxAmount
                        vc.awardStatus = self.awardStatus
                        vc.minBookhours = minBookhours
                        vc.DiscountAmount = DiscountAmount
                        vc.ClearningFee = (self.ClearningFee ?? 0.0)
                        vc.zyvoServiceFee = self.zyvoServiceFee ?? 0.0
                        vc.AddonOnsPrice = self.AddOnPrice ?? 0.0
                        vc.addOnsArr = self.fulladdOnsArr
                        vc.fulladdOnsArr = self.fulladdOnsArr
                        vc.arrSelectedArr = self.arrSelectedArr
                        vc.profileIMGURL = self.profileIMGURL
                        vc.parkDesc = self.parkDesc
                        vc.HostingRulesDesc = self.HostingRulesDesc
                        vc.DiscountPercentage = self.DiscountPercentage
                        vc.taxPercentage = self.taxPercentage
                        vc.zyvoServicePercentage = self.zyvoServicePercentage
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                })
            }.store(in: &cancellables)
        
    }
    
    func formatCancellationTime(hours: Int) -> String {
        if hours == 24 {
            return "24 hours"
        } else {
            let days = hours / 24
            return "\(days) days"
        }
    }
}

extension Date {
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
}

extension String {
    func formattedToDecimal(_ places: Int = 1) -> String {
        guard let number = Double(self) else { return "" }
        return String(format: "%.\(places)f", number)
    }
}
