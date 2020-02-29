//
//  Note.swift
//  Milestone7 iOS Imitation Notes App
//
//  Created by Jason Pinlac on 2/28/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import Foundation


class Note: Codable {
    var title: String
    var body: String
    var date: String
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
        
        let dateCreated = Date()
        date = DateFormatter.localizedString(from: dateCreated, dateStyle: .short, timeStyle: .none)
    }
}
