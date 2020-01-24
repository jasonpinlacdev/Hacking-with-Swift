//
//  Capital.swift
//  Project16 Capital Cities
//
//  Created by Jason Pinlac on 1/24/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    
    var title: String?
    var info: String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, info: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
