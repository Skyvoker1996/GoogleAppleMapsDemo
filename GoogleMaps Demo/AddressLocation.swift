//
//  AddressLocation.swift
//  GoogleMaps Demo
//
//  Created by Michael Gerasimov on 9/6/16.
//  Copyright © 2016 Michael Gerasimov. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddressLocation: NSObject {
    
    var formatted_address: String?
    var geometry: Geometry?
    var place_id: String?
    var types: [AnyObject]?
    var address_components: [AnyObject]?
    var partial_match: AnyObject?
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "geometry" {
            if let dict = value as? [String: AnyObject] {
                geometry = Geometry()
                geometry!.setValuesForKeysWithDictionary(dict)
            }
            
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    static func fetchLocationForAddress(address: String, language: String, completitionHandler : ([AddressLocation]) -> ()){
        
        let fullAddress : NSString! = address.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.letterCharacterSet())
    
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(fullAddress)&language=\(language)&key=AIzaSyCvHGdB5rl0v9zIhMUdjhHoJrSv41g2sZA")

        NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            do {
                let json = try (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers))
                
                var addressLocations = [AddressLocation]()
        
                for dict in json["results"] as! [[String:AnyObject]]{
                         let addressLocation = AddressLocation()
                         addressLocation.setValuesForKeysWithDictionary(dict)
                         addressLocations.append(addressLocation)
                    }
                
                dispatch_async(dispatch_get_main_queue(), {
                    completitionHandler(addressLocations)
                })
                
                }catch let err {
                    print(err)
                }
            }.resume()
    }
}
