//
//  Country.swift
//  Milestone5 Countries of the World
//
//  Created by Jason Pinlac on 1/23/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import Foundation

struct Country: Codable {
    var name: String
    var capital: String
    var region: String
    var subregion: String
    var population: Int
    var flag: String
    var timezones: [String]
    var languages: [Language]
    var currencies: [Currency]
}

struct Language: Codable {
    var name: String
}

struct Currency: Codable {
    var code: String?
    var name: String?
    var symbol: String?
}

