//
//  WeatherForecastTableViewController.swift
//  AmiWeather
//
//  Created by Amir Tawfik on 03/09/2020.
//  Copyright © 2020 Amir Tawfik. All rights reserved.
//

import UIKit

class WeatherForecastTableViewController: UITableViewController {
    

    
    var locationDesc: String = ""
    var locationLat: Double = 0.0
    var locationLon: Double = 0.0
    
    var forecasts = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "WeatherForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "ForecastCell")

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(callAPI), for: .valueChanged)
        self.refreshControl = refreshControl
        
        self.refreshControl?.beginRefreshing()
        callAPI()
    }

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
            
            self.refreshControl?.endRefreshing()
            
            do {
                guard let data = responseData else {
                     print("Error get weather forcast nil")
                     return
                 }
                 
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: AnyObject]
                
                self.forecasts = json["list"] as! [[String: AnyObject]]
                self.tableView.reloadData()
                
                print(json)
                
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
        
        print(forecast)
        
        // Configure the cell...
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
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
