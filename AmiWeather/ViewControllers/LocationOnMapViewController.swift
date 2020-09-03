//
//  LocationOnMapViewController.swift
//  AmiWeather
//
//  Created by Amir Tawfik on 02/09/2020.
//  Copyright © 2020 Amir Tawfik. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationOnMapViewController: UIViewController {

    @IBOutlet var mapView: GMSMapView!
    
    var locationDesc = ""
    var locationLat = 0.0
    var locationLon = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Location On Map"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        setupMap()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: locationLat, longitude: locationLon, zoom: 10.0)
        self.mapView.camera = camera
        mapView.mapType = .normal
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: locationLat, longitude: locationLon)
        marker.title = "Location"
        marker.snippet = locationDesc
        marker.appearAnimation = .pop
        marker.map = self.mapView
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
