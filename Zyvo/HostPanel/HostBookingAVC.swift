//
//  HostBookingAVC.swift
//  Zyvo
//
//  Created by ravi on 2/01/25.
//

import UIKit
import DropDown
import Combine
import GoogleMaps
import CoreLocation
import TTGTags

class HostBookingAVC: UIViewController,UITextViewDelegate {
    @IBOutlet weak var lbl_Discount: UILabel!
    @IBOutlet weak var view_CleaningFee: UIView!
    @IBOutlet weak var view_Discount: UIView!
    @IBOutlet weak var view_Addons: UIView!
    @IBOutlet weak var lbl_SortType: UILabel!
    @IBOutlet weak var btnshowMore: UIButton!
    @IBOutlet weak var view_RulesParking: UIView!
    @IBOutlet weak var view_HostRules: UIView!
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var view_DescParking: UIView!
    @IBOutlet weak var view_DescHostRules: UIView!
    @IBOutlet weak var tblVH_Const: NSLayoutConstraint!
    @IBOutlet weak var btnSortPositiveRating: UIButton!
    @IBOutlet weak var includeInBookingCollV: UICollectionView!
    @IBOutlet weak var collVH: NSLayoutConstraint!
    
    @IBOutlet weak var view_Details: UIView!
    @IBOutlet weak var btnMessageHost: UIButton!
    @IBOutlet weak var btnReportAnIssue: UIButton!
    @IBOutlet weak var btnReviewBooking: UIButton!
    
    @IBOutlet weak var view_Parking: UIView!
    @IBOutlet weak var view_wifi: UIView!
    @IBOutlet weak var view_rooms: UIView!
    @IBOutlet weak var view_Tables: UIView!
    @IBOutlet weak var view_Chairs: UIView!
    @IBOutlet weak var view_Kitchen: UIView!
    @IBOutlet weak var parkingDropImg: UIImageView!
    @IBOutlet weak var hostRuleDropImg: UIImageView!
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var guestNameLbl: UILabel!
    @IBOutlet weak var guestRatingLbl: UILabel!
    @IBOutlet weak var guestProfileImg: UIImageView!
    
    @IBOutlet weak var propertyImg: UIImageView!
    @IBOutlet weak var propertyNameLbl: UILabel!
    @IBOutlet weak var propertyRatingLbl: UILabel!
    @IBOutlet weak var propertyRatingCountLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var hoursPriceLbl: UILabel!
    @IBOutlet weak var cleaningFeesLbl: UILabel!
    @IBOutlet weak var zyvoServiceFeeLbl: UILabel!
    @IBOutlet weak var taxesLbl: UILabel!
    @IBOutlet weak var addOnsLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var extentionTimeView: UIView!
    
    @IBOutlet weak var propertyNameLbl1: UILabel!
    @IBOutlet weak var bookingStatusBtn: UIButton!
    @IBOutlet weak var imgbgV1: UIView!
    @IBOutlet weak var propertyImg1: UIImageView!
    @IBOutlet weak var imgbgV2: UIView!
    @IBOutlet weak var propertyImg2: UIImageView!
    @IBOutlet weak var imgbgV3: UIView!
    @IBOutlet weak var propertyImg3: UIImageView!
    @IBOutlet weak var bookingDetailView: UIView!
    @IBOutlet weak var bookingVHightCon: NSLayoutConstraint!
    @IBOutlet weak var BTEbookingDetailView: UIView!
    
    @IBOutlet weak var view_MainMessageGuest: UIView!
    @IBOutlet weak var view_SubMessageGuest: UIView!
    @IBOutlet weak var msgTxt_V: UITextView!

    @IBOutlet weak var view_AvailableDays: UIView!
    @IBOutlet weak var view_MessageDesc: UIView!
    @IBOutlet weak var view_OtherReason: UIView!
    @IBOutlet weak var view_IhaveDoubt: UIView!
    @IBOutlet weak var BTEbookingVHightCon: NSLayoutConstraint!
    @IBOutlet weak var parkingRuleLbl: UILabel!
    @IBOutlet weak var hostRuleLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    var hostProfileImg = ""
    var guestProfileImg1 = ""
    var bookingStatus = ""
    var Message = ""
    var items = [CustomBokingDetail]()
    var extendeditems = [CustomBokingDetail]()
    var arrHost = ["Computer Screen","Bed Sheets","Phone charger","Ring Light"]
    let locationManager = CLLocationManager()
    var bookingId : Int?
    var lat: Double?
    var lot: Double?
    private let spacing:CGFloat = 16.0
    
