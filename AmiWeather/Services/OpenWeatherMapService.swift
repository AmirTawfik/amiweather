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
    
    let apiKey = "8ff69d53867e3b3673365dd7417c09db"

    func getForecastWeather(lat: Double,lon: Double, cnt: Int, completionHandler: @escaping (Data?, Error?) -> ()) {
        
        let url = URL(string: Constants.API_BASE_URL + Constants.API_ENDPOINT_FORECAST_WEATHER)

        print(url!.absoluteString)
        
        let parameters: Parameters = self.buildParameters(lat: lat, lon: lon, cnt: cnt)
        
        AF.request(url!, parameters: parameters).responseJSON { response in
            
            switch response.result {
            // handle success case
            case .success(let value):
                print("success")
                completionHandler(response.data, nil)
                
            // handle failure case
            case .failure(let error):
                print("error")
                completionHandler(nil, error)
            }
 
        }
    }
    
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
