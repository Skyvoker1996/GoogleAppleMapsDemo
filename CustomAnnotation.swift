//
//  CustomAnnotation.swift
//  GoogleMaps Demo
//
//  Created by Michael Gerasimov on 9/3/16.
//  Copyright © 2016 Michael Gerasimov. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
}
