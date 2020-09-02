//
//  MainViewController.swift
//  AmiWeather
//
//  Created by Amir Tawfik on 02/09/2020.
//  Copyright © 2020 Amir Tawfik. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

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
    }
    
    @IBAction func useCurrentLocationBtnTapped(_ sender: UIButton) {
        hideKeyboard()
        
        // check if permission is not given for location services and return if so
        
        // otherwise set current location to user location
        setupCurrentLocation()
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        // show Google Places Autocomplete dialog
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        deleteCurrentLocation()
        return true
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
