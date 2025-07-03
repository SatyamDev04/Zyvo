//
//  LocationPicker.swift
//  MyAirSpa_YesITLabs
//
//  Created by YATIN  KALRA on 05/12/23.




import Foundation
import CoreLocation
import UIKit

protocol LocationPickerDelegate: AnyObject {
    func didUpdateLocation(latitude: Double, longitude: Double)
    func didFailWithError(error: Error)
}

class LocationPicker: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationPicker() // Singleton instance
    private var locationManager: CLLocationManager
    weak var delegate: LocationPickerDelegate?

    private override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// Check and request location permission
    func checkLocationPermission() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            showLocationAccessAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    /// Start getting user location
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    /// Stop location updates
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    /// Show alert to enable location access
    private func showLocationAccessAlert() {
        guard let topController = UIApplication.shared.windows.first?.rootViewController else { return }
        
        let alertController = UIAlertController(
            title: "Location Access Needed",
            message: "Please enable location access in Settings to get your current location.",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        })

        topController.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - CLLocationManager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            delegate?.didUpdateLocation(latitude: latitude, longitude: longitude)
            stopUpdatingLocation() // Stop updates after getting location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error: error)
    }
}



//import UIKit
//import CoreLocation
//
//class LocationManager: NSObject, CLLocationManagerDelegate {
//    
//    static let shared = LocationManager()
//    private let locationManager = CLLocationManager()
//    var completion: ((CLLocationCoordinate2D?, Error?) -> Void)?
//    
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//    
//    /// Request location access properly
//    @available(iOS 14.0, *)
//    func requestLocationPermission() {
//        let status = locationManager.authorizationStatus
//        
//        switch status {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .denied, .restricted:
//            showLocationAlert()
//        case .authorizedWhenInUse, .authorizedAlways:
//            locationManager.startUpdatingLocation()
//        @unknown default:
//            break
//        }
//    }
//    
//    /// Get current location after permission is granted
//    @available(iOS 14.0, *)
//    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
//        self.completion = completion
//        
//        let status = locationManager.authorizationStatus
//        if status == .authorizedWhenInUse || status == .authorizedAlways {
//            locationManager.startUpdatingLocation()
//        } else {
//            requestLocationPermission()
//        }
//    }
//    
//    /// Show alert if location access is denied
//    private func showLocationAlert() {
//        DispatchQueue.main.async {
//            if let topVC = UIApplication.shared.windows.first?.rootViewController?.topmostViewController() {
//                let alert = UIAlertController(title: "Location Required", message: "Please enable location services in Settings.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
//                    if let url = URL(string: UIApplication.openSettingsURLString) {
//                        UIApplication.shared.open(url)
//                    }
//                }))
//                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//                topVC.present(alert, animated: true, completion: nil)
//            }
//        }
//    }
//    
//    // MARK: - CLLocationManagerDelegate Methods
//    @available(iOS 14.0, *)
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        let status = manager.authorizationStatus
//        
//        if status == .authorizedWhenInUse || status == .authorizedAlways {
//            locationManager.startUpdatingLocation()
//        } else if status == .denied || status == .restricted {
//            print("ravi kashyap")
//            showLocationAlert()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            completion?(location.coordinate, nil)
//            print("ravi kashyap")
//            locationManager.stopUpdatingLocation()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        completion?(nil, error)
//    }
//}



