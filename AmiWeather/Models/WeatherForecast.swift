//
//  WeatherForecast.swift
//  AmiWeather
//
//  Created by Amir Tawfik on 03/09/2020.
//  Copyright © 2020 Amir Tawfik. All rights reserved.
//

import Foundation

struct Temperature: Codable {
    var day: String?
    var min: String?
    var max: String?
    var night: String?
    var eve: String?
    var morn: String?
    
    enum CodingKeys: String, CodingKey {
        case day
        case min
        case max
        case night
        case eve
        case morn
    }
}

struct Weather: Codable {
    var main: String
    var description: String
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case description
        case icon
    }
}

struct WeatherForecastDay: Codable {
    var date: Int
    var temp: Temperature
    var weather: [Weather]
    var pressure: Double?
    var humidity: Double?
    var windSpeed: Double?
    var windDirection: Double?
    var clouds: Double?
    var rain: Double?
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temp
        case weather
        case pressure
        case humidity
        case windSpeed = "speed"
        case windDirection = "deg"
        case clouds
        case rain
    }
}

struct WeatherForecast: Codable {
    var statusCode: String
    var message: Double
    var list: [WeatherForecastDay]
    enum CodingKeys: String, CodingKey {
        case statusCode = "cod"
        case message
        case list
    }
}