    private var viewModel = BookingDetailsViewModel()
    let timeDropdown = DropDown()
    
    var Times = ["Highest Review","Lowest Review","Recent Reviews"]
    
    var isOpenDescParking = "false"
    var isOpenDescHostRules = "false"
    var pageCount = 1
    var reviewFilter = ""
    var getJoinChannelDetails : JoinChanelModel?
    var bookingDetailViewModel = BookingDetailViewModel()
    var bookingDetailArr : BookingDetailDataModel?
    var reviewDataArr = [H_ReviewsDataModel]()
    private var viewModel1 = BookingDetailsViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    var channelName = ""
    var propertyID = ""
    var extId : Int?
    var PlaceholderText = "Share a message"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Message = "I have a doubt"
        
        self.lbl_SortType.text = "Sort by: Highest Review"
        
        if bookingStatus == "pending"{
            self.btnReviewBooking.setTitle("Approve Booking", for: .normal)
        }else{
            self.btnReviewBooking.setTitle("Review Guest", for: .normal)
        }
        if extId == 0{
            self.extentionTimeView.isHidden = true
        }else{
            self.extentionTimeView.isHidden = false
        }
        
        self.bindVC_GetBookingDetail()
        self.bindVC_GetReviews()
        
        view_DescParking.isHidden = true
        view_DescHostRules.isHidden = true
        view_Addons.isHidden = true
        view_Discount.isHidden = true
        view_CleaningFee.isHidden = true
        
        tblV.register(UINib(nibName: "RatingCell", bundle: nil), forCellReuseIdentifier: "RatingCell")
        tblV.delegate = self
        tblV.dataSource = self
        
        msgTxt_V.delegate = self
        msgTxt_V.textColor = UIColor.lightGray
        
        // self.mapView.delegate = self
        
        self.tblV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        view_MainMessageGuest.isHidden = true
        view_SubMessageGuest.layer.cornerRadius = 20
        view_SubMessageGuest.layer.borderWidth = 1.5
        view_SubMessageGuest.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
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
        
        guestProfileImg.layer.cornerRadius = guestProfileImg.frame.height / 2
        
        view_RulesParking.layer.cornerRadius = 10
        view_RulesParking.layer.borderWidth = 1.0
        view_RulesParking.layer.borderColor = UIColor.lightGray.cgColor
        
//        view_DescParking.layer.cornerRadius = 10
//        view_DescParking.layer.borderWidth = 1.0
//        view_DescParking.layer.borderColor = UIColor.lightGray.cgColor
//        
//        view_DescHostRules.layer.cornerRadius = 10
//        view_DescHostRules.layer.borderWidth = 1.0
//        view_DescHostRules.layer.borderColor = UIColor.lightGray.cgColor
        
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

//        let nib1 = UINib(nibName: "HostBookingsIncludeCollVCell", bundle: nil)
//        includeInBookingCollV?.register(nib1, forCellWithReuseIdentifier: "HostBookingsIncludeCollVCell")
        
        let nibs = UINib(nibName: "ServiceCell", bundle: nil)
        includeInBookingCollV.register(nibs, forCellWithReuseIdentifier: "ServiceCell")
        
        
        includeInBookingCollV.delegate = self
        includeInBookingCollV.dataSource = self
        
       
        view_Details.layer.cornerRadius = 20
        view_Details.layer.borderWidth = 1.5
        view_Details.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        btnMessageHost.layer.cornerRadius = 10
        btnMessageHost.layer.borderWidth = 1
        btnMessageHost.layer.borderColor = UIColor.black.cgColor
        
        btnReportAnIssue.layer.cornerRadius = 10
        btnReportAnIssue.layer.borderWidth = 1
        btnReportAnIssue.layer.borderColor = UIColor.black.cgColor
        
