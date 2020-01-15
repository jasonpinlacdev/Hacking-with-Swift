//
//  Person.swift
//  Project10 Names to Faces
//
//  Created by Jason Pinlac on 1/14/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
