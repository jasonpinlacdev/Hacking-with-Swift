//
//  CountryDetailTableViewController.swift
//  Milestone5 Countries of the World
//
//  Created by Jason Pinlac on 1/23/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class CountryDetailTableViewController: UITableViewController {
    
    var selectedCountry: Country?
    var details = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        if let country = selectedCountry {
            title = country.name
            
            details.append("Name: \(country.name)")
            details.append("Capital: \(country.capital)")
            details.append("Region: \(country.region)")
            details.append("Subregion: \(country.subregion)")
            details.append("Population: \(country.population)")
            details.append("Flag: \(country.flag)")
            
            var timeZoneStr = "Time Zones: "
            for timeZone in country.timezones {
                timeZoneStr += "\(timeZone), "
            }
            details.append(timeZoneStr)
            
    
            var languageStr = "Languages: "
            for language in country.languages {
                languageStr += "\(language), "
            }
            details.append(languageStr)
            
            for currency in country.currencies {
                if let currencyName = currency.name {
                    details.append("Currency Name: \(currencyName)")
                }
                if let currencyCode = currency.code {
                    details.append("Currency Code: \(currencyCode)")
                }
                if let currencySymbol = currency.symbol {
                    details.append("Currency Symbol: \(currencySymbol)")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        cell.textLabel?.text = details[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }

}
