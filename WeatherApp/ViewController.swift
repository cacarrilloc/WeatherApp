//
//  ViewController.swift
//  WeatherApp
//
//  Created by Carlos Carrillo on 8/16/17.
//  Copyright © 2017 Carlos Carrillo. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit



class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mySwitch: UISegmentedControl!
    @IBOutlet weak var myLabel1: UILabel!
    @IBOutlet weak var myLabel2: UILabel!
    @IBOutlet weak var myLabel3: UILabel!
    @IBOutlet weak var myLabel4: UILabel!
    
    var lock = 0
    var delay = 30.0
    var city:String?
    var state:String?
    var initialTemp:String?
    var networking:Networking?
    var weatherArray:[Weather]?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Networking Connection
        self.networking = Networking(delegate: self)
        self.myLabel2.text = "Fahrenheit"
        
        // CoreLocation Setup
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        startUpdates()
    }
    
    // GET USER LOCATION (City and State) AND EXUTE API CALL
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print ("reverseGeocodeLocation has failed")
            } else {
                if let place = placemark?[0] {
                    DispatchQueue.main.async {
                        self.city = place.locality!
                        self.state = place.administrativeArea!
                        //self.state = place.postalCode!
                        self.myLabel4.text = self.city! + ", " + self.state!
                        self.networking?.callApi(city: self.city!, state: self.state!)
                        self.myLabel3.text = self.weatherArray?[0].weather
                        self.assignbackground()
                    }
                }
            }
        }
    }
    
    func startUpdates(){
        locationManager.startUpdatingLocation()
        print("\nDELAY STOPS\n")
        DelayFunction.delay(seconds: delay){
            [unowned self] in
            self.stopUpdates()
        }
    }
    
    func stopUpdates() {
        locationManager.stopUpdatingLocation()
        DelayFunction.delay(seconds: delay){
            [unowned self] in
            self.startUpdates()
        }
    }
    
    // Set background picture according the local weather
    func assignbackground(){
        var imageView: UIImageView!
        imageView = UIImageView(frame:CGRect(x: 100, y: 220, width: 200, height: 190))
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = weatherArray?[0].image
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    // Change temperature format in Label
    @IBAction  func temperatureChanger(_ sender:AnyObject){
        switch mySwitch.selectedSegmentIndex{
        case 0:
            let tempFahrenheit:String = String(format:"%.1f", (self.weatherArray?[0].temp_f)!)
            self.myLabel1.text = tempFahrenheit
            self.myLabel2.text = "Fahrenheit"
            
        case 1:
            let tempCelsious:String = String(format:"%.1f", (self.weatherArray?[0].temp_c)!)
            self.myLabel1.text = tempCelsious
            self.myLabel2.text = "Celsius"
        default:
            break;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: NetworkingDelegate {
    func getWeather(array:[Weather]) {
        self.weatherArray = array
        lock += 1
        if lock < 2 {
            DispatchQueue.main.async {
                self.assignbackground()
                let tempFahrenheit:String = String(format:"%.1f", (self.weatherArray?[0].temp_f)!)
                self.myLabel1.text = tempFahrenheit
                self.myLabel3.text = self.weatherArray?[0].weather
            }
        }
        print("\nDelagate Working")
    }
}




