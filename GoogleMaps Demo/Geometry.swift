//
//  Geometry.swift
//  GoogleMaps Demo
//
//  Created by Michael Gerasimov on 9/6/16.
//  Copyright © 2016 Michael Gerasimov. All rights reserved.
//

import UIKit
import MapKit

class Geometry: NSObject {
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "location"{
            if let dict = value as? [String: AnyObject] {
                location = Location()
                location!.setValuesForKeysWithDictionary(dict)
            }
        }else{ super.setValue(value, forKey: key) }
    }
    
    var location: Location?
    var viewport : AnyObject?
    var location_type: String?
    
    class Location: NSObject{
        var lat:NSNumber?
        var lng:NSNumber?
    }
}