        btnReviewBooking.layer.cornerRadius = 10
        btnReviewBooking.layer.borderWidth = 1
        btnReviewBooking.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1).cgColor
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblV.layer.removeAllAnimations()
        tblVH_Const.constant = tblV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
        
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

    @IBAction func btnMessageGuest_Tap(_ sender: Any) {
        
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
        // Get the sender ID
        let senderID = UserDetail.shared.getUserId()
        // Call the API
        viewModel.apiForJoinChannel(
            senderId: senderID,
            receiverId: "\(self.bookingDetailArr?.guestID ?? 0)",
            groupChannel: self.channelName,
            userType: "host")
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnReportAnIssue_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostReportViolationPopUpVc") as! HostReportViolationPopUpVc
        vc.bookingId = self.bookingId
        vc.propertyId = self.bookingDetailArr?.propertyID
        
        vc.backAction = { str in
            print(str,"Data Recieved")
            if str == "Ravik" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostNotificationPopUpVC") as! HostNotificationPopUpVC
                vc.backAction = { str in
                    print(str,"Data Recieved From ")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostSuccessPopUpVC") as! HostSuccessPopUpVC
                    self.present(vc, animated: true)
                }
                self.present(vc, animated:  true)
            }
        }
        self.present(vc, animated:  true)
    }
    @IBAction func btnParking_Tap(_ sender: UIButton) {
        if isOpenDescParking == "false" {
            isOpenDescParking = "true"
            view_DescParking.isHidden = false
            parkingDropImg.image = UIImage(named: "União 106")
        } else {
            isOpenDescParking = "false"
            view_DescParking.isHidden = true
            parkingDropImg.image = UIImage(named: "dropdownicon")
        }
    }
    
    @IBAction func btnHostRules_Tap(_ sender: UIButton) {
        if isOpenDescHostRules == "false" {
            isOpenDescHostRules = "true"
            view_DescHostRules.isHidden = false
            hostRuleDropImg.image = UIImage(named: "União 106")
        } else {
            isOpenDescHostRules = "false"
            view_DescHostRules.isHidden = true
            hostRuleDropImg.image = UIImage(named: "dropdownicon")
        }
    }
    @IBAction func btnReviewBooking_Tap(_ sender: UIButton) {
        if self.bookingStatus == "pending" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostApproveRequestVC") as! HostApproveRequestVC
            vc.bookingId = "\(self.bookingId ?? 0)"
            vc.backAction = {
                self.btnReviewBooking.setTitle("Review Guest", for: .normal)
            }
            self.present(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostReviewFeedbackVC") as! HostReviewFeedbackVC
            vc.bookingID = self.bookingId ?? 0
            vc.proprtyID = self.bookingDetailArr?.propertyID ?? 0
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
            if index == 0{
                self?.lbl_SortType.text = "Sort by: Highest Review"
                self?.bookingDetailViewModel.HostGetBookingReview(propertyId: self?.bookingDetailArr?.propertyID ?? 0, filter: "highest_review", page: self?.pageCount ?? 0)
            }else if index == 1{
                self?.bookingDetailViewModel.HostGetBookingReview(propertyId: self?.bookingDetailArr?.propertyID ?? 0, filter: "lowest_review", page: self?.pageCount ?? 0)
                self?.lbl_SortType.text = "Sort by: Lowest Review"
            }else{
                self?.bookingDetailViewModel.HostGetBookingReview(propertyId: self?.bookingDetailArr?.propertyID ?? 0, filter: "recent_review", page: self?.pageCount ?? 0)
                self?.lbl_SortType.text = "Sort by: Recent Review"
            }
        }
        timeDropdown.show()
    }
    
    @IBAction func btnMessageHost_Tap(_ sender: UIButton) {
        
        self.view_MainMessageGuest.isHidden = false
        //        self.tabBarController?.selectedIndex = 1
//        let senderID = UserDetail.shared.getUserId()
//        viewModel.apiForJoinChannel(senderId: senderID, receiverId: "\(self.bookingDetailArr?.guestID ?? 0)", groupChannel: self.channelName, userType: "host")
    }
    
    @IBAction func shareBtn(_ sender: UIButton){
        let textToShare = "Check out this cool app!"
        let urlToShare = URL(string: "https://www.example.com")!
        let itemsToShare: [Any] = [textToShare, urlToShare]
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view  // For iPad support
        
        present(activityVC, animated: true, completion: nil)
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
    
    @IBAction func ShowMoreReviewBtn(_ sender: UIButton){
        self.pageCount = pageCount + 1
        self.bookingDetailViewModel.HostGetBookingReview(propertyId: self.bookingDetailArr?.propertyID ?? 0, filter: "highest_review", page: self.pageCount)
        self.tblV.reloadData()
    }
    
}

