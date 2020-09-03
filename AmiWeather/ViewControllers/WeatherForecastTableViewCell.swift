//
//  WeatherForecastTableViewCell.swift
//  AmiWeather
//
//  Created by Amir Tawfik on 03/09/2020.
//  Copyright © 2020 Amir Tawfik. All rights reserved.
//

import UIKit

class WeatherForecastTableViewCell: UITableViewCell {

    @IBOutlet var dayLbl: UILabel!
    @IBOutlet var temperatureLbl: UILabel!
    @IBOutlet var pressureLbl: UILabel!
    @IBOutlet var humidityLbl: UILabel!
    @IBOutlet var conditionsLbl: UILabel!
    @IBOutlet var percipitationLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