//import Foundation
//import UIKit
//import GooglePlaces
//import GoogleMaps
//import CoreLocation
//
//class LocationPickerViewController: UIViewController {
//    
//    let locationManager = LocationManager()
//    var locviewModel = LocationViewModel()
//    
//    
//    func getCurrentLatLong(){
//        locationManager.startUpdatingLocation()
//        
//        locationManager.locationUpdateCallback = { [weak self] location in
//            
//            print("Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
//            self?.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), comlition: ({ adress,city,state,zipCode in
//                self?.locviewModel.didGetCurrentPlace?(adress,"\(location.coordinate.latitude)","\(location.coordinate.longitude)",city,state,zipCode)
//            }))
//    
////            self?.getAddressFromLatLon(pdblLatitude: "\(location.coordinate.latitude)", withLongitude: "\(location.coordinate.longitude)"){ (address) in
////                print("Address: \(address)")
//                
//              
//                
//                self?.locationManager.stopUpdatingLocation()
//            }
//            
//    }
//    deinit {
//        
//        locationManager.stopUpdatingLocation()
//    }
//}
//
//
//extension LocationPickerViewController: GMSAutocompleteViewControllerDelegate {
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        self.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude), comlition: ({ adress,city,state,zipCode in
//            self.locviewModel.didSelectPlace?(adress, "\(place.coordinate.latitude)","\(place.coordinate.longitude)",city,state,zipCode)
//        }))
//                                      
//       
//        viewController.dismiss(animated: true, completion: nil)
//    }
//    
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        // Handle autocomplete error
//    }
//    
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        viewController.dismiss(animated: true, completion: nil)
//    }
//    
//    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String,complition:@escaping(String)->Void) {
//        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//        let lat: Double = Double("\(pdblLatitude)")!
//        //21.228124
//        let lon: Double = Double("\(pdblLongitude)")!
//        //72.833770
//        let ceo: CLGeocoder = CLGeocoder()
//        center.latitude = lat
//        center.longitude = lon
//        UserDefaults.standard.set(lat, forKey: "user_lat")
//        UserDefaults.standard.set(lon, forKey: "user_lng")
//        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//        
//        
//        ceo.reverseGeocodeLocation(loc, completionHandler:
//                                    {(placemarks, error) in
//            if (error != nil)
//            {
//                print("reverse geodcode fail: \(error!.localizedDescription)")
//            }
//            guard let pm = placemarks else {return}
//            print(pm)
//            if pm.count > 0 {
//                let pm = placemarks![0]
//                print(pm.country ?? "")
//                print(pm.locality ?? "")
//                print(pm.subLocality ?? "")
//                print(pm.thoroughfare ?? "")
//                print(pm.postalCode ?? "")
//                print(pm.subThoroughfare ?? "")
//                var addressString : String = ""
//                if pm.subLocality != nil {
//                    addressString = addressString + pm.subLocality! + ", "
//                }
//                if pm.thoroughfare != nil {
//                    addressString = addressString + pm.thoroughfare! + ", "
//                }
//                if pm.locality != nil {
//                    addressString = addressString + pm.locality! + ", "
//                }
//                if pm.country != nil {
//                    addressString = addressString + pm.country! + ", "
//                }
//                if pm.postalCode != nil {
//                    addressString = addressString + pm.postalCode! + " "
//                }
//                complition(addressString)
//                //self.txt_Location.text = addressString
//                
//                
//            }
//        })
//        
//    }
//    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D,comlition:@escaping(String,String,String,String) -> ())  {
//
//        print(coordinate.latitude, "lat")
//        print(coordinate.longitude, "lat")
//        
//        let coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        GeocoderManager.shared.reverseGeocodeCoordinate(coordinate) { address, city, state, zipcode in
//            print("Address: \(address), City: \(city), State: \(state), Zipcode: \(zipcode)")
//            comlition(address,city,state,zipcode)
//        }
//
//      
//    }
//}
//
//class LocationViewModel {
//    var didSelectPlace: ((_ address:String, _ lat:String,_ long:String,_ city:String,_ state:String,_ zipCode:String) -> Void)?
//    var didGetCurrentPlace: ((_ address:String, _ lat:String,_ long:String,_ city:String,_ state:String,_ zipCode:String) -> Void)?
//    
//    func presentAutocomplete(on viewController: UIViewController) {
//        let autocompleteViewController = GMSAutocompleteViewController()
//        autocompleteViewController.delegate = viewController as? GMSAutocompleteViewControllerDelegate
//        viewController.present(autocompleteViewController, animated: true, completion: nil)
//    }
//}
//
//
//class LocationManager: NSObject, CLLocationManagerDelegate {
//    
//    private var locationManager = CLLocationManager()
//    var locationUpdateCallback: ((CLLocation) -> Void)?
//    
//    override init() {
//        super.init()
//        setupLocationManager()
//    }
//    
//    private func setupLocationManager() {
//        self.locationManager.delegate = self
//        self.checkPermition()
//        
//    }
//    
//    func checkPermition(){
//        DispatchQueue.global(qos: .userInitiated).async {
//            if CLLocationManager.locationServicesEnabled() {
//                // Check the current authorization status
//                switch CLLocationManager.authorizationStatus() {
//                case .authorizedWhenInUse, .authorizedAlways:
//                    // Location permissions already granted
//                    self.startUpdatingLocation()
//                case .notDetermined:
//                    // Request location permissions
//                    self.locationManager.requestAlwaysAuthorization()
//                    self.locationManager.requestWhenInUseAuthorization()
//                    self.locationManager.delegate = self
//                    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//                    self.startUpdatingLocation()
//                case .restricted, .denied:
//                    // Handle case when permissions are denied
//                    print("Location permissions are denied. Please enable in settings.")
//                    self.locationManager.requestAlwaysAuthorization()
//                    self.locationManager.requestWhenInUseAuthorization()
//                    self.locationManager.delegate = self
//                    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//                    self.startUpdatingLocation()
//                @unknown default:
//                    break
//                }
//            } else {
//                // Handle case when location services are not enabled
//                print("Location services are not enabled. Please enable in settings.")
//            }
//            
//        }
//    }
//    
//    func startUpdatingLocation() {
//        locationManager.startUpdatingLocation()
//    }
//    
//    func stopUpdatingLocation() {
//        locationManager.stopUpdatingLocation()
//    }
//    
//    // MARK: - CLLocationManagerDelegate
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        if let location = locations.last {
//            locationUpdateCallback?(location)
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location update failed with error: \(error.localizedDescription)")
//    }
//    
//}
//class GeocoderManager {
//    static let shared = GeocoderManager()
//    private let geocoder = GMSGeocoder()
//    
//    private init() {}
//    
//    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (String, String, String, String) -> ()) {
//        print(coordinate.latitude, "lat")
//        print(coordinate.longitude, "lat")
//      
//        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
//            guard let address = response?.firstResult(),
//                  let lines = address.lines else {
//                return
//            }
//            let city = address.locality ?? ""
//            let state = address.administrativeArea ?? ""
//            let zipcode = address.postalCode ?? "201003"
//            let components = lines.joined(separator: "\n").components(separatedBy: ",")
//            var modifiedAddress = components.dropLast().joined(separator: ", ")
//            modifiedAddress = modifiedAddress.trimmingCharacters(in: .whitespaces)
//            
//            print(modifiedAddress)
//            completion(modifiedAddress, city, state, zipcode)
//        }
//    }
//}
