//
//  HostPropertiesHomeVC.swift
//  Zyvo
//
//  Created by ravi on 26/12/24.
//

import UIKit
import DropDown
import Combine
import CoreLocation

class HostPropertiesHomeVC: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var view_Balance: UIView!
    @IBOutlet weak var collecV: UICollectionView!
    @IBOutlet weak var collecV_H: NSLayoutConstraint!
    @IBOutlet weak var earningAmountLbl: UILabel!
    let locationManager = CLLocationManager()
    let filterDropdown = DropDown()
    var type = "total"
    var filtersArr = ["   Total earning","   Future earning"]
    private var cancellables = Set<AnyCancellable>()
    private var EarningViewModel = HostEarningViewModel()
    private var viewModel = PropertyListViewModel()
    var propertyDataArr = [PropertyListModel]()
    let dotDropdown = DropDown()
    var dotArr = ["     Edit","     Delete"]
    var lat : Double?
    var lot : Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
        bindVC_ForEarningData()
        view_Balance.layer.cornerRadius = view_Balance.layer.frame.height / 2
        view_Balance.layer.borderWidth = 1
        view_Balance.layer.borderColor = UIColor.init(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
        let nib2 = UINib(nibName: "PlaceCell", bundle: nil)
        collecV?.register(nib2, forCellWithReuseIdentifier: "PlaceCell")
        collecV.delegate = self
        collecV.dataSource = self
        collecV.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        EarningViewModel.getHostEarning(type: self.type, hostID: UserDetail.shared.getUserId())
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewHeight()
    }
    
    private func updateCollectionViewHeight() {
        // Calculate the number of rows needed
        let numberOfItems = collectionView(collecV, numberOfItemsInSection: 0)
        let itemsPerRow: CGFloat = 1
        let rows = ceil(CGFloat(numberOfItems) / itemsPerRow)
        // Set the item height and spacing
        let itemHeight: CGFloat = 370
        let padding: CGFloat = 10
        let totalPadding = (rows - 1) * padding
        let totalHeight = rows * itemHeight + totalPadding
        // Update the collection view height constraint
        collecV_H.constant = totalHeight
    }
    
    @IBAction func btnInfo(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Host", bundle: nil)
        let popoverContent = storyboard.instantiateViewController(withIdentifier: "InfoPopVC") as! InfoPopVC
        popoverContent.msg = "Future Earnings-\nTotal earnings - This is calculated by aggregating all earnings since the host signed up on Zyvo till the date shown (Dynamic Real Time Updates is expected)\nFuture Earnings - This filter dynamically calculates and updates the amount shown to reflect the total revenue that hosts are expected to earn from existing future bookings over the next 90 days. It provides hosts with a real-time snapshot of their anticipated earnings from confirmed bookings during the specified timeframe.\n\nNote: This filter's content is dynamic and adjusts in real-time as new bookings are confirmed or existing bookings are modified within the 90-day window.\n- Hosts can view changes to their future earnings and associated properties as bookings are added, updated, or canceled, providing them with an up-to-date overview of their upcoming revenue stream."
        popoverContent.modalPresentationStyle = .popover
        
        if let popover = popoverContent.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds // Attach to the button bounds
            popover.permittedArrowDirections = .up // Force the popover to show below the button
            popover.delegate = self
            popoverContent.preferredContentSize = CGSize(width: 350, height: 300)
        }
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Ensures the popover does not change to fullscreen on compact devices.
    }
    
    @IBAction func btnAddNewPlace_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostPlaceMngmntVC") as! HostPlaceMngmntVC
        SingltonClass.shared.typeOfSpace = "entire_home"
        SingltonClass.shared.propertySize = "0"
        SingltonClass.shared.no_Of_Ppl = "0"
        SingltonClass.shared.bedrooms = "0"
        SingltonClass.shared.bathrooms = "0"
        SingltonClass.shared.activies.removeAll()
        SingltonClass.shared.other_Activities.removeAll()
        SingltonClass.shared.aminities.removeAll()
        SingltonClass.shared.instantBooking = "0"
        SingltonClass.shared.selfCheck_in = "0"
        SingltonClass.shared.allowPets = "0"
        SingltonClass.shared.cancellationDays = ""
        SingltonClass.shared.Imgs = []
        SingltonClass.shared.title = ""
        SingltonClass.shared.about = "Optional"
        SingltonClass.shared.parkingRule = "Optional"
        SingltonClass.shared.hostRules = "Optional"
        SingltonClass.shared.street = ""
        SingltonClass.shared.city = ""
        SingltonClass.shared.zipcode = ""
        SingltonClass.shared.country = ""
        SingltonClass.shared.state = ""
        SingltonClass.shared.latitude = 0.0
        SingltonClass.shared.longitude = 0.0
        SingltonClass.shared.miniHrsPric_HrsMini = "1"
        SingltonClass.shared.miniHrsPric_perHrs = "10"
        SingltonClass.shared.bulkDis_HrsMini = "1"
        SingltonClass.shared.bulkDis_Discount = "15"
        SingltonClass.shared.addCleaningFees = ""
        SingltonClass.shared.avilabilityMonth = "all"
        SingltonClass.shared.avilabilityDays = "all"
        SingltonClass.shared.avilabilityHrsFrom = ""
        SingltonClass.shared.avilabilityHrsTo = ""
        SingltonClass.shared.addOns.removeAll()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnfilter_Tap(_ sender: UIButton) {
        // Set up the dropdown
        filterDropdown.anchorView = sender // Anchor dropdown to the button
        filterDropdown.dataSource = filtersArr
        filterDropdown.direction = .bottom
        
        filterDropdown.backgroundColor = UIColor.white
        filterDropdown.cornerRadius = 10
        filterDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        filterDropdown.layer.shadowColor = UIColor.gray.cgColor
        filterDropdown.layer.shadowOpacity = 0.2
        filterDropdown.layer.shadowRadius = 10
        filterDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = filterDropdown.anchorView?.plainView.bounds.height {
            filterDropdown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        // Customize cells
        filterDropdown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        // Handle selection
        filterDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected month: \(item)")
            if index == 0{
                self.type = "total"
            }else{
                self.type = "future"
            }
            EarningViewModel.getHostEarning(type: self.type, hostID: UserDetail.shared.getUserId())
            // Perform any further actions as needed
        }
        // Show dropdown
        filterDropdown.show()
    }
}
extension HostPropertiesHomeVC :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return propertyDataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collecV.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
        cell.hostedByLbl.text = "Hosted by \(propertyDataArr[indexPath.item].fname ?? "") \(propertyDataArr[indexPath.item].lname ?? "")"
        cell.addressLbl.text = propertyDataArr[indexPath.item].address
        let imgURL = AppURL.imageURL + (propertyDataArr[indexPath.row].profileImage ?? "")
        cell.HostedByImg.loadImage(from:imgURL,placeholder: UIImage(named: "NoIMg"))
        cell.titleLbl.text = propertyDataArr[indexPath.item].title
        cell.milesLbl.text = "\(propertyDataArr[indexPath.item].distanceMiles ?? "") miles away"
        cell.totalRatingCount.text = "(\(propertyDataArr[indexPath.item].propertyReviewCount ?? ""))"
        cell.ratingLbl.text = propertyDataArr[indexPath.item].propertyRating
        let stringNumber = propertyDataArr[indexPath.item].hourlyRate ?? ""
        if let doubleValue = Double(stringNumber) {
            let intValue = Int(doubleValue)
            let result = String(intValue)
            cell.pricePerHourLbl.text = "$\(result)/h"
        }
        
        cell.btnDot.tag = indexPath.row
        cell.imgArr = propertyDataArr[indexPath.item].propertyImages ?? []
        cell.collecV.reloadData()
        
        if propertyDataArr[indexPath.item].isInstantBook == 1 {
            cell.view_Instant.isHidden = false
        }else {
            cell.view_Instant.isHidden = true
        }
        
        //        cell.btnHeart.tag = indexPath.row
        cell.btnDot.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        // Handle selection from inner collection view
        cell.didSelectItem = { [weak self] innerIndexPath in
            guard let self = self else { return }
            print("Selected item at outer index: \(indexPath.item), inner index: \(innerIndexPath.item)")
            
            // Example: Navigate to a new view controller
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewListingVC") as! CreateNewListingVC
            vc.propertyID = self.propertyDataArr[indexPath.item].propertyID
            vc.lat = self.lat
            vc.lot = self.lot
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Heloo")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewListingVC") as! CreateNewListingVC
        vc.propertyID = self.propertyDataArr[indexPath.item].propertyID
        vc.lat = self.lat
        vc.lot = self.lot
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // Set up the dropdown
        dotDropdown.anchorView = sender // Anchor dropdown to the button
        dotDropdown.dataSource = dotArr
        dotDropdown.direction = .bottom
        
        dotDropdown.backgroundColor = UIColor.white
        dotDropdown.cornerRadius = 10
        dotDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        dotDropdown.layer.shadowColor = UIColor.gray.cgColor
        dotDropdown.layer.shadowOpacity = 0.2
        dotDropdown.layer.shadowRadius = 10
        dotDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // Set the width of the dropdown
        if let anchorView = dotDropdown.anchorView?.plainView {
            dotDropdown.width = anchorView.frame.width + 60// Match the width of the anchor view
        }
        if let anchorHeight = dotDropdown.anchorView?.plainView.bounds.height {
            dotDropdown.bottomOffset = CGPoint(x: -80, y: anchorHeight)
        }
        // Customize cells
        dotDropdown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        
        // Handle selection
        dotDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected: \(item)")
            var iselect = "\(item)"
            if index == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeletePropertyVC") as! DeletePropertyVC
                vc.propertyId = propertyDataArr[sender.tag].propertyID ?? 0
                self.navigationController?.present(vc, animated: true)
            }else{
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "HostPlaceMngmntVC") as! HostPlaceMngmntVC
                nextVC.comesFrom = "edit"
                nextVC.propertyId = propertyDataArr[sender.tag].propertyID ?? 0
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            // Perform any further actions as needed
        }
        // Show dropdown
        dotDropdown.show()
    }
}
extension HostPropertiesHomeVC:UICollectionViewDelegateFlowLayout {
    // UICollectionViewDelegateFlowLayout method to set cell size
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the width based on screen size, subtracting padding or spacing as needed
        let padding: CGFloat = 5  // Example padding (adjust as needed)
        let collectionViewWidth = collectionView.frame.width - padding
        let cellWidth = collectionViewWidth / 1  // Display 2 cells per row
        
        // Return the size with fixed height of 120
        return CGSize(width: cellWidth, height: 370)
    }
}

extension HostPropertiesHomeVC {
 func bindVC() {
        viewModel.$getPropertyListResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.propertyDataArr.removeAll()
                    self.propertyDataArr = response.data ?? []
                    print(self.propertyDataArr,"HOME DATA YAHI HAI")
                    self.collecV.reloadData()
                    self.updateCollectionViewHeight()
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_ForEarningData() {
        EarningViewModel.$getEarningsResult
               .receive(on: DispatchQueue.main)
               .sink { [weak self] result in
                   guard let self = self else{return}
                   result?.handle(success: { response in
                       let data = response.data
                       self.earningAmountLbl.text = "$\(data?.amount ?? "")"
                   })
               }.store(in: &cancellables)
       }
    
}

extension HostPropertiesHomeVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            locationManager.stopUpdatingLocation()
            self.lat = latitude
            self.lot = longitude
            viewModel.apiforGetAllPropertyData(lat: latitude, lot: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
