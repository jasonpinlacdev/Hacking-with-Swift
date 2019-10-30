//
//  ViewController.swift
//  Milestone 1 Table of Countries
//
//  Created by Jason Pinlac on 10/30/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	var countries: [String] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationConfiguration()
		getContent()

	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return countries.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
		cell.textLabel?.text = countries[indexPath.row]
		cell.imageView?.image = UIImage(named: countries[indexPath.row])
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(identifier: "Country") as? CountryViewController {
			vc.countrySelected = countries[indexPath.row]
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	func navigationConfiguration() {
		title = "Select a Country"
		navigationController?.navigationBar.prefersLargeTitles = true
	}

	func getContent() {
		let fm = FileManager.default
		let path = Bundle.main.resourcePath!
		let items = try! fm.contentsOfDirectory(atPath: path)
		for item in items {
			if item.hasPrefix("flag-") {
				countries.append(item)
			}
		}
		countries.sort()
	}

}

