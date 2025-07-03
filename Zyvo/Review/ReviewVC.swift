//
//  ReviewVC.swift
//  Zyvo
//
//  Created by ravi on 18/11/24.
//

import UIKit
import DropDown
import Combine
import GoogleMaps

class ReviewVC: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var lbl_RatingBelow: UILabel!
    
    @IBOutlet weak var view_Tax: UIView!
    @IBOutlet weak var view_ZyvoServiceFee: UIView!
    @IBOutlet weak var view_CleaningFee: UIView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var viewPropertyImg23: UIView!
    @IBOutlet weak var viewImgProperty1: UIView!
    @IBOutlet weak var viewImgProperty2: UIView!
    @IBOutlet weak var viewImgProperty3: UIView!
    @IBOutlet weak var lbl_BelowTitle: UILabel!
    @IBOutlet weak var lbl_FinalPrice: UILabel!
    @IBOutlet weak var lbl_AddonPrice: UILabel!
    @IBOutlet weak var view_Discount: UIView!
    @IBOutlet weak var lbl_Discount: UILabel!
    @IBOutlet weak var lbl_Tax: UILabel!
    @IBOutlet weak var lbl_TaxPercentage: UILabel!
    @IBOutlet weak var lbl_DiscountPercentage: UILabel!
    @IBOutlet weak var zyvoServiceFeePercent: UILabel!
    @IBOutlet weak var lbl_ZyvoServiceFee: UILabel!
    @IBOutlet weak var lbl_CleaningFee: UILabel!
    @IBOutlet weak var lbl_hoursBasedTotal: UILabel!
    @IBOutlet weak var lbl_AboveHours: UILabel!
    @IBOutlet weak var lbl_BelowNumberOfReview: UILabel!
    @IBOutlet weak var lbl_Distance: UILabel!
    @IBOutlet weak var lbl_numberOfReview: UILabel!
    @IBOutlet weak var lbl_ratings: UILabel!
    @IBOutlet weak var lbl_PropertyName: UILabel!
    @IBOutlet weak var lbl_HostName: UILabel!
    @IBOutlet weak var btnshowMore: UIButton!
    @IBOutlet weak var view_RulesParking: UIView!
    @IBOutlet weak var view_HostRules: UIView!
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var imgProperty: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tblVH_Const: NSLayoutConstraint!
    @IBOutlet weak var btnSortPositiveRating: UIButton!
    @IBOutlet weak var collecV_BankingDetails: UICollectionView!
    @IBOutlet weak var lbl_parkingRulesDesc: UILabel!
    @IBOutlet weak var lbl_hostRulesDesc: UILabel!
    @IBOutlet weak var lbl_sortType: UILabel!
    @IBOutlet weak var collecV_Host: UICollectionView!
    @IBOutlet weak var collecV_IncludedServices: UICollectionView!
    @IBOutlet weak var collecVH_IncludedServices: NSLayoutConstraint!
    @IBOutlet weak var view_Details: UIView!
    @IBOutlet weak var btnMessageHost: UIButton!
    @IBOutlet weak var btnReviewBooking: UIButton!
    @IBOutlet weak var lbl_mapAddress: UILabel!
    @IBOutlet weak var view_Parking: UIView!
    @IBOutlet weak var view_wifi: UIView!
    @IBOutlet weak var view_rooms: UIView!
    @IBOutlet weak var view_Tables: UIView!
    @IBOutlet weak var view_Chairs: UIView!
    @IBOutlet weak var view_Kitchen: UIView!
    @IBOutlet weak var imgHeart: UIImageView!
    @IBOutlet weak var view_timeFrom: UIView!
    @IBOutlet weak var view_bookedHours: UIView!
    @IBOutlet weak var view_ParkingDesc: UIView!
    @IBOutlet weak var view_HostDesc: UIView!
    @IBOutlet weak var collVH: NSLayoutConstraint!
    @IBOutlet weak var view_BookedDate: UIView!
    @IBOutlet weak var mapv1: GMSMapView!
    @IBOutlet weak var view_HoldMessage: UIView!
    @IBOutlet weak var view_AddOns: UIView!
    @IBOutlet weak var msgTxt_V: UITextView!
    @IBOutlet weak var view_MessageDesc: UIView!
    @IBOutlet weak var view_OtherReason: UIView!
    @IBOutlet weak var view_AvailableDays: UIView!
    @IBOutlet weak var view_IhaveDoubt: UIView!
    @IBOutlet weak var view_UnderHoldMessage: UIView!
    @IBOutlet weak var btnBelowBookingStatus: UIButton!
    
    
    let items = ["October 22, 2023   ", "From 01pm to 03pm", "2 Hours"]
    var imgArr = ["calenderblackicon","watchblackicon","watchblackicon"]
    
    var arrHost = ["Computer Screen","Bed Sheets","Phone charger","Ring Light"]
    
    private let spacing:CGFloat = 16.0
    var isReadMore = "yes"
    var Host_count = 4
    var count = 5
    let timeDropdown = DropDown()
    var isParkingRulesOpen = "no"
    var isHostTingRulesOpen = "no"
    var Times = ["Highest Review","Lowest Review","Recent Reviews"]
    var bookingID =  ""
    var propertyID = ""
    var channelName = ""
    
    var latitude =  ""
    var longitude = ""
    var reviewsArrFilter: [FilterModel]?
    private var viewModel = BookingDetailsViewModel()
    
    var viewModel1 = PropertyDetailsViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    var getBookingDetails : BookingDetailsModel?
    
    var getJoinChannelDetails : JoinChanelModel?
    
    var  reviewsArr: [FilterModel]?
    
    var  reviewsSubArr: [FilterModel]?
    
    var  chargeArr: Charges?
    var bookingHours : Int? = 0
    var heartStatus : Int? = 0
    var perHourRate : Int? = 0
    var bulkDiscoutHour : Int? = 0
    var total_amount : Double? = 0.0
    var booking_amount : Double? = 0.0
    var taxAmount : Double? = 0.0
    var DiscountAmount : Double? = 0.0
    var AddonOnsPrice : Double? = 0.0
    var ClearningFee : Double? = 0
    var zyvoServiceFee : Double? = 0
    var tax : Double? = 0
    
    var DiscountPercentage : Double? = 0.0
    var taxPercentage : Double? = 0.0
    
    // var  addOnsArr: [AddOn] = []
    
    @IBOutlet weak var lbl_Bookingtime: UILabel!
    @IBOutlet weak var lbl_bookedHours: UILabel!
    @IBOutlet weak var lbl_bookedDate: UILabel!
    var  IncludesServiceArr: [String] = []
    var Message  = ""
    var arrSelectedArr :[Int] = []
    
    var page = 1
    
    var totalPage : Int? = 0
    
    var reviewType = "highest_review"
    
    var hostProfileImg = ""
    
    var guestProfileImg = ""
    
    var hostName = ""
    var guestName = ""
    
    var BookingStatus = ""
    
    var isRewReadMore = "yes"
    
    var PlaceholderText = "Share a message"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view_CleaningFee.isHidden = true
        view_ZyvoServiceFee.isHidden = true
        view_Tax.isHidden = true
        view_Discount.isHidden = true
        view_AddOns.isHidden = true
       
        msgTxt_V.text = PlaceholderText
        msgTxt_V.delegate = self
        msgTxt_V.textColor = .lightGray
        
        self.Message = "I have a doubt"
        view_MessageDesc.isHidden = true
        print(BookingStatus,"BookingStatus Coming")
        switch BookingStatus {
        case "finished":
            btnReviewBooking.setTitle("Review Booking", for: .normal)
            btnBelowBookingStatus.setTitle("Finished", for: .normal)
            
        case "confirmed":
            btnBelowBookingStatus.setTitle("Confirmed", for: .normal)
            btnReviewBooking.setTitle("Cancel", for: .normal)
        case "waiting_payment":
            btnBelowBookingStatus.setTitle("Waiting payment", for: .normal)
            btnReviewBooking.setTitle("Cancel", for: .normal)
            
        case "cancelled":
            btnBelowBookingStatus.setTitle("Cancelled", for: .normal)
            btnReviewBooking.setTitle("Review Booking", for: .normal)
            
        default:
            btnBelowBookingStatus.setTitle("Pending", for: .normal)
            btnReviewBooking.setTitle("Cancel", for: .normal)
            
            break
        }
        
        self.lbl_sortType.text = "Sort by: Highest Review"
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.layer.frame.height / 2
        self.imgProfile.contentMode = .scaleAspectFill
        self.imgProfile.layer.borderWidth = 1
        self.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        
        self.latitude = UserDetail.shared.getAppLatitude()
        self.longitude = UserDetail.shared.getAppLongitude()
        bindVC()
        viewModel.apiForGetPropertyDetails(bookingid: self.bookingID, lat: self.latitude, long: self.longitude)
        
        tblV.register(UINib(nibName: "RatingCell", bundle: nil), forCellReuseIdentifier: "RatingCell")
        tblV.delegate = self
        tblV.dataSource = self
        
        viewModel1.apiForFilterData(propertyId: self.propertyID , filter: self.reviewType , page: self.page )
        
        tblV.isScrollEnabled = false  // Disable scrolling
        tblV.estimatedRowHeight = 80
        tblV.rowHeight = UITableView.automaticDimension
        
        self.tblV.reloadData()
        
        let nibs = UINib(nibName: "ServiceCell", bundle: nil)
        collecV_IncludedServices.register(nibs, forCellWithReuseIdentifier: "ServiceCell")
        
        collecV_IncludedServices.delegate = self
        collecV_IncludedServices.dataSource = self
        
        self.tblV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        view_HoldMessage.isHidden = true
        view_HoldMessage.layer.cornerRadius = 20
        view_HoldMessage.layer.borderWidth = 1.5
        view_HoldMessage.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_IhaveDoubt.layer.cornerRadius = 10
        view_IhaveDoubt.layer.borderWidth = 1.5
        view_IhaveDoubt.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_AvailableDays.layer.cornerRadius = 10
        view_AvailableDays.layer.borderWidth = 1.5
        view_AvailableDays.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_OtherReason.layer.cornerRadius = 10
        view_OtherReason.layer.borderWidth = 1.5
        view_OtherReason.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_MessageDesc.layer.cornerRadius = 10
        view_MessageDesc.layer.borderWidth = 1.5
        view_MessageDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        btnshowMore.layer.cornerRadius = btnshowMore.layer.frame.height / 2
        btnshowMore.layer.borderWidth = 1.0
        btnshowMore.layer.borderColor = UIColor.lightGray.cgColor
        
        view_RulesParking.layer.cornerRadius = 10
        view_RulesParking.layer.borderWidth = 1.0
        view_RulesParking.layer.borderColor = UIColor.lightGray.cgColor
        
        view_HostRules.layer.cornerRadius = 10
        view_HostRules.layer.borderWidth = 1.0
        view_HostRules.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Parking.layer.cornerRadius = 15
        view_Parking.layer.borderWidth = 1.0
        view_Parking.layer.borderColor = UIColor.lightGray.cgColor
        
        view_wifi.layer.cornerRadius = 15
        view_wifi.layer.borderWidth = 1
        view_wifi.layer.borderColor = UIColor.lightGray.cgColor
        
        view_rooms.layer.cornerRadius = 15
        view_rooms.layer.borderWidth = 1
        view_rooms.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Tables.layer.cornerRadius = 15
        view_Tables.layer.borderWidth = 1
        view_Tables.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Chairs.layer.cornerRadius = 15
        view_Chairs.layer.borderWidth = 1
        view_Chairs.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Kitchen.layer.cornerRadius = 15
        view_Kitchen.layer.borderWidth = 1
        view_Kitchen.layer.borderColor = UIColor.lightGray.cgColor
        
        view_HostDesc.isHidden = true
        view_HostDesc.layer.cornerRadius = 20
        view_HostDesc.layer.borderWidth = 1.5
        view_HostDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_ParkingDesc.isHidden = true
        view_ParkingDesc.layer.cornerRadius = 20
        view_ParkingDesc.layer.borderWidth = 1.5
        view_ParkingDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_timeFrom.layer.cornerRadius = view_timeFrom.layer.frame.height / 2
        view_timeFrom.layer.borderWidth = 1.5
        view_timeFrom.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_bookedHours.layer.cornerRadius = view_bookedHours.layer.frame.height / 2
        view_bookedHours.layer.borderWidth = 1.5
        view_bookedHours.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_BookedDate.layer.cornerRadius = view_BookedDate.layer.frame.height / 2
        view_BookedDate.layer.borderWidth = 1.5
        view_BookedDate.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Details.layer.cornerRadius = 30
        view_Details.layer.borderWidth = 0.5
        view_Details.layer.borderColor = UIColor.lightGray.cgColor
        
        btnMessageHost.layer.cornerRadius = 10
        btnMessageHost.layer.borderWidth = 1
        btnMessageHost.layer.borderColor = UIColor.black.cgColor
        
        btnReviewBooking.layer.cornerRadius = 10
        btnReviewBooking.layer.borderWidth = 1
        btnReviewBooking.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1).cgColor
    }
    
    // UITextViewDelegate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if msgTxt_V.text == PlaceholderText {
            msgTxt_V.text = ""
            msgTxt_V.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if msgTxt_V.text.isEmpty {
            msgTxt_V.text = PlaceholderText
            msgTxt_V.textColor = .lightGray
        }
    }
    
    private func updateCollectionViewHeight() {
        // Get the content size of the collection view
        
        collecV_IncludedServices.layoutIfNeeded()
        let contentHeight = collecV_IncludedServices.contentSize.height
        // Update the height constraint
        collecVH_IncludedServices.constant = contentHeight
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
    @IBAction func btnSendMessage_Tap(_ sender: UIButton) {
        
        // Check if the message is "Others" and the text is still the placeholder
        if self.Message == "Others" {
            if msgTxt_V.text.isEmpty || msgTxt_V.text == PlaceholderText || msgTxt_V.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.showAlert(for: "Please enter your message")
                return
            } else {
                // Use the actual message
                self.Message = msgTxt_V.text
            }
        }
        
        // Hide the message view
        self.view_HoldMessage.isHidden = true
        
        // Get the sender ID
        let senderID = UserDetail.shared.getUserId()
        
        // Call the API
        viewModel.apiForJoinChannel(
            senderId: senderID,
            receiverId: "\(self.getBookingDetails?.hostID ?? 0)",
            groupChannel: self.channelName,
            userType: "guest"
        )
        
    }
    
    @IBAction func backBtn(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareBtn(_ sender: UIButton){
        let text = "This is the text...."
        let image = UIImage(named: "front-view-psychologist-patient-1 2")
        //            let myWebsite = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
        let shareAll = [text , image!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
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
    @IBAction func btnAddToWishlist_Tap(_ sender: UIButton) {
        
        if heartStatus == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddToWishListPopUpVC") as! AddToWishListPopUpVC
            vc.propertyID = "\(self.propertyID)"
            vc.backAction = { str in
                print(str,"Data Recieved")
                if str == "SaveItemInWishlist" {
                    self.viewModel.apiForGetPropertyDetails(bookingid: self.bookingID, lat: self.latitude, long: self.longitude)
                }
                if str == "Ravi" {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateWishListVC") as! CreateWishListVC
                    vc.propertyID = "\(self.propertyID)"
                    vc.backAction = { str in
                        print(str,"Created")
                        self.viewModel.apiForGetPropertyDetails(bookingid: self.bookingID, lat: self.latitude, long: self.longitude)
                        
                    }
                    self.present(vc, animated:  false)
                }
            }
            self.present(vc, animated:  false)
        } else {
            print("Remove From wishlist")
            
            self.viewModel1.apiforRemoveFromWishlist(propertyID: "\(self.propertyID)")
        }
        
    }
    
    @IBAction func btnReviewBooking_Tap(_ sender: UIButton) {
        
        if sender.title(for: .normal) == "Review Booking" {
            // Perform task for finished booking
            print("Booking is finished. Perform related task here.")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewFeedbackVC") as! ReviewFeedbackVC
            vc.bookingID = self.bookingID
            vc.propertyID = self.propertyID
            self.present(vc, animated: true)
        } else if sender.title(for: .normal) == "Cancel" {
            // Perform task for cancel
            print("Booking is cancelled. Perform related task here.")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelBookingPopUpVC") as! CancelBookingPopUpVC
            vc.backAction = { str in
                print(str,"Data Recieved")
                
                if str == "Yes"{
                    print("CancelAPI")
                    self.viewModel.apiForCancelBooking(bookingid: self.bookingID)
                }
            }
            self.present(vc, animated: true)
        }
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
            self?.viewModel1.apiForFilterData(propertyId: self?.propertyID ?? "0", filter: self?.reviewType ?? "highest_review", page: nil)
            
        }
        timeDropdown.show()
    }
    
    @IBAction func btnShowMore_Tap(_ sender: UIButton) {
        if isReadMore == "no" {
            isReadMore = "yes"
            Host_count = Host_count - 1
            collVH.constant = 160
            sender.setTitle("See More", for: .normal)
            
        } else {
            sender.setTitle("See Less", for: .normal)
            
            isReadMore = "no"
            Host_count = Host_count + 1
            collVH.constant = 270
        }
    }
    
    @IBAction func btnReadMore_Tap(_ sender: UIButton) {
        
        self.page = page + 1
        
        if self.isRewReadMore == "no" {
            self.isRewReadMore = "yes"
        }
        self.viewModel1.apiForFilterData(propertyId: self.propertyID , filter: self.reviewType, page: self.page )
    }
    
    @IBAction func btnMessageHost_Tap(_ sender: UIButton) {
        
        self.view_HoldMessage.isHidden = false
        
    }
    @IBAction func btnOtherReason_Tap(_ sender: UIButton) {
        self.Message = "Others"
        view_MessageDesc.isHidden = false
        view_IhaveDoubt.backgroundColor = UIColor.clear
        view_AvailableDays.backgroundColor = UIColor.clear
        view_OtherReason.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
    }
    
    @IBAction func btnIhaveDoubt_Tap(_ sender: UIButton) {
        self.Message = "I have a doubt"
        view_IhaveDoubt.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        view_AvailableDays.backgroundColor = UIColor.white
        view_OtherReason.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnAvailableDays_Tap(_ sender: UIButton) {
        self.Message = "Available days"
        view_IhaveDoubt.backgroundColor = UIColor.clear
        view_AvailableDays.backgroundColor =  UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        view_OtherReason.backgroundColor = UIColor.clear
        
    }
}

extension ReviewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IncludesServiceArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
        cell.lbl_serviceName.text = IncludesServiceArr[indexPath.row]
        return cell
    }
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = 70
        
        let padding: CGFloat = 10 // Spacing between cells
        let itemsPerRow: CGFloat = 3.1
        let totalPadding = (itemsPerRow - 1) * padding
        let availableWidth = collectionView.frame.width - totalPadding
        let cellWidth = availableWidth / itemsPerRow
        return CGSize(width: cellWidth, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between rows
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between columns
    }
}

