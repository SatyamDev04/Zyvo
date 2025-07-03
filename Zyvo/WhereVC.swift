//
//  WhereVC.swift
//  Zyvo
//
//  Created by ravi on 25/10/24.
//

import UIKit
import FSCalendar
import GooglePlaces
import Combine

class WhereVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance,UITextFieldDelegate, CircularSeekBarDelegate, GMSAutocompleteFetcherDelegate  {
    
    
    @IBOutlet weak var view_Calendar: UIView!
    @IBOutlet weak var whereLbl: UILabel!
    @IBOutlet weak var time2Lbl: UILabel!
    @IBOutlet weak var whereLocationTF: UITextField!
    @IBOutlet weak var tblV_Location: UITableView!
    @IBOutlet weak var view_Watch: CircularSeekBar!
    @IBOutlet weak var view_Time: UIView!
    @IBOutlet weak var time1Lbl: UILabel!
    @IBOutlet weak var view_DateFrom: UIView!
    @IBOutlet weak var view_DateTo: UIView!
    @IBOutlet weak var btnFlexible: UIButton!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var btnNextMonth: UIButton!
    @IBOutlet weak var btnPrevMoth: UIButton!
    @IBOutlet weak var btnDates: UIButton!
    @IBOutlet weak var scrollV: UIScrollView!
    var comeFrom = ""
    @IBOutlet weak var view_CleanAll: UIView!
    @IBOutlet weak var view_DataActivity: UIView!
    @IBOutlet weak var view_Activity: UIView!
    @IBOutlet weak var view_MainSelectDatehourly: UIView!
    @IBOutlet weak var btnHourly: UIButton!
    @IBOutlet weak var view_TapTimeDateFlexible: UIView!
    @IBOutlet weak var view_Addtime: UIView!
    @IBOutlet weak var view_Location: UIView!
    @IBOutlet weak var view_where: UIView!
    @IBOutlet weak var view_Search: UIView!
    
    @IBOutlet weak var lbl_ActivityTitle: UILabel!
    @IBOutlet weak var lbl_Stay: UILabel!
    @IBOutlet weak var lbl_EventSpace: UILabel!
    @IBOutlet weak var lbl_PhotoShoot: UILabel!
    @IBOutlet weak var lbl_Meeting: UILabel!
    @IBOutlet weak var lbl_Party: UILabel!
    @IBOutlet weak var lbl_FilmShoot: UILabel!
    @IBOutlet weak var lbl_Performance: UILabel!
    @IBOutlet weak var lbl_Wokshop: UILabel!
    
    private var viewModel = HomeDataViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var getHomeDataArr : [HomeDataModel]?
    
    var getFilterDataArr : [HomeDataModel]?
    
    var FilterStatus = ""
    
    var backAction:(_ str : [HomeDataModel]?, _  str1 : String ) -> () = { str, str1  in}
    
    var countMonth = 0
    
    var fetcher: GMSAutocompleteFetcher!
    var predictions = [GMSAutocompletePrediction]()
    
    var ActivityType = ""
    var isActivityOpen = "false"
    var latitude = ""
    var longitude = ""
    var datess = ""
    var hours = ""
    var SelectedDate = ""
    var StartDatetime = ""
    var startTime = ""
    var endTime = ""
    var EndDatetime = ""
    var bookingHours : Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let WhereLocation = WhereSaveData.shared.WhereLocation
        
        if WhereLocation != "" {
            whereLocationTF.text = WhereLocation
        }
        
        let latt = WhereSaveData.shared.lat
        
        if latt != "" {
            self.latitude = latt
            viewModel.latitude = self.latitude
        }
        
        let longg = WhereSaveData.shared.long
        
        if longg != "" {
            self.longitude = longg
            viewModel.longitude = self.longitude
        }
        
        let activitytype = WhereSaveData.shared.ActivityType
        
