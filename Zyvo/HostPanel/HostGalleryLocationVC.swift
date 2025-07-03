//
//  HostGalleryLocationVC.swift
//  Zyvo
//
//  Created by ravi on 31/12/24.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Combine

class HostGalleryLocationVC: UIViewController,GMSMapViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var viewMainMap: UIView!
    @IBOutlet weak var view_Title: UIView!
    @IBOutlet weak var view_Street: UIView!
    @IBOutlet weak var view_city: UIView!
    @IBOutlet weak var view_zipcode: UIView!
    @IBOutlet weak var view_state: UIView!
    @IBOutlet weak var view_Country: UIView!
    @IBOutlet weak var imgCollV: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var view_DescTitle: UIView!
    @IBOutlet weak var view_ParkingRules: UIView!
    @IBOutlet weak var view_HostRules: UIView!
    @IBOutlet weak var mainStackV: UIStackView!
    
    @IBOutlet weak var aboutSpaceTitleTF: UITextField!
    @IBOutlet weak var aboutSpaceDesTV: UITextView!
    @IBOutlet weak var parkingRuleDesTV: UITextView!
    @IBOutlet weak var hostRuleDesTV: UITextView!
    
    @IBOutlet weak var streeTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var zipcodeTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var mapV: GMSMapView!
    let marker = GMSMarker()
    
    var selectedImages: [imageArray] = []
    var latitude = ""
    var longitude = ""
    var locationn = ""
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapV.delegate = self
       //self.mapV.isUserInteractionEnabled = false
        aboutSpaceDesTV.textColor = .black
        aboutSpaceDesTV.delegate = self
        parkingRuleDesTV.textColor = .black
        parkingRuleDesTV.delegate = self
        hostRuleDesTV.textColor = .black
        hostRuleDesTV.delegate = self
        view_Country.applyRoundedStyle()
        view_state.applyRoundedStyle()
        view_zipcode.applyRoundedStyle()
        view_city.applyRoundedStyle()
        view_Street.applyRoundedStyle()
        view_Title.applyRoundedStyle()
        
        view_DescTitle.applyRoundedStyle(cornerRadius: 10)
        view_ParkingRules.applyRoundedStyle(cornerRadius: 10)
        view_HostRules.applyRoundedStyle(cornerRadius: 10)
        
        imgCollV.register(UINib(nibName: "ImgSelectionCollVCell", bundle: nil), forCellWithReuseIdentifier: "ImgSelectionCollVCell")
        imgCollV.delegate = self
        imgCollV.dataSource = self
        
        streeTF.addTarget(self, action: #selector(openAutocomplete), for: .editingDidBegin)
        
        // Add target to the text field to observe changes
        aboutSpaceTitleTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        streeTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cityTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        zipcodeTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        stateTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        countryTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
     
//        aboutSpaceDesTV.addTarget(self, action: #selector(textViewDidChange(_:)), for: .editingChanged)
//        countryTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        countryTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.updatePropertyDetails()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustCollectionViewHeight()
    }
    
    @objc func openAutocomplete() {
        self.autocompleteClicked()
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//        present(autocompleteController, animated: true, completion: nil)
    }
    
   @objc func textFieldDidChange(_ textField: UITextField) {
            // Update the variable whenever the text changes
       if textField == aboutSpaceTitleTF{
           SingltonClass.shared.title = aboutSpaceTitleTF.text ?? ""
           print("Text field value updated: \(aboutSpaceTitleTF.text ?? "")")
       }else if textField == streeTF{
           SingltonClass.shared.street = streeTF.text ?? ""
           print("Text field value updated: \(streeTF.text ?? "")")
       }else if textField == cityTF{
           SingltonClass.shared.city = cityTF.text ?? ""
           print("Text field value updated: \(cityTF.text ?? "")")
       }else if textField == zipcodeTF{
           SingltonClass.shared.zipcode = zipcodeTF.text ?? ""
           print("Text field value updated: \(zipcodeTF.text ?? "")")
       }else if textField == stateTF{
           SingltonClass.shared.state = stateTF.text ?? ""
           print("Text field value updated: \(stateTF.text ?? "")")
       }else if textField == countryTF{
           SingltonClass.shared.country = countryTF.text ?? ""
           print("Text field value updated: \(countryTF.text ?? "")")
       }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == aboutSpaceDesTV{
            SingltonClass.shared.about = aboutSpaceDesTV.text
            print(SingltonClass.shared.about ?? "")
        }else if textView == parkingRuleDesTV{
            SingltonClass.shared.parkingRule = parkingRuleDesTV.text
            print(SingltonClass.shared.parkingRule ?? "")
        }else if textView == hostRuleDesTV{
            SingltonClass.shared.hostRules = hostRuleDesTV.text
            print(SingltonClass.shared.hostRules ?? "")
        }
    }
   
    func adjustCollectionViewHeight() {
        collectionViewHeightConstraint.constant = imgCollV.collectionViewLayout.collectionViewContentSize.height
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == aboutSpaceDesTV{
            if aboutSpaceDesTV.text == "Optional"{
                self.aboutSpaceDesTV.text = ""
                SingltonClass.shared.about = ""
            }
        }else if textView == parkingRuleDesTV{
            if parkingRuleDesTV.text == "Optional"{
                self.parkingRuleDesTV.text = ""
                SingltonClass.shared.parkingRule = ""
            }
        }else{
            if hostRuleDesTV.text == "Optional"{
                self.hostRuleDesTV.text = ""
                SingltonClass.shared.hostRules = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == aboutSpaceDesTV{
            if aboutSpaceDesTV.text == ""{
                self.aboutSpaceDesTV.text = "Optional"
                SingltonClass.shared.about = self.aboutSpaceDesTV.text ?? ""
            }
        }else if textView == parkingRuleDesTV{
            if parkingRuleDesTV.text == ""{
                self.parkingRuleDesTV.text = "Optional"
                SingltonClass.shared.parkingRule = self.parkingRuleDesTV.text ?? ""
            }
        }else{
            if hostRuleDesTV.text == ""{
                self.hostRuleDesTV.text = "Optional"
                SingltonClass.shared.hostRules = self.hostRuleDesTV.text ?? ""
            }
        }
    }
    
    
    @IBAction func addLocation (sender: UIButton) {
        print(sender.tag)
        self.autocompleteClicked()
    }
    
    
    func updatePropertyDetails(){
//        if SingltonClass.shared.Imgs != nil{
//            
//        }
        self.selectedImages = SingltonClass.shared.Imgs
        self.imgCollV.reloadData()
        self.aboutSpaceTitleTF.text = SingltonClass.shared.title
        self.aboutSpaceDesTV.text = SingltonClass.shared.about
        self.parkingRuleDesTV.text = SingltonClass.shared.parkingRule
        self.hostRuleDesTV.text = SingltonClass.shared.hostRules
        self.streeTF.text = SingltonClass.shared.street
        self.cityTF.text = SingltonClass.shared.city
        self.zipcodeTF.text = SingltonClass.shared.zipcode
        self.stateTF.text = SingltonClass.shared.state
        self.countryTF.text = SingltonClass.shared.country
        
        if SingltonClass.shared.latitude != 0.0 && SingltonClass.shared.longitude != 0.0{
            self.viewMainMap.isHidden = false
            mapV.camera = GMSCameraPosition.camera(withLatitude: SingltonClass.shared.latitude ?? 0.0, longitude: SingltonClass.shared.longitude ?? 0.0, zoom: 14.0)
               let marker = GMSMarker(position: CLLocationCoordinate2D(latitude:  SingltonClass.shared.latitude ?? 0.0, longitude: SingltonClass.shared.longitude ?? 0.0))
    //           marker.title = locality
    //                       marker.snippet = "California"
               marker.map = mapV
        }
       
    }
    
}

extension HostGalleryLocationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func openCameraOrGallery() {
        let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
        
        // Camera option
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openImagePicker(sourceType: .camera)
            }))
        }
        
        // Gallery option
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openImagePicker(sourceType: .photoLibrary)
        }))
        
        // Cancel option
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    // Handle selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage
        
        // Convert UIImage to Data
        if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
               let newImageEntry = imageArray(image: selectedImage, data: imageData, url: "", image_id: "", thumbNail: selectedImage)
               
               selectedImages.append(newImageEntry) // Append to your struct array
               SingltonClass.shared.Imgs.append(newImageEntry) // Append raw UIImage if needed
               print(SingltonClass.shared.Imgs, "IMG Singlton")
               
               imgCollV.reloadData()
               adjustCollectionViewHeight()
            print("Selected Image: \(selectedImage ?? UIImage())")
           } else {
               print("Failed to convert image to Data.")
           }

    }
    
    // Handle cancellation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension HostGalleryLocationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count < 6 ? selectedImages.count + 1 : 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgSelectionCollVCell", for: indexPath) as! ImgSelectionCollVCell
        
        if indexPath.item == selectedImages.count && selectedImages.count < 6 {
                cell.bgDotImg.image = UIImage(named: "addmoreiconsh") // Default "Add More" image
                cell.deleteBtn.isHidden = true
            } else {
                let img = selectedImages[indexPath.item].image
                if img != nil{
                    cell.bgDotImg.image = selectedImages[indexPath.item].image
                }else{
                    cell.bgDotImg.loadImage(from: AppURL.imageURL + (selectedImages[indexPath.row].url ?? ""),placeholder: UIImage(named: "NoIMg"))
                }
                cell.deleteBtn.isHidden = false
                cell.deleteBtn.tag = indexPath.item
                cell.deleteBtn.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
            }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedImages.count < 6 {
            openCameraOrGallery()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 10, height: 100)
    }
    
    
    @objc func deleteImage(_ sender: UIButton) {
        
        if SingltonClass.shared.Imgs[sender.tag].image_id != ""{
            SingltonClass.shared.deletedImg.append(Int(SingltonClass.shared.Imgs[sender.tag].image_id ?? "") ?? 0)
            print(SingltonClass.shared.deletedImg, "<<<<Delete Img ID >>>")
        }
        self.selectedImages.remove(at: sender.tag)
        SingltonClass.shared.Imgs.remove(at: sender.tag)
        self.imgCollV.reloadData()
        self.adjustCollectionViewHeight()

        
    }
    
}

