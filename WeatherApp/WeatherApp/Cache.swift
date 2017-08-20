//
//  Cache.swift
//  WeatherApp
//
//  Created by Carlos Carrillo on 8/18/17.
//  Copyright © 2017 Carlos Carrillo. All rights reserved.
//

import Foundation
import UIKit

class ImageCache{
    static let shared = ImageCache()
    var cache = NSCache<NSString,UIImage>()
}
