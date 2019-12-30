//
//  Petition.swift
//  Project7 Whitehouse Petitions
//
//  Created by Jason Pinlac on 12/29/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
