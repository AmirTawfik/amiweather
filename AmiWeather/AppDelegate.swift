//
//  AppDelegate.swift
//  AmiWeather
//
//  Created by Amir Tawfik on 02/09/2020.
//  Copyright © 2020 Amir Tawfik. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // init Google Maps and Google Places
        GMSServices.provideAPIKey("AIzaSyBMJsEGe7hCMYxra_qxiMmzF7Z1dlX3reM")
        GMSPlacesClient.provideAPIKey("AIzaSyBMJsEGe7hCMYxra_qxiMmzF7Z1dlX3reM")
        
        // create an instance of the main view controller
        let mainVC = MainViewController()
        // create main navigation controller and embed main view controller into it
        let mainNC = UINavigationController(rootViewController: mainVC)
        
        // configure window to use main navigation controller as the root
        window?.rootViewController = mainNC
        window?.rootViewController?.view = mainNC.view
        
        // enable only light mode
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        return true
    }

}