extension ReviewVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = reviewsArr?[indexPath.row]
        let cell = tblV.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
        
        cell.lbl_name.text = data?.reviewerName ?? ""
        cell.lbl_date.text = data?.reviewDate ?? ""
        cell.lbl_desc.text = data?.reviewMessage ?? ""
        let doubleValue = Double(data?.reviewRating ?? "") ?? 0.0
        cell.viewRating.rating = doubleValue
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

extension ReviewVC {
    func bindVC(){
        viewModel.$bookingDetailsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    // self.showToast(response.message ?? "")
                    self.getBookingDetails = response.data
                    
                    print(self.getBookingDetails,"getBookingDetails")
                    
                    let guestID = self.getBookingDetails?.guestID ?? 0
                    let hostID = self.getBookingDetails?.hostID ?? 0
                    
                    let id1 = min(guestID, hostID)
                    let id2 = max(guestID, hostID)
                    
                    self.heartStatus = self.getBookingDetails?.isInWishlist ?? 0
                    
                    if self.heartStatus == 0 {
                        self.imgHeart.image = UIImage(named: "hearticons")
                        
                    } else {
                        self.imgHeart.image = UIImage(named: "day")
                        
                    }
                    self.channelName = "ZYVOOPROJ_\(id1)_\(id2)_\(self.bookingID)"
                    print(self.channelName,"self.channelName")
                    print(id1,id2,self.propertyID,"ASDFASDF")
                    
                    self.IncludesServiceArr = self.getBookingDetails?.amenities ?? []
                    
                    self.chargeArr = self.getBookingDetails?.charges
                    print("Charges")
                    print(self.chargeArr?.bookingHours ?? "")
                    let bookinghours = self.chargeArr?.bookingHours ?? 0
                    if bookinghours == 1 {
                        self.lbl_AboveHours.text = "\(bookinghours) Hour"
                    } else {
                        self.lbl_AboveHours.text = "\(bookinghours) Hours"
                    }
                    self.bookingHours = Int(bookinghours)
                    print(self.chargeArr?.hourlyRate ?? "")
                    
                    if let hourlyRateString = self.chargeArr?.hourlyRate,
                       let hourlyRateDouble = Double(hourlyRateString) {
                        let intValue = Int(hourlyRateDouble)
                        print(intValue)  // Output: 10
                        self.perHourRate = intValue
                    }
                    
                    self.bulkDiscoutHour = self.chargeArr?.bulkDiscountHours
                    
                    if let discountPercentage = self.chargeArr?.bulkDiscountRate,
                       let discountPercentageDouble = Double(discountPercentage) {
                        let intValue = Int(discountPercentageDouble)
                        print(intValue)  // Output: 10
                        self.DiscountPercentage = Double(intValue)
                    }
                    
                    if let taxPercentage = self.chargeArr?.taxes {
                        let intValue = Int(taxPercentage)
                        print(intValue) // Output: 10
                        self.taxPercentage = Double(intValue)
                    }
                    
                    if let cleaningFee = self.chargeArr?.cleaningFee {
                        let intValue = Int(cleaningFee)
                        print(intValue) // Output: 10
                        self.ClearningFee = Double(intValue)
                    }
                    let bookingdetails = self.getBookingDetails?.bookingDetail
                    self.lbl_bookedDate.text = bookingdetails?.date ?? ""
                    self.lbl_Bookingtime.text = bookingdetails?.startEndTime ?? ""
                    self.lbl_bookedHours.text = bookingdetails?.time ?? ""
                    
                    self.AddonOnsPrice = Double(self.chargeArr?.addOn ?? 0)
                    
                    self.booking_amount = Double(((self.bookingHours ?? 0) * (self.perHourRate ?? 0)))
                    
                    let zyvoFeePercentage = Double(self.chargeArr?.zyvoServiceFee ?? 0)
                    self.zyvoServiceFee = ((self.booking_amount ?? 0.0) * (zyvoFeePercentage ?? 0.0)) / 100.0
                    let bookingAmountFees = "\(self.booking_amount ?? 0.0)"
                    self.lbl_hoursBasedTotal.text = "$\(bookingAmountFees.formattedPrice())"
                    
                    if (self.bookingHours ?? 0) > (self.bulkDiscoutHour ?? 0)   {
                        let result = self.calculateFinalPriceWithDiscount(totalPrice: self.booking_amount ?? 0.0, discountPercent: self.DiscountPercentage ?? 0.0, taxPercent: self.taxPercentage ?? 0.0)
                        print("=========================WithDiscount===========================")
                        // Printing the Result
                        
                        print("Total Price: \(result.totalPrice )")
                        print("Discount Amount (\(self.DiscountPercentage ?? 0.0)%) : \(String(describing: result.discountAmount ))")
                        print("Discounted Price: \(result.discountedPrice )")
                        print("Tax Amount (\(self.taxPercentage ?? 0.0)%): \(String(describing: result.taxAmount ))")
                        self.taxAmount = (result.taxAmount).rounded(toPlaces: 2)
                        self.DiscountAmount = (result.discountAmount).rounded(toPlaces: 2)
                        
                        let bookingAmount = self.booking_amount ?? 0.0
                        let cleaningFee = self.ClearningFee ?? 0.0
                        let serviceFee = self.zyvoServiceFee ?? 0.0
                        let tax = (self.taxAmount ?? 0.0).rounded(toPlaces: 2)
                        let addOns = self.AddonOnsPrice ?? 0.0
                        
                        let addonPrice = addOns
                        if addonPrice == 0.0 {
                            self.view_AddOns.isHidden = true
                        } else {
                            self.view_AddOns.isHidden = false
                            let addOnsFees = "\(addOns)"
                            self.lbl_AddonPrice.text = "$\(addOnsFees.formattedPrice())" }
                        
                        let AddTotalAmount = (bookingAmount + cleaningFee + serviceFee + tax + addOns).rounded(toPlaces: 2)
                        
                        let totalAmount = (AddTotalAmount -  (self.DiscountAmount ?? 0.0)).rounded(toPlaces: 2)
                        let totalAmountFees = "\(totalAmount)"
                       
                        self.lbl_FinalPrice.text = "$\(totalAmountFees.formattedPrice())"
                        
                        let cleaningFees = "\(cleaningFee)"
                        if cleaningFees != "0.0" {
                            self.view_CleaningFee.isHidden = false
                            self.lbl_CleaningFee.text = "$\(cleaningFees.formattedPrice())"
                        }
                        
                        let serviceFees = "\(serviceFee)"
                        if serviceFees != "0.0" {
                            self.lbl_ZyvoServiceFee.text = "$\(serviceFees.formattedPrice())"
                            self.view_ZyvoServiceFee.isHidden = false
                        }
                       
                        let taxFees = "\(tax)"
                        if taxFees != "0.0" {
                            self.view_Tax.isHidden = false
                            self.lbl_Tax.text = "$\(taxFees.formattedPrice())"
                        }
                        
                        
                        let DiscountAmountFees = "\(self.DiscountAmount ?? 0.0)"
                        if DiscountAmountFees != "0.0"{
                            self.view_Discount.isHidden = false
                            self.lbl_Discount.text = "-$\(DiscountAmountFees.formattedPrice()) "
                        }
                       
                        self.total_amount = totalAmount
                        
                        print("Final Price: \(String(describing: result.finalPrice))")
                        
                    } else {
                        let result = self.calculateFinalPriceWithoutDiscount(totalPrice: self.booking_amount ?? 0.0, taxPercent: self.taxPercentage ?? 0.0)
                        
                        print("============================WithoutDiscount==========================")
                        print("Tax Amount: \(result.taxAmount ?? 0.0)")
                        self.taxAmount = result.taxAmount ?? 0.0
                        self.view_Discount.isHidden = true
                        
                        let bookingAmount = self.booking_amount ?? 0.0
                        let cleaningFee = self.ClearningFee ?? 0.0
                        let serviceFee = self.zyvoServiceFee ?? 0.0
                        let tax = (self.taxAmount ?? 0.0).rounded(toPlaces: 2)
                        let addOns = self.AddonOnsPrice ?? 0.0
                        
                        let addonPrice = addOns
                        if addonPrice == 0.0 {
                            self.view_AddOns.isHidden = true
                        } else {
                            self.view_AddOns.isHidden = false
                            let addonPriceFees = "\(addOns)"
                            self.lbl_AddonPrice.text = "$\(addonPriceFees.formattedPrice())"
                        }
                        
                        let cleaningFees = "\(cleaningFee)"
                        if cleaningFees != "0.0" {
                            self.view_CleaningFee.isHidden = false
                            self.lbl_CleaningFee.text = "$\(cleaningFees.formattedPrice())"
                        }
                       
                        let zyvoServiceFees = "\(self.zyvoServiceFee ?? 0.0)"
                        if zyvoServiceFees != "0.0" {
                            self.view_ZyvoServiceFee.isHidden = false
                            self.lbl_ZyvoServiceFee.text = "$\(zyvoServiceFees.formattedPrice())"
                        }
                        
                       // self.lbl_Tax.text = "$\(tax)"
//                        let discountFees = "\(self.DiscountAmount ?? 0.0)"
//                        if discountFees != "0.0" {
//                            self.lbl_Discount.text = "-$\(discountFees.formattedPrice())"
//                            self.view_Discount.isHidden = false
//                        }
                       
                        let AddTotalAmount = (bookingAmount + cleaningFee + serviceFee + tax + addOns).rounded(toPlaces: 2)
                        
                        let taxFees = "\(tax)"
                        if taxFees != "0.0" {
                            self.lbl_Tax.text = "$\(taxFees.formattedPrice())"
                            self.view_Tax.isHidden = false
                        }
                        let AddTotalAmountFees = "\(AddTotalAmount)"
                        self.lbl_FinalPrice.text = "$\(AddTotalAmountFees.formattedPrice())"
                        
                        self.total_amount = (AddTotalAmount).rounded(toPlaces: 2)
                        
                        print("Final Price After Tax: \(result.finalPrice ?? 0.0)") // 945.0
                    }
                    
                    
                    var parkingRules =  self.getBookingDetails?.parkingRules ?? []
                    if parkingRules.count != 0 {
                        self.lbl_parkingRulesDesc.text = parkingRules[0] }
                    var hostRules =  self.getBookingDetails?.hostRules ?? []
                    if hostRules.count != 0 {
                        self.lbl_hostRulesDesc.text = hostRules[0] }
                    
                    print(self.chargeArr?.hourlyRate ?? "")
                    self.lbl_HostName.text = self.getBookingDetails?.hostName ?? ""
                    let image = self.getBookingDetails?.hostProfileImage ?? ""
                    let imgURL = AppURL.imageURL + image
                    
                    self.hostProfileImg = imgURL
                    //self.profileIMGURL = imgURL
                    self.imgProfile.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
                    self.lbl_PropertyName.text = self.getBookingDetails?.propertyName ?? ""
                    self.lbl_BelowTitle.text = self.getBookingDetails?.propertyName ?? ""
                    self.lbl_ratings.text = "\(self.getBookingDetails?.rating ?? 0)"
                    self.lbl_RatingBelow.text = "\(self.getBookingDetails?.rating ?? 0)"
                    if( self.getBookingDetails?.reviews?.count ?? 0) != 0 {
                        self.lbl_BelowNumberOfReview.text = "Reviews (\(self.getBookingDetails?.reviews?.count ?? 0))"
                    } else {
                        self.lbl_BelowNumberOfReview.text = "Reviews (0)"
                    }
                    self.lbl_numberOfReview.text = "(\(self.getBookingDetails?.reviews?.count ?? 0))"
                    self.lbl_Distance.text = "\(self.getBookingDetails?.distanceMiles ?? "0") miles"
                    
                    let img = self.getBookingDetails?.propertyImages ?? []
                    
                    self.lbl_mapAddress.text = self.getBookingDetails?.location ?? ""
                    var latitude = Double(self.getBookingDetails?.latitude ?? "")
                    var longitude = Double(self.getBookingDetails?.longitude ?? "")
                    
                    print(latitude ?? "", latitude ?? "", "latString, lonString") // Debugging log
                    
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
                    let centeredCamera = GMSCameraPosition.camera(withLatitude: latitude ?? 0.0, longitude: longitude ?? 0.0, zoom: self.mapv1.camera.zoom)
                    self.mapv1.animate(to: centeredCamera)
                    marker.map = self.mapv1
                    
                    var imgPropertyString = self.getBookingDetails?.firstPropertyImage ?? ""
                    
                    let imgURLi = AppURL.imageURL + imgPropertyString
                    self.imgProperty.loadImage(from:imgURLi,placeholder: UIImage(named: "img1"))
                    
                    if img.count == 1 {
                        
                        self.viewImgProperty1.isHidden = false
                        self.viewPropertyImg23.isHidden = true
                        let image = img[0]
                        let imgURL = AppURL.imageURL + image
                        self.img1.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
                        
                        
                    }  else if img.count == 2 {
                        self.viewImgProperty1.isHidden = false
                        self.viewPropertyImg23.isHidden = false
                        self.viewImgProperty3.isHidden = true
                        let image = img[0]
                        let imgURL = AppURL.imageURL + image
                        self.img1.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
                        
                        let image1 = img[1]
                        let imgURL1 = AppURL.imageURL + image1
                        self.img2.loadImage(from:imgURL1,placeholder: UIImage(named: "img1"))
                        
                    } else if img.count == 3 {
                        
                        self.viewImgProperty1.isHidden = false
                        self.viewPropertyImg23.isHidden = false
                        self.viewImgProperty3.isHidden = false
                        let image = img[0]
                        let imgURL = AppURL.imageURL + image
                        self.img1.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
                        
                        let image1 = img[1]
                        let imgURL1 = AppURL.imageURL + image1
                        self.img2.loadImage(from:imgURL1,placeholder: UIImage(named: "img1"))
                        
                        let image2 = img[2]
                        let imgURL2 = AppURL.imageURL + image2
                        self.img3.loadImage(from:imgURL2,placeholder: UIImage(named: "img1"))
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.collecV_IncludedServices.reloadData()
                        self.updateCollectionViewHeight()
                    }
                    
                })
            }.store(in: &cancellables)
        
        viewModel.$getJoinChannelResult
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
                        print(self.Message,"self.Message")
                        vc.Message = self.Message
                        vc.uniqueConversationName = self.channelName
                        vc.friend_id = "\(receiverID)"
                        vc.SenderID = senderID
                        
                        vc.hostProfileImg = self.guestProfileImg
                        vc.guesttProfileImg = self.hostProfileImg
                        vc.hostName = self.getJoinChannelDetails?.receiverName ?? ""
                        vc.guestName = self.getJoinChannelDetails?.senderName ?? ""
                        self.tabBarController?.tabBar.isHidden = true
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                })
            }.store(in: &cancellables)
        
        viewModel1.$getFilterDataResult
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
                    
                    print(self.totalPage ?? 0,"self.totalPage")
                    print(self.page,"self.page")
                    
                    if self.reviewsSubArr?.count != 0 {
                        
                        if self.page == (self.totalPage ?? 0) {
                            self.btnshowMore.isHidden = true
                        } else {
                            self.btnshowMore.isHidden = false
                        }
                    } else {
                        self.btnshowMore.isHidden = true
                        
                    }
                    self.tblV.reloadData()
                })
            }.store(in: &cancellables)
        
        
        // CancelbookingResult
        viewModel.$cancelBookingResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    self.showAlert(for: "\(response.message ?? "")")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }.store(in: &cancellables)
        
        viewModel1.$getWishlistRemoveResult
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] result in
                
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.showToast(response.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.viewModel.apiForGetPropertyDetails(bookingid: self.bookingID, lat: self.latitude, long: self.longitude)
                    }
                })
            }.store(in: &cancellables)
    }
    
    func calculateFinalPriceWithDiscount(totalPrice: Double, discountPercent: Double, taxPercent: Double) -> (totalPrice: Double, discountAmount: Double, discountedPrice: Double, taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Discount Amount
        let discountAmount = totalPrice * (discountPercent / 100)
        
        
        // Step 2: Calculate Discounted Price after Deducting Discount Amount
        let discountedPrice = totalPrice - discountAmount
        
        // Step 3: Calculate Tax Amount
        let taxAmount = discountedPrice * (taxPercent / 100)
        
        let formattedTaxAmount = (taxAmount * 100).rounded() / 100
        print(formattedTaxAmount)
        
        // Step 4: Final Price after Adding Tax Amount
        let finalPrice = discountedPrice + formattedTaxAmount
        
        // Return All Values as a Tuple
        return (totalPrice, discountAmount, discountedPrice, formattedTaxAmount, finalPrice)
    }
    func calculateFinalPriceWithoutDiscount(totalPrice: Double, taxPercent: Double) -> (taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Tax Amount
        let taxAmount = (totalPrice * (taxPercent / 100)).rounded(toPlaces: 2)
        
        // Step 2: Final Price after Tax
        let finalPrice = totalPrice + taxAmount
        
        return (taxAmount, finalPrice)
    }
}