extension HostBookingAVC{
    func createTagCloud(OnView view: UIView, withArray data:[CustomBokingDetail], heightOf_Chip: NSLayoutConstraint) {
     
            for tempView in view.subviews {
                if tempView.tag != 0 {
                    tempView.removeFromSuperview()
                }
            }
            
            var xPos:CGFloat = 5.0
            var ypos: CGFloat = 10.0
            var tag: Int = 1
            let chopHeight : CGFloat = 35.0
            let font = UIFont.systemFont(ofSize: 15.0)
            for str in data  {
                
                let startString = str.txt?.trimmingCharacters(in: .whitespacesAndNewlines)
                
                let width = startString?.widthOfString(usingFont: font)
                let checkWholeWidth = CGFloat(xPos) + CGFloat(width ?? 0.0) + CGFloat(13.0) + CGFloat(25.5 )//13.0 is the width between lable and cross button and 25.5 is cross button width and gap to righht
                if checkWholeWidth > view.bounds.size.width - 30.0 {
                    xPos = 5.0
                    ypos = ypos + chopHeight + 8.0
                }
                heightOf_Chip.constant = ypos + 40
                let bgView = UIView(frame: CGRect(x: xPos, y: ypos, width:(width ?? 0.0) + 17.0 + 38.5 , height: chopHeight))
                bgView.layer.cornerRadius = chopHeight/2
                bgView.backgroundColor =  UIColor.white
                bgView.layer.borderColor = UIColor.lightGray.cgColor
                bgView.layer.borderWidth = 1
                bgView.tag = tag
                
                let textlable = UILabel(frame: CGRect(x: 40.0, y: 0.0, width: width ?? 0.0, height: bgView.frame.size.height))
                textlable.font = font
                textlable.text = startString
                textlable.textColor = UIColor.black
                bgView.addSubview(textlable)
                
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 10, y: 6.0, width: 23.0, height: 23.0)
                button.backgroundColor = UIColor.clear
                button.layer.cornerRadius = CGFloat(button.frame.size.width)/CGFloat(2.0)
                button.setImage(str.img, for: .normal)
                button.tag = tag
                bgView.addSubview(button)
                xPos = CGFloat(xPos) + CGFloat(width ?? 0.0) + CGFloat(17.0) + CGFloat(43.0)
                view.addSubview(bgView)
                tag = tag  + 1
            }
        }
}

extension HostBookingAVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return bookingDetailArr?.amenities?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
        cell.lbl_serviceName.text = bookingDetailArr?.amenities?[indexPath.item]
        
        return cell
       
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 10, height: 55)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10 // Spacing between rows
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10 // Spacing between columns
//    }
    
    func adjustCollectionViewHeight() {
        includeInBookingCollV.layoutIfNeeded()
        collVH.constant = includeInBookingCollV.collectionViewLayout.collectionViewContentSize.height
    }
}


extension HostBookingAVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = reviewDataArr[indexPath.row]
        let cell = tblV.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
        
        if let doubleValue = Double(data.reviewRating ?? "0") {
            let intValue = Int(doubleValue) // This will truncate to 2
            print(intValue) // Output: 2
            cell.viewRating.rating = Double(intValue)
        }
        cell.lbl_name.text = data.reviewerName ?? ""
        cell.lbl_date.text = data.reviewDate ?? ""
        cell.lbl_desc.text = data.reviewMessage ?? ""
        let image = data.profileImage ?? ""
        let imgURL = AppURL.imageURL + image
        cell.img.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
        DispatchQueue.main.async {
            self.tblVH_Const.constant = self.tblV.contentSize.height
            self.tblV.layoutIfNeeded()
        }
        return cell
   
