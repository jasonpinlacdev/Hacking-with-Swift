//
//  ViewController.swift
//  Milestone5 API Countries
//
//  Created by Jason Pinlac on 1/23/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var apiEndpoint = "https://restcountries.eu/rest/v2/alpha/col"
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJSONData()
    }
    
    func getJSONData() {
        if let url = URL(string: apiEndpoint)  {
            if let data = try? Data(contentsOf: url)  {
                print(data)
                let decoder = JSONDecoder()
                if let jsonCountries = try? decoder.decode([Country].self, from: data) {
                    print(jsonCountries)
                    return
                }
            }
        }
        displayErrorForAPI()
    }
    
    func displayErrorForAPI() {
        let ac = UIAlertController(title: "Error", message: "Failed to get data from API\n \"\(apiEndpoint)\"", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(ac, animated: true)
    }
    
}

