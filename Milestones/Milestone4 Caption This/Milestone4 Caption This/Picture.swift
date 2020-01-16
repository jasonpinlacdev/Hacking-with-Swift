//
//  Picture.swift
//  Milestone4 Caption This
//
//  Created by Jason Pinlac on 1/15/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class Picture: NSObject, Codable {
    var imageName: String
    var quote: String
    
    init(imageName: String, quote: String) {
        self.imageName = imageName
        self.quote = quote
    }

}
