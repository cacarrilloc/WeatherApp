//
//  Weather.swift
//  WeatherApp
//
//  Created by Carlos Carrillo on 8/16/17.
//  Copyright © 2017 Carlos Carrillo. All rights reserved.
//

import Foundation
import UIKit

class Weather {
    let temp_f:Double
    let temp_c:Double
    let image:UIImage
    let weather:String
    
    init(temp_f:Double, temp_c:Double, image:UIImage, weather:String) {
        self.image = image
        self.temp_f = temp_f
        self.temp_c = temp_c
        self.weather = weather
    }
}

