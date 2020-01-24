//
//  ViewController.swift
//  Milestone5 Countries of the World
//
//  Created by Jason Pinlac on 1/23/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit


class ViewController: UITableViewController {
    
    var endpoint = "https://restcountries.eu/rest/v2/all"
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJSONData()
    }
    
    func getJSONData() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = URL(string: (self?.endpoint)!) {
                if let jsonData = try? Data(contentsOf: url) {
                    let decoder = JSONDecoder()
                    if let jsonCountries = try? decoder.decode([Country].self, from: jsonData) {
                        self?.countries = jsonCountries
                        DispatchQueue.main.async { [weak self] in
                            self?.tableView.reloadData()
                            self?.title = "\((self?.countries.count)!) Countries & Territories of the World"
                        }
                        return
                    }
                }
            }
            self?.displayErrorForAPI()
        }
    }
    
    func displayErrorForAPI() {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Error", message: "Failed to get data from API\n \"\((self?.endpoint)!)\"", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? CountryDetailTableViewController {
            vc.selectedCountry = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
