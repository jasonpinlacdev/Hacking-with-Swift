//
//  ViewController.swift
//  Project 4 Easy Browser
//
//  Created by Jason Pinlac on 10/19/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//


//  Important Concepts Learned
//  1. loadView() - loadView() is called before viewDidLoad(). loadView() is called first, and it's where you create your view; viewDidLoad() is called second, and it's where you configure the view that was loaded.

//  2. WKWebView
//  3. Delegation - Delegation is what allows us to customize the behavior of built-in types without having to sub-class them. To implement this design pattern you conform to a protocol
//  4. URL - URLs have their own specific data type in Swift, called URL.
//  5. URLRequest
//  6. UIToolbar - All view controllers have a toolbarItems property. This property is used to show buttons in a toolbar when the view controller is inside a navigation controller.
//  8. Key-Value observing - Key-value observing lets us monitor many kinds of properties.


import UIKit
//import WebKit

class ViewController: UITableViewController {
	
	let websites = ["www.apple.com", "www.hackingwithswift.com"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//  Do any additional setup after loading the view.
		
		
		navigationController?.isToolbarHidden = false
		title = "Select a Website"
	
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return websites.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Address", for: indexPath)
		cell.textLabel?.text = websites[indexPath.row]
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "Website") as? WebsiteViewController {
			vc.chosenWebsite = websites[indexPath.row]
			vc.websitesAllowed = websites
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	
	
	
}

