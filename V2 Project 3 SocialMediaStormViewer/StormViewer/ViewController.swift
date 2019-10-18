//
//  ViewController.swift
//  StormViewer
//
//  Created by Jason Pinlac on 10/17/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	var pictures = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let fm = FileManager.default
		let path = Bundle.main.resourcePath!
		let items = try! fm.contentsOfDirectory(atPath: path)
		for item in items {
			if item.hasPrefix("nssl") {
				print(item)
				pictures.append(item)
			}
		}
		pictures.sort()
		
		title = "Storm Viewer"
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	// MARK: - 3 methods - get number of rows in section and specify what each row should look like and what happens when you select a row
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
		// code for navigator controller which is responsible for maintaining and showing a big stack of screens/views that viewers navigate through. It pushes screens onto the navigtion controllers stack.
	}
}

