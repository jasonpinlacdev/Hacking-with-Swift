//
//  ViewController.swift
//  Project1 Storm Viewer
//
//  Created by Jason Pinlac on 9/20/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	var pictures: [String] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		let fm = FileManager.default
		let path = Bundle.main.resourcePath!
		var items = try! fm.contentsOfDirectory(atPath: path)
		items.sort()
		
		for item in items {
			if item.hasPrefix("nssl") {
				pictures.append(item)
			}
		}
		
		title = "Storm Viewer"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Recommend", style: .done, target: self, action: #selector(recommendTapped))
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pictures.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
		cell.textLabel?.text = pictures[indexPath.row]
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
			vc.selectedImage = pictures[indexPath.row]
			vc.title = "Picture \(indexPath.row + 1) of \(pictures.count)"
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	@objc func recommendTapped() {
		let vc = UIActivityViewController(activityItems: ["App Recommendation - Storm Viewer,\nYou have to try this app!"], applicationActivities: [])
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vc, animated: true)
	}

}