extension HostGalleryLocationVC: CLLocationManagerDelegate{
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

extension HostGalleryLocationVC: GMSAutocompleteViewControllerDelegate {
    
    
    
    // Handle the user's selection.
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        
//        print("Place name: \(place.name ?? "")")
//        print("Place ID: \(String(describing: place.placeID))")
//        print("Place attributions: \(String(describing: place.attributions))")
//        print("Place latitude: \(place.coordinate.latitude)")
//        print("Place longitude: \(place.coordinate.longitude)")
//        print("Place formattedAddress: \(String(describing: place.formattedAddress!))")
//        SingltonClass.shared.latitude = place.coordinate.latitude
//        SingltonClass.shared.longitude = place.coordinate.longitude
//        
//        if place.name != nil {
//            UserDefaults.standard.set("\(place.coordinate.latitude)", forKey: "selectedlat")
//            UserDefaults.standard.set("\(place.coordinate.longitude)", forKey: "selectedLong")
//            
//            var street: String?
//            var locality: String?
//            var adminArea: String?
//            var country: String?
//            var zipcode: String?
//            
//            place.addressComponents?.forEach({ adr in
//                if adr.types.contains("street_number") {
//                    street = adr.name
//                } else if adr.types.contains("route") {
//                    street = "\(street ?? "") , \(adr.name)"
//                }else if adr.types.contains("locality") {
//                    locality = adr.name
//                } else if adr.types.contains("administrative_area_level_1") {
//                    adminArea = adr.name
//                } else if adr.types.contains("country") {
//                    country = adr.name
//                }else if adr.types.contains("postal_code") {
//                    zipcode = adr.name
//                }
//                })
//            
//            if let locality = locality, let adminArea = adminArea, let country = country {
//                
//                self.streeTF.text = street
//                self.cityTF.text = locality
//                self.zipcodeTF.text = zipcode
//                self.stateTF.text = adminArea
//                self.countryTF.text = country
//                
//                SingltonClass.shared.street = streeTF.text
//                SingltonClass.shared.city = cityTF.text
//                SingltonClass.shared.zipcode = zipcodeTF.text
//                SingltonClass.shared.state = stateTF.text
//                SingltonClass.shared.country = countryTF.text
//                
//                self.viewMainMap.isHidden = false
//                print("Locality: \(locality)")
//                print("Administrative Area Level 1: \(adminArea)")
//                print("Country: \(country)")
//                print("ZipCode: \(zipcode ?? "")")
//                
//                mapV.camera = GMSCameraPosition.camera(withLatitude: SingltonClass.shared.latitude ?? 0.0, longitude: SingltonClass.shared.longitude ?? 0.0, zoom: 14.0)
//                   let marker = GMSMarker(position: CLLocationCoordinate2D(latitude:  SingltonClass.shared.latitude ?? 0.0, longitude: SingltonClass.shared.longitude ?? 0.0))
//                   marker.title = locality
////                 marker.snippet = "California"
//                   marker.map = mapV
//                
//                } else {
//                    print("Some components are missing")
//                }
//            NotificationCenter.default.post(name: NSNotification.Name("currentLocation"), object: ["latitude":"\(place.coordinate.latitude)","longitude":"\(place.coordinate.longitude)"])
//        }
//        dismiss(animated: true, completion: nil)
//    }
 
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
                updateAddressFields(from: place.coordinate, fallbackStreet: placeName)
            
