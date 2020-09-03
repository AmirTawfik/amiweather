//
//  WeatherForecastTableViewController.swift
//  AmiWeather
//
//  Created by Amir Tawfik on 03/09/2020.
//  Copyright © 2020 Amir Tawfik. All rights reserved.
//

import UIKit

class WeatherForecastTableViewController: UITableViewController {
    // location related vars, used in API call, set by the caller object
    var locationDesc: String = ""
    var locationLat: Double = 0.0
    var locationLon: Double = 0.0
    
    // array of forecasts
    var forecasts = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set screen title
        title = "10 Days Weather Forecast"
        
        // register custom cell to the table view
        tableView.register(UINib(nibName: "WeatherForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "ForecastCell")

        // setup refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(callAPI), for: .valueChanged)
        self.refreshControl = refreshControl
        
        // reload data to show empty table view at start
        tableView.reloadData()
        
        // for first time, simulate user pull to refresh
        self.refreshControl?.beginRefreshing()
        callAPI()
    }

    // action attached to refresh control
    @objc func callAPI() {
        getForecastWeather()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // call API here
    func getForecastWeather() {
        OpenWeatherMapService.service.getForecastWeather(lat: locationLat, lon: locationLon, cnt: 10) { responseData, error in
            
            // stop refresh control animation
            self.refreshControl?.endRefreshing()
            
            do {
                guard let data = responseData else {
                     print("Error get weather forcast nil")
                     return
                }
                
                // get API response as JSON
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: AnyObject]
                
                // get array of forecasts (10 days)
                self.forecasts = json["list"] as! [[String: AnyObject]]
                // reload data
                self.tableView.reloadData()
                
            } catch let err {
               print(err)
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return forecasts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! WeatherForecastTableViewCell

        let forecast = forecasts[indexPath.row]

        // Configure the cell...
        fillData(for: cell, with: forecast)
        
        return cell
    }

    // custom func to configure and fill data (presentation) for the cell
    func fillData(for cell: WeatherForecastTableViewCell, with forecast: [String: AnyObject]) {
        /// Date
        if let dt = forecast["dt"] {
            let convertedDate = Double(truncating: dt as! NSNumber).getDateStringFromUTC()
            cell.dayLbl.text = "\(convertedDate)"
        } else {
            cell.dayLbl.text = "-"
        }
        
        /// Temperature in Fahrenhit
        if let temp = forecast["temp"] as? [String: AnyObject] {
            if let tempDbl = temp["max"] as? Double {
                cell.temperatureLbl.text = "\(Int(tempDbl)) F"
            } else {
                cell.temperatureLbl.text = "- F"
            }
        } else {
            cell.temperatureLbl.text = "- F"
        }
        
        /// Pressure
        if let pressure = forecast["pressure"] {
            cell.pressureLbl.text = "\(pressure) hPa"
        } else {
            cell.pressureLbl.text = "- hPa"
        }

        /// Humidity
        if let humidity = forecast["humidity"] {
            cell.humidityLbl.text = "\(humidity)%"
        } else {
            cell.humidityLbl.text = "-%"
        }
        
        /// Condition
        if let condition = forecast["weather"] as? [[String: AnyObject]] {
            let weather = condition[0]
            if let desc = weather["description"] as? String {
                cell.conditionsLbl.text = "\(desc)"
            } else {
                cell.conditionsLbl.text = "-"
            }
        } else {
            cell.conditionsLbl.text = "-"
        }
        
        /// Percipitation
        if let percipitation = forecast["rain"] {
            cell.percipitationLbl.text = "\(percipitation) mm"
        } else {
            cell.percipitationLbl.text = "0 mm"
        }
    }
}
