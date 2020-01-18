//
//  Item.swift
//  Milestone2 ShoppingList V2
//
//  Created by Jason Pinlac on 1/17/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import Foundation

class Item: Codable {
    var description: String
    var isCompleted: Bool
    
    init(description: String, isCompleted: Bool) {
        self.description = description
        self.isCompleted = isCompleted
    }
}