//        let cell = tblV.dequeueReusableCell(withIdentifier: "HostRatingCell", for: indexPath) as! HostRatingCell
//        
//        cell.nameLbl.text = reviewDataArr[indexPath.row].reviewerName
//        cell.ratingV.text = reviewDataArr[indexPath.row].reviewMessage
//        cell.dateLbl.text = reviewDataArr[indexPath.row].reviewDate
//        cell.ratingV.rating = Double(reviewDataArr[indexPath.row].reviewRating ?? "") ?? 0.0
//        
//        let profileURL = AppURL.imageURL + (self.reviewDataArr[indexPath.row].profileImage ?? "")
//        cell.img.loadImage(from:profileURL,placeholder: UIImage(named: "NoIMg"))
//        
//        return cell
    }
    
    
}

extension HostBookingAVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            locationManager.stopUpdatingLocation()
            bookingDetailViewModel.HostGetBookingDetail(bookingId: self.bookingId ?? 0, latitude: latitude, longitude: longitude,exteID: self.extId ?? 0)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}

extension HostBookingAVC{
    
    func bindVC_GetBookingDetail(){
        bookingDetailViewModel.$getBookingResult
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.bookingDetailArr = response.data
                    // self.reviewsArr = self.getBookingDetails?.reviews
                    let guestID = self.bookingDetailArr?.guestID ?? 0
                    let hostID = self.bookingDetailArr?.hostID ?? 0
                    let id1 = min(guestID, hostID)
                    let id2 = max(guestID, hostID)
                    
                    self.channelName = "ZYVOOPROJ_\(id1)_\(id2)_\(self.propertyID)"
                    print(self.channelName,"self.channelName")
                    print(id1,id2,self.propertyID,"ASDFASDF")
                    
                    self.guestNameLbl.text = self.bookingDetailArr?.guestName
                    self.guestRatingLbl.text = self.bookingDetailArr?.guestRating
                    self.propertyNameLbl.text = self.bookingDetailArr?.propertyTitle
                    self.propertyRatingLbl.text = "(\(self.bookingDetailArr?.reviewsTotalCount ?? "0"))"
                    self.propertyRatingCountLbl.text = "(\(self.bookingDetailArr?.reviewsTotalCount ?? "0"))"
                    self.distanceLbl.text = "\(self.bookingDetailArr?.distanceMiles ?? "") miles away"
                    self.hoursLbl.text = "\(self.bookingDetailArr?.bookingHour ?? "") Hours"
                    self.hoursPriceLbl.text = "$\(self.formatPrice(self.bookingDetailArr?.bookingAmount ?? ""))"
                    
                   
                    self.zyvoServiceFeeLbl.text = "$\(self.bookingDetailArr?.serviceFee ?? "")"
                    self.taxesLbl.text = "$\(self.formatPrice(self.bookingDetailArr?.tax ?? ""))"
                    
                    if (self.bookingDetailArr?.cleaningFee ?? "0") == "0.00"{
                        self.view_CleaningFee.isHidden = true
                    }
                    else {
                        self.view_CleaningFee.isHidden = false
                        self.cleaningFeesLbl.text = "$\(self.formatPrice(self.bookingDetailArr?.cleaningFee ?? ""))" }
                    
                    if (self.bookingDetailArr?.addOnTotal ?? "0") == ""{
                        self.view_Addons.isHidden = true
                    } else {
                        self.view_Addons.isHidden = false
                        self.addOnsLbl.text = "$\(self.formatPrice(self.bookingDetailArr?.addOnTotal ?? "0"))" }
                    
                    if (self.bookingDetailArr?.discount ?? "0") == "0.00"{
                        self.view_Discount.isHidden = true
                    } else {
                        self.view_Discount.isHidden = false
                        self.lbl_Discount.text = "- $\(self.formatPrice(self.bookingDetailArr?.discount ?? "0"))" }
                    
                    self.totalLbl.text = "$\(self.formatPrice(self.bookingDetailArr?.bookingTotalAmount ?? ""))"
                    self.propertyNameLbl1.text = self.bookingDetailArr?.propertyTitle
                    self.bookingStatusBtn.setTitle("   \(self.bookingDetailArr?.bookingStatus ?? "")   ", for: .normal)
                    self.parkingRuleLbl.text = self.bookingDetailArr?.parkingRules
                    self.hostRuleLbl.text = self.bookingDetailArr?.hostRules
                    self.addressLbl.text = self.bookingDetailArr?.address
                    self.reviewCount.text = "Reviews (\(self.bookingDetailArr?.reviewsTotalCount ?? ""))"
                    self.ratingLbl.text = self.bookingDetailArr?.reviewsTotalRating
                    self.includeInBookingCollV.reloadData()
                    DispatchQueue.main.async {
                        self.adjustCollectionViewHeight()
                    }
                    let profileURL = AppURL.imageURL + (self.bookingDetailArr?.guestAvatar ?? "")
                    self.guestProfileImg.loadImage(from:profileURL,placeholder: UIImage(named: "NoIMg"))
                    
                    let imgURL = AppURL.imageURL + (self.bookingDetailArr?.images?[0] ?? "")
                    self.propertyImg.loadImage(from:imgURL,placeholder: UIImage(named: "NoIMg"))
                    self.imgbgV1.isHidden = true
                    self.imgbgV2.isHidden = true
                    self.imgbgV3.isHidden = true
                    if self.bookingDetailArr?.images?.count ?? 0 >= 3{
                        self.imgbgV1.isHidden = false
                        self.imgbgV2.isHidden = false
                        self.imgbgV3.isHidden = false
                        let imgURL1 = AppURL.imageURL + (self.bookingDetailArr?.images?[0] ?? "")
                        self.propertyImg1.loadImage(from:imgURL1,placeholder: UIImage(named: "NoIMg"))
                        let imgURL2 = AppURL.imageURL + (self.bookingDetailArr?.images?[1] ?? "")
                        self.propertyImg2.loadImage(from:imgURL2,placeholder: UIImage(named: "NoIMg"))
                        let imgURL3 = AppURL.imageURL + (self.bookingDetailArr?.images?[2] ?? "")
                        self.propertyImg3.loadImage(from:imgURL3,placeholder: UIImage(named: "NoIMg"))
                    }else if self.bookingDetailArr?.images?.count ?? 0 == 2{
                        self.imgbgV1.isHidden = false
                        self.imgbgV2.isHidden = false
                        let imgURL1 = AppURL.imageURL + (self.bookingDetailArr?.images?[0] ?? "")
                        self.propertyImg1.loadImage(from:imgURL1,placeholder: UIImage(named: "NoIMg"))
                        let imgURL2 = AppURL.imageURL + (self.bookingDetailArr?.images?[1] ?? "")
                        self.propertyImg2.loadImage(from:imgURL2,placeholder: UIImage(named: "NoIMg"))
                    }else if self.bookingDetailArr?.images?.count ?? 0 == 1{
                        self.imgbgV1.isHidden = false
                        let imgURL1 = AppURL.imageURL + (self.bookingDetailArr?.images?[0] ?? "")
                        self.propertyImg1.loadImage(from:imgURL1,placeholder: UIImage(named: "NoIMg"))
                    }
                    
                    self.items.removeAll()
                    self.items.append(contentsOf: [CustomBokingDetail(txt: self.bookingDetailArr?.bookingDate ?? "",img: UIImage(named: "calenderblackicon")),CustomBokingDetail(txt: "\(self.bookingDetailArr?.bookingHour ?? "") Hours",img: UIImage(named: "watchblackicon")),CustomBokingDetail(txt: "From \(self.bookingDetailArr?.bookingStartTime ?? "") to \(self.bookingDetailArr?.bookingEndTime ?? "")",img: UIImage(named: "watchblackicon")),CustomBokingDetail(txt: "$\(self.formatPrice(self.bookingDetailArr?.bookingAmount))",img: UIImage(named: "DollerImg"))])
                    
                    self.extendeditems.removeAll()
                    let extData = self.bookingDetailArr?.extensionDetails
                    
                    self.extendeditems.append(contentsOf: [CustomBokingDetail(txt: extData?.extensionDate ?? "",img: UIImage(named: "calenderblackicon")),CustomBokingDetail(txt: "\(extData?.extensionHours ?? 0) Hours",img: UIImage(named: "watchblackicon")),CustomBokingDetail(txt: "From \(extData?.extensionStartTime ?? "") to \(extData?.extensionEndTime ?? "")",img: UIImage(named: "watchblackicon")),CustomBokingDetail(txt: "$\(self.formatPrice(extData?.extensionAmount))",img: UIImage(named: "DollerImg"))])
                    
                    self.createTagCloud(OnView: self.bookingDetailView, withArray: self.items, heightOf_Chip: self.bookingVHightCon)
                    self.createTagCloud(OnView: self.BTEbookingDetailView, withArray: self.extendeditems, heightOf_Chip: self.BTEbookingVHightCon)
                  
                    if self.bookingDetailArr?.latitude != "" && self.bookingDetailArr?.longitude != ""{
                        guard let latString = self.bookingDetailArr?.latitude,
                              let longString = self.bookingDetailArr?.longitude,
                              let latitude = Double(latString),
                              let longitude = Double(longString),
                              latitude != 0.0, longitude != 0.0 else {
                            print("Invalid coordinates")
                            return
                        }
                        // Set up Google Map wi th valid coordinates
                        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
                        // Initialize GMSMapView and set its frame to match mapView's bounds
                        let googleMapView = GMSMapView(frame: self.mapView.bounds, camera: camera)
                        googleMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                        self.mapView.isUserInteractionEnabled = false
                        self.mapView.addSubview(googleMapView)
                        
                        // Add a marker (pin)
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        //                       marker.title = "Booking Location"
                        marker.snippet = "Latitude: \(latitude), Longitude: \(longitude)"
                        marker.map = googleMapView
                        
                        googleMapView.animate(to: camera)
                    }
                    self.bookingDetailViewModel.HostGetBookingReview(propertyId: self.bookingDetailArr?.propertyID ?? 0, filter: "highest_review", page: self.pageCount)
                })
            }.store(in: &cancellables)
        
        viewModel.$getJoinChannelResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.getJoinChannelDetails = response.data
                    let senderID =  self.getJoinChannelDetails?.senderID ?? ""
                    let receiverID =  self.getJoinChannelDetails?.receiverID ?? ""
                    let guestIMG = self.getJoinChannelDetails?.senderAvatar ?? ""
                    self.guestProfileImg1 = AppURL.imageURL + guestIMG
                    let HostIMG = self.getJoinChannelDetails?.receiverAvatar ?? ""
                    self.hostProfileImg = AppURL.imageURL + HostIMG
                    // let stryB = UIStoryboard(name: "Chat", bundle: nil)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostChatVC") as! HostChatVC
                    print(self.Message,"self.Message")
                    vc.Message = self.Message
                    vc.uniqueConversationName = self.channelName
                    vc.friend_id = "\(receiverID)"
                    vc.hostProfileImg = self.hostProfileImg
                    vc.guesttProfileImg =  self.guestProfileImg1
                    vc.guestName = self.getJoinChannelDetails?.receiverName ?? ""
                    vc.hostName = self.getJoinChannelDetails?.senderName ?? ""
                    self.tabBarController?.tabBar.isHidden = true
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_GetReviews(){
        bookingDetailViewModel.$getReviewsResult
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    let peginationData = response.pagination
                    if peginationData?.currentPage == peginationData?.totalPages{
                        self.btnshowMore.isHidden = true
                    }else{
                        self.btnshowMore.isHidden = false
                    }
                    self.reviewDataArr = response.data ?? []
                    self.tblV.reloadData()
                })
            }.store(in: &cancellables)
    }
    
}
extension HostBookingAVC{
    func formatPrice(_ priceString: String?) -> String {
        guard let priceString = priceString,
              let priceDouble = Double(priceString) else {
            return "0"
        }
        let formatted: String
        if priceDouble.truncatingRemainder(dividingBy: 1) == 0 {
            formatted = String(format: "%.0f", priceDouble) // Remove .00
        } else {
            formatted = String(format: "%.2f", priceDouble) // Keep decimals
        }
        return "\(formatted)"
    }
}
