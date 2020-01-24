//
//  Country.swift
//  Milestone5 API Countries
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
    var latlng: String
    var area: String
    var timezones: String
    var population: String
//    var languages: String
//    var currencies: String
    var flag: String
}
