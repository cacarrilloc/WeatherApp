//
//  delayFunction.swift
//  WeatherApp
//
//  Created by Carlos Carrillo on 8/19/17.
//  Copyright © 2017 Carlos Carrillo. All rights reserved.
//

import Foundation

class DelayFunction {
    
    static func delay(seconds:Double, action:@escaping ()->()) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + seconds){
            action()
        }
    }
}
