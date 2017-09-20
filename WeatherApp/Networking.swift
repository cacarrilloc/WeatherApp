//
//  Networking.swift
//  WeatherApp
//
//  Created by Carlos Carrillo on 8/16/17.
//  Copyright © 2017 Carlos Carrillo. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkingDelegate {
    func getWeather(array:[Weather])
}

class Networking {
    
    var temp_f:Double?
    var temp_c:Double?
    var weather:String?
    var imageUrl:String?
    
    var delegate:NetworkingDelegate
    init(delegate: NetworkingDelegate){
        self.delegate = delegate
    }
    
    func callApi(city:String, state:String) {
        let session = URLSession.shared
        guard let url = URL(string: "http://api.wunderground.com/api/5c1d5cd6f63a389f/conditions/q/\(state)/\(city).json") else {return}
        let task = session.dataTask(with: url) {(data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let jasonObject = try JSONSerialization.jsonObject(with: data)
                    guard let jsonArray = jasonObject as? [String:Any] else {
                        print("Error: Json is not readable")
                        return
                    }
                    // Get Forecast Info
                    let APIForecastInfo = jsonArray["current_observation"] as! NSDictionary
                    self.temp_f = APIForecastInfo["temp_f"] as? Double
                    self.temp_c = APIForecastInfo["temp_c"] as? Double
                    self.weather = (APIForecastInfo["weather"] as! NSString) as String!
                    self.imageUrl = (APIForecastInfo["icon_url"] as! NSString) as String!
                    self.callApi2(url: self.imageUrl!)
                    
                } catch let error{
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func callApi2(url:String, forObject:UIImageView? = nil){
        print("Donwloading Image")
        guard let uUrl = URL(string: url) else {return}
        let session = URLSession.shared
        let task = session.dataTask(with: uUrl){
            (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else {
                print ("Error: No data in call!")
                return
            }
            guard let image = UIImage(data: data) else {return}
            ImageCache.shared.cache.setObject(image, forKey: url as NSString)
            
            // Send Info to delagate via Array
            DispatchQueue.main.async {
                //self.myImageView.image = image
                self.delegate.getWeather(array: [Weather(temp_f: self.temp_f!, temp_c: self.temp_c!, image: image, weather: self.weather!)])
            }
        }
        task.resume()
    }
    deinit {
        print("got removed from the app")
    }
}


