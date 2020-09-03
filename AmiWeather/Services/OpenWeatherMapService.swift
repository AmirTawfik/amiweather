//
//  OpenWeatherMapService.swift
//  AmiWeather
//
//  Created by Amir Tawfik on 03/09/2020.
//  Copyright © 2020 Amir Tawfik. All rights reserved.
//

import Foundation
import Alamofire

class OpenWeatherMapService {
    static let service = OpenWeatherMapService()
    
    // API Key
    let apiKey = "8ff69d53867e3b3673365dd7417c09db"

    // Service: Get Forecast Weather for a specific number of days
    // free API gives up to 10 days only
    func getForecastWeather(lat: Double,lon: Double, cnt: Int, completionHandler: @escaping (Data?, Error?) -> ()) {
        
        // build url
        let url = URL(string: Constants.API_BASE_URL + Constants.API_ENDPOINT_FORECAST_WEATHER)
        
        // construct parameters
        let parameters: Parameters = self.buildParameters(lat: lat, lon: lon, cnt: cnt)
        
        // call End Point
        AF.request(url!, parameters: parameters).responseJSON { response in
            
            switch response.result {
            // handle success case
            case .success( _):
                print("success")
                completionHandler(response.data, nil)
                
            // handle failure case
            case .failure(let error):
                print("error")
                completionHandler(nil, error)
            }
 
        }
    }
    
    // custom func to build params for getting weather forecast end point
    func buildParameters(lat: Double, lon: Double, cnt: Int) -> Parameters {
        let parameters: Parameters = [
            "appid": self.apiKey,
            "units": "imperial",
            "lat": String(lat),
            "lon": String(lon),
            "cnt": String(cnt)
        ]
        
        return parameters
    }
}
