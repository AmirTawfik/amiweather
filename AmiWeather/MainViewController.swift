//
//  MainViewController.swift
//  AmiWeather
//
//  Created by Amir Tawfik on 02/09/2020.
//  Copyright © 2020 Amir Tawfik. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class MainViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, GMSAutocompleteViewControllerDelegate {

    

    @IBOutlet var searchTF: UITextField!
    
    var isLocationSelected = false
    var currentLocationDesc = ""
    var currentLocationLat = 0.0
    var currentLocationLon = 0.0
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        // hide navigation controller
        self.navigationController?.isNavigationBarHidden = true
        
        // set search text field delegate
        searchTF.delegate = self
    }

    @IBAction func mapBtnTapped(_ sender: UIButton) {
        hideKeyboard()
        
        if !isLocationSelected {
            showNoLocationSelectedMsg()
            return
        }
        
        // open map with selected location
        let locationOnMapVC = LocationOnMapViewController()
        locationOnMapVC.locationDesc = self.currentLocationDesc
        locationOnMapVC.locationLat = currentLocationLat
        locationOnMapVC.locationLon = currentLocationLon
        self.navigationController?.pushViewController(locationOnMapVC, animated: true)
    }
    
    @IBAction func useCurrentLocationBtnTapped(_ sender: UIButton) {
        hideKeyboard()
        
        // check if permission is not given for location services and return if so
        
        // otherwise set current location to user location
        setupCurrentLocation()
        searchTF.text = currentLocationDesc
    }
    
    @IBAction func clearBtnTapped(_ sender: UIButton) {
        deleteCurrentLocation()
        searchTF.text = currentLocationDesc
    }
    
    @IBAction func showWeatherBtnTapped(_ sender: UIButton) {
        hideKeyboard()
        
        if !isLocationSelected {
            showNoLocationSelectedMsg()
            return
        }
        
        // open weather days forcast screen
        
    }
    
    func hideKeyboard() {
        searchTF.resignFirstResponder()
    }
    
    func showGooglePlacesAutoComplete() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue) |
                    UInt(GMSPlaceField.placeID.rawValue) |
                    UInt(GMSPlaceField.coordinate.rawValue) |
                    GMSPlaceField.addressComponents.rawValue |
                    GMSPlaceField.formattedAddress.rawValue)!
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Current Location Setup/Delete
extension MainViewController {
    func setupCurrentLocation() {
        isLocationSelected = true
        currentLocationDesc = "Your current location"
        // get lat,lon from location manager
        if let lat = locationManager?.location?.coordinate.latitude {
            currentLocationLat = lat
        }
         if let lon = locationManager?.location?.coordinate.longitude {
             currentLocationLon = lon
         }
    }

    func setupGMSPlaceLocation(with place:GMSPlace) {
        isLocationSelected = true
        if let address = place.formattedAddress {
            currentLocationDesc = address
        }
        // get lat,lon
        currentLocationLat = place.coordinate.latitude
        currentLocationLon = place.coordinate.longitude
    }
    
    func deleteCurrentLocation() {
        isLocationSelected = false
        currentLocationDesc = ""
        currentLocationLat = 0.0
        currentLocationLon = 0.0
    }
}

// MARK: - Messages
extension MainViewController {
    func showNoLocationSelectedMsg() {
        let ac = UIAlertController(title: "No Location Selected", message: "Please enter a location or use your current location first", preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        ac.addAction(closeAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    func showLocationServiceNotEnabledMsg() {
        let ac = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        ac.addAction(closeAction)

        present(ac, animated: true, completion: nil)
    }
}

// MARK: - Text Field Delegate
extension MainViewController {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // show Google Places Autocomplete dialog
         showGooglePlacesAutoComplete()
        return false
    }
}

// MARK: - Location Manager Delegate
extension MainViewController {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            // great!
            return
        } else if status == .denied || status == .restricted {
            // show message
            showLocationServiceNotEnabledMsg()
            return()
        } else if status == .restricted {
            self.locationManager?.requestAlwaysAuthorization()
        }
    }
}

// MARK: - Google Places Autocomplete
extension MainViewController {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        setupGMSPlaceLocation(with: place)
        self.searchTF.text = self.currentLocationDesc
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
      // TODO: handle the error.
      print("Error: ", error.localizedDescription)
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