        if activitytype != "" {
            lbl_ActivityTitle.text = activitytype
        }
        let start_Time = WhereSaveData.shared.startTime
        if start_Time != "" {
            time1Lbl.text = start_Time
        }
        let end_Time = WhereSaveData.shared.endTime
        if end_Time != "" {
            time2Lbl.text = end_Time
        }
        SelectedDate = WhereSaveData.shared.selectedDate
        if SelectedDate != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let futureDate = formatter.date(from: SelectedDate) {
                calendarView.select(futureDate)
                calendarView.setCurrentPage(futureDate, animated: true)
            }
        } else {
            // Select the current date automatically
            let currentDate = Date()
            calendarView.select(currentDate)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.SelectedDate = formatter.string(from: currentDate)
            print("Auto-selected date: \(self.SelectedDate)")
        }
        
        var hourss =  WhereSaveData.shared.bookingHours
        if hourss != 0 {
            view_Watch.setHour(hourss)
        }
        calendarView.appearance.todayColor = .clear
        btnDates.layer.cornerRadius = btnDates.layer.frame.height / 2
        btnDates.backgroundColor = UIColor.white
        btnHourly.backgroundColor = UIColor.clear
        btnFlexible.backgroundColor = UIColor.clear
        
        bindVC()
        
        setupTapGesture(for: lbl_Stay)
        setupTapGesture(for: lbl_EventSpace)
        setupTapGesture(for: lbl_PhotoShoot)
        
        setupTapGesture(for: lbl_Meeting)
        setupTapGesture(for: lbl_Party)
        setupTapGesture(for: lbl_FilmShoot)
        
        setupTapGesture(for: lbl_Performance)
        setupTapGesture(for: lbl_Wokshop)
        
        view_Watch.delegate = self
        
        whereLocationTF.delegate = self
        calendarView.isHidden = true
        view_Calendar.isHidden = true
        
        // Initialize Google Autocomplete Fetcher
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter // You can change this to .address, .establishment, etc.
        
        fetcher = GMSAutocompleteFetcher(filter: filter)
        fetcher.delegate = self
        self.whereLocationTF.delegate = self
        
        
        let cell = UINib(nibName: "NewLocationCell", bundle: nil)
        tblV_Location.register(cell, forCellReuseIdentifier: "NewLocationCell")
        tblV_Location.delegate = self
        tblV_Location.dataSource = self
        calendarView.placeholderType = .none
        calendarView.delegate = self
        calendarView.dataSource = self
       
        calendarView.bringSubviewToFront(btnNextMonth)
        calendarView.bringSubviewToFront(btnPrevMoth)
        if comeFrom == "Where" {
            view_where.isHidden = false
            view_Location.isHidden = true
            view_Addtime.isHidden = false
            view_MainSelectDatehourly.isHidden = true
            view_Calendar.isHidden = false
            view_Activity.isHidden = false
            view_DataActivity.isHidden = true
            view_Time.isHidden = true
            view_Watch.isHidden = true
        }else if comeFrom == "Time" {
            view_where.isHidden = false
            view_Addtime.isHidden = false
            view_Activity.isHidden = false
            view_Location.isHidden = true
            view_MainSelectDatehourly.isHidden = false
            view_Calendar.isHidden = true
            view_DataActivity.isHidden = true
            view_Time.isHidden = true
            view_Watch.isHidden = true
            view_Calendar.isHidden = false
            calendarView.isHidden = false
        } else if comeFrom == "Activity" {
            view_where.isHidden = false
            view_Location.isHidden = true
            view_Addtime.isHidden = false
            view_MainSelectDatehourly.isHidden = true
            view_Activity.isHidden = false
            view_DataActivity.isHidden = false
            view_Time.isHidden = true
            view_Watch.isHidden = true
        }
        view_DateFrom.layer.borderWidth = 1
        view_DateFrom.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_DateFrom.layer.cornerRadius = 25
        view_DateTo.layer.borderWidth = 1
        view_DateTo.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_DateTo.layer.cornerRadius = 25
        view_DataActivity.layer.borderWidth = 1.5
        view_DataActivity.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_DataActivity.layer.cornerRadius = 10
        view_Activity.layer.borderWidth = 1.5
        view_Activity.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Activity.layer.cornerRadius = 10
        
        view_MainSelectDatehourly.layer.borderWidth = 1.5
        view_MainSelectDatehourly.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_MainSelectDatehourly.layer.cornerRadius = 10
        
        view_Addtime.layer.borderWidth = 1.5
        view_Addtime.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Addtime.layer.cornerRadius = 10
        
        view_Location.layer.borderWidth = 1.5
        view_Location.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Location.layer.cornerRadius = 10
        
        view_where.layer.borderWidth = 1.5
        view_where.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_where.layer.cornerRadius = 10
        
        
        view_TapTimeDateFlexible.layer.cornerRadius = view_TapTimeDateFlexible.layer.frame.height / 2
        
        btnHourly.layer.cornerRadius = btnHourly.layer.frame.height / 2
        
        view_CleanAll.layer.borderWidth = 1.5
        view_CleanAll.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_CleanAll.layer.cornerRadius = view_CleanAll.layer.frame.height / 2
        view_Search.layer.borderWidth = 1.5
        view_Search.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2
        
        viewModel.latitude = self.latitude
        viewModel.longitude = self.longitude
        
    }
    
    func setupTapGesture(for label: UILabel) {
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        label.addGestureRecognizer(tapGesture)
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        print(label.text)
        
        if let title = label.text {
            print(title)
            switch title {
            case "Stays":
                print("Stays One tapped")
                // Handle action for Label One
                self.ActivityType = "Stays"
            case "Event Space":
                print("Event Space tapped")
                // Handle action for Label Two
                self.ActivityType = "Event Space"
            case "Photo Shoot":
                print("Photo Shoot tapped")
                // Handle action for Label Three
                self.ActivityType = "Photo Shoot"
                
            case "Meeting":
                print("Meeting tapped")
                // Handle action for Label Three
                self.ActivityType = "Meeting"
            case "Party":
                print("Party tapped")
                // Handle action for Label Three
                self.ActivityType = "Party"
            case "Film Shoot":
                print("Film Shoot tapped")
                // Handle action for Label Three
                self.ActivityType = "Film Shoot"
            case "Performance":
                print("Performance tapped")
                // Handle action for Label Three
                self.ActivityType = "Performance"
            case "Workshop":
                print("Workshop  tapped")
                // Handle action for Label Three
                self.ActivityType = "Workshop"
            default:
                break
            }
            
        }
        WhereSaveData.shared.ActivityType = self.ActivityType
        self.lbl_ActivityTitle.text = self.ActivityType
        isActivityOpen = "false"
        self.view_DataActivity.isHidden = true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        fetcher?.sourceTextHasChanged(searchText)
        return true
    }
    
    // MARK: - GMSAutocompleteFetcherDelegate
    @objc(didAutocompleteWithPredictions:) func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.predictions = predictions
        
        self.tblV_Location.reloadData()
        
    }
    
    @objc func didFailAutocompleteWithError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    
    @IBAction func timeDropBtn(_ sender: UITextField){
        if sender.isSelected == false{
            sender.isSelected = true
            view_MainSelectDatehourly.isHidden = false
            view_Calendar.isHidden = false
            view_Time.isHidden = true
            view_Watch.isHidden = true
            calendarView.isHidden = false
            view_Calendar.isHidden = false
            
        }else{
            sender.isSelected = false
            view_MainSelectDatehourly.isHidden = true
            view_Calendar.isHidden = true
            view_Watch.isHidden = true
            view_Time.isHidden = true
            calendarView.isHidden = true
        }
    }
    
    @IBAction func activityDropBtn(_ sender: UIButton){
        if  isActivityOpen == "false" {
            isActivityOpen = "true"
            view_DataActivity.isHidden = false
        }else{
            isActivityOpen = "false"
            view_DataActivity.isHidden = true
        }
    }
    // MARK: - CircularSeekBarDelegate
    func circularSeekBarDidStartDragging() {
        scrollV.isScrollEnabled = false
    }
    
    func circularSeekBarDidEndDragging() {
        scrollV.isScrollEnabled = true
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return .black // Set the text color for all dates
    }
    
    // MARK: - FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        print("Selected date: \(formatter.string(from: date))")
        
        self.SelectedDate = "\(formatter.string(from: date))"
        WhereSaveData.shared.selectedDate = self.SelectedDate
        
    }
    
    func didUpdateCenterLabel(Hours :String) {
        print(Hours,"")
        
        let hoursInt = Int(Hours )
        self.bookingHours = hoursInt
        WhereSaveData.shared.bookingHours = hoursInt ?? 0
        print(hoursInt ?? 0,"hoursInt")
        
        
    }
    @IBAction func btnSearch_Tap(_ sender: UIButton) {
        
        viewModel.latitude = self.latitude
        viewModel.longitude = self.longitude
        viewModel.start_time = self.StartDatetime
        viewModel.end_time = self.EndDatetime
        viewModel.hourss = bookingHours ?? 0
        viewModel.datss =  self.SelectedDate
        viewModel.locationss = self.whereLocationTF.text ?? ""
        viewModel.activity = self.ActivityType
        WhereSaveData.shared.ActivityType = self.ActivityType
        WhereSaveData.shared.WhereLocation = self.whereLocationTF.text ?? ""
        WhereSaveData.shared.StartDatetime = self.StartDatetime
        WhereSaveData.shared.EndDatetime = self.EndDatetime
        WhereSaveData.shared.startTime = self.startTime
        WhereSaveData.shared.endTime = self.endTime
        WhereSaveData.shared.selectedDate = self.SelectedDate
        WhereSaveData.shared.lat = self.latitude
        WhereSaveData.shared.long = self.longitude
        viewModel.apiforGetHomeData()
    }
    
    @IBAction func btnCleanAll_Tap(_ sender: UIButton) {
        
        self.FilterStatus = "Clear"
        self.view_Watch.setHour(2)
        WhereSaveData.shared.clearData()
        calendarView.reloadData()
        
        calendarView.appearance.todayColor = nil
        calendarView.appearance.titleTodayColor = calendarView.appearance.titleDefaultColor
        
        // 1. Deselect currently selected date (if any)
        if let selectedDate = calendarView.selectedDate {
            calendarView.deselect(selectedDate)
        }
        
        // 2. Select today's date
        let today = Date()
        calendarView.select(today)
        
        // 3. Scroll calendar to today's month (optional)
        calendarView.setCurrentPage(today, animated: true)
        whereLocationTF.text = ""
        self.lbl_ActivityTitle.text = "Activity"
        self.time1Lbl.text = "Start Time"
        self.time2Lbl.text = "End Time"
        self.StartDatetime = ""
        self.EndDatetime = ""
        self.SelectedDate = ""
        self.latitude = ""
        self.longitude = ""
        self.bookingHours = 0
        self.getFilterDataArr?.removeAll()
        self.dismiss(animated: true){
            self.backAction(self.getFilterDataArr,  self.FilterStatus)
        }
        
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
        self.calendarView.setCurrentPage(currentPage, animated: true)
        
    }
    @IBAction func btnPreviousMonth_Tap(_ sender: UIButton) {
        print("Back")
        let _calendar = Calendar.current
        var dateComponents = DateComponents()
        countMonth -= 1
        dateComponents.month = countMonth
        let currentPage = _calendar.date(byAdding: dateComponents, to: Date())!
        self.calendarView.setCurrentPage(currentPage, animated: true)
        
    }
    
    @IBAction func btnFlexible_Tap(_ sender: UIButton) {
        self.StartDatetime = ""
        self.EndDatetime = ""
        view_Time.isHidden = false
        calendarView.isHidden = false
        view_Calendar.isHidden = false
        view_Watch.isHidden = true
        btnFlexible.layer.cornerRadius = btnFlexible.layer.frame.height / 2
        btnFlexible.backgroundColor = UIColor.white
        btnHourly.backgroundColor = UIColor.clear
        btnDates.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnHourly_Tap(_ sender: UIButton) {
        self.StartDatetime = ""
        self.EndDatetime = ""
        calendarView.isHidden = true
        view_Calendar.isHidden = true
        view_Time.isHidden = true
        view_Watch.isHidden = false
        btnHourly.layer.cornerRadius = btnHourly.layer.frame.height / 2
        btnHourly.backgroundColor = UIColor.white
        btnFlexible.backgroundColor = UIColor.clear
        btnDates.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnDates_Tap(_ sender: UIButton) {
        
        // Select the current date automatically
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.SelectedDate = formatter.string(from: currentDate)
        print("Auto-selected date: \(self.SelectedDate)")
        calendarView.reloadData()
        
        self.StartDatetime = ""
        self.EndDatetime = ""
        view_Time.isHidden = true
        view_Watch.isHidden = true
        
        calendarView.isHidden = false
        view_Calendar.isHidden = false
        btnDates.layer.cornerRadius = btnDates.layer.frame.height / 2
        btnDates.backgroundColor = UIColor.white
        btnHourly.backgroundColor = UIColor.clear
        btnFlexible.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            self.backAction(self.getFilterDataArr,  self.FilterStatus)
        }
        
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
        
        // Set 24-hour format or 12-hour format based on locale
        datePicker.locale = Locale(identifier: "en_US") // 12-hour format
        // datePicker.locale = Locale(identifier: "en_GB") // 24-hour format
        
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
            
            // Format time in 12-hour format
            let formatter12Hour = DateFormatter()
            formatter12Hour.dateFormat = "hh:mm a" // 12-hour format with AM/PM
            formatter12Hour.amSymbol = "AM"
            formatter12Hour.pmSymbol = "PM"
            
            // Format time in 24-hour format
            let formatter24Hour = DateFormatter()
            formatter24Hour.dateFormat = "HH:mm:ss" //"HH:mm" // 24-hour format
            
            let time12Hour = formatter12Hour.string(from: selectedTime)
            let time24Hour = formatter24Hour.string(from: selectedTime)
            
            print("Selected Time (12-hour): \(time12Hour)") // Example: "02:30 PM"
            print("Selected Time (24-hour): \(time24Hour)") // Example: "14:30"
            
            self.time1Lbl.text = time12Hour
            
            self.StartDatetime = self.SelectedDate + " \(time24Hour)"
            self.startTime = time12Hour
            
            WhereSaveData.shared.StartDatetime = self.StartDatetime
            WhereSaveData.shared.startTime = self.startTime
            
            let startTimeString = time12Hour // Convert Date to String
            
            if let endTime = self.calculateEndTime(startTime: startTimeString, hoursToAdd: self.bookingHours ?? 0) {
                print("End Time (12-hour): \(endTime)")
                // Convert end time to 24-hour format
                if let endDate = formatter12Hour.date(from: endTime) {
                    let endTime24Hour = formatter24Hour.string(from: endDate)
                    print("End Time (24-hour): \(endTime24Hour)")
                    self.endTime = endTime
                    self.time2Lbl.text = endTime
                    self.EndDatetime = "\(self.SelectedDate) \(endTime24Hour)"
                    WhereSaveData.shared.EndDatetime = self.EndDatetime
                    WhereSaveData.shared.endTime = self.endTime
                }
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
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.whereLocationTF.textAlignment = .right
        self.view_Location.isHidden = false
        self.whereLocationTF.backgroundColor = UIColor.white
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if whereLocationTF.text == ""{
            self.whereLocationTF.backgroundColor = UIColor.clear
            self.whereLocationTF.textAlignment = .right
        }
        self.view_Location.isHidden = true
    }
}


extension WhereVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  predictions.count//arrOtherActivityTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV_Location.dequeueReusableCell(withIdentifier: "NewLocationCell", for: indexPath) as! NewLocationCell
        cell.locationLbl.text = predictions[indexPath.row].attributedPrimaryText.string
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected at index \(indexPath.row)") // Debugging statement
        DispatchQueue.main.async {
            
            let prediction = self.predictions[indexPath.row]
            let placeID = prediction.placeID
            
            let placesClient = GMSPlacesClient.shared()
            placesClient.fetchPlace(fromPlaceID: placeID, placeFields: [.coordinate], sessionToken: nil) { (place, error) in
                if let error = error {
                    print("Error fetching place details: \(error.localizedDescription)")
                    return
                }
                
                if let place = place {
                    let latitude = place.coordinate.latitude
                    let longitude = place.coordinate.longitude
                    print("Latitude: \(latitude), Longitude: \(longitude)")
                    self.latitude = "\(latitude)"
                    self.longitude = "\(longitude)"
                    self.whereLocationTF.text = prediction.attributedPrimaryText.string
                    self.view_Location.isHidden = true
                    WhereSaveData.shared.WhereLocation = self.whereLocationTF.text ?? ""
                    WhereSaveData.shared.lat = self.latitude
                    WhereSaveData.shared.long = self.longitude
                    self.whereLocationTF.resignFirstResponder()
                    
                }
            }
        }
    }
}

extension WhereVC {
    func bindVC() {
        viewModel.$getHomeDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.getFilterDataArr?.removeAll()
                    
                    self.getFilterDataArr = response.data
                    print(self.getFilterDataArr ?? [],"HOME DATA YAHI HAI")
                    
                    if response.success == true {
                        self.getFilterDataArr = response.data ?? []
                        
                        if self.getFilterDataArr?.count == 0 {
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            self.FilterStatus = "yes"
                            self.backAction(self.getFilterDataArr,  self.FilterStatus)
                            self.dismiss(animated: true)
                        }
                    } else {
                        self.FilterStatus = "yes"
                        self.backAction(self.getFilterDataArr, self.FilterStatus)
                        self.dismiss(animated: true)
                    }
                })
            }.store(in: &cancellables)
    }
}

