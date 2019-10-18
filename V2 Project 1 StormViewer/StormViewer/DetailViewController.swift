//
//  DetailViewController.swift
//  StormViewer
//
//  Created by Jason Pinlac on 10/17/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	var selectedImage: String?
	
	@IBOutlet var stormImageView: UIImageView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		navigationItem.largeTitleDisplayMode = .never
		
		if let selectedImage = selectedImage {
			stormImageView.image = UIImage(named: selectedImage)
		}
		
    }

}