            SingltonClass.shared.latitude = place.coordinate.latitude
            SingltonClass.shared.longitude = place.coordinate.longitude
            dismiss(animated: true, completion: nil)
        }
    
    private func updateAddressFields(from coordinate: CLLocationCoordinate2D, fallbackStreet: String) {
        extractAddressDetails(from: coordinate) { [weak self] street, city, state, zip, country in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.streeTF.text = street?.isEmpty == false ? street : fallbackStreet
                self.cityTF.text = city
                self.stateTF.text = state
                self.zipcodeTF.text = zip
                self.countryTF.text = country
                
                SingltonClass.shared.street = self.streeTF.text
                SingltonClass.shared.city = self.cityTF.text
                SingltonClass.shared.zipcode = self.zipcodeTF.text
                SingltonClass.shared.state = self.stateTF.text
                SingltonClass.shared.country = self.countryTF.text
                self.viewMainMap.isHidden = false
                
                self.mapV.camera = GMSCameraPosition.camera(withLatitude: SingltonClass.shared.latitude ?? 0.0, longitude: SingltonClass.shared.longitude ?? 0.0, zoom: 14.0)
                  let marker = GMSMarker(position: CLLocationCoordinate2D(latitude:  SingltonClass.shared.latitude ?? 0.0, longitude: SingltonClass.shared.longitude ?? 0.0))
//                                   marker.title = self.streeTF.text
                //                 marker.snippet = "California"
                marker.map = self.mapV
                NotificationCenter.default.post(name: NSNotification.Name("currentLocation"), object: ["latitude":"\(coordinate.latitude)","longitude":"\(coordinate.longitude)"])
                        
            }
        }
    }
    private func extractAddressDetails(from coordinate: CLLocationCoordinate2D,
                                       completion: @escaping (_ street: String?, _ city: String?, _ state: String?, _ zip: String?, _ Country: String?) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                print("Reverse geocode failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil, nil, nil, nil,nil)
                return
            }
            let street = [placemark.subThoroughfare, placemark.thoroughfare]
                .compactMap { $0 }
                .joined(separator: " ")
            completion(street, placemark.locality, placemark.administrativeArea, placemark.postalCode, placemark.country)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        // self.AlertControllerOnr(title: "Error", message: error.localizedDescription, BtnTitle: "OK")
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

extension GMSMapView {
    // Configures the map with the given latitude, longitude, and zoom level.
    func configureMap(latitude: Double, longitude: Double, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        self.camera = camera
    }

    // Adds a marker to the map at the specified coordinates with a title and snippet.
    func addMarker(latitude: Double, longitude: Double, title: String, snippet: String) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = title
        marker.snippet = snippet
        marker.map = self
    }
}

extension UIView {
    func applyRoundedStyle(cornerRadius: CGFloat? = nil, borderWidth: CGFloat = 1, borderColor: UIColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)) {
        self.layer.cornerRadius = cornerRadius ?? self.frame.height / 2
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
    }
}
