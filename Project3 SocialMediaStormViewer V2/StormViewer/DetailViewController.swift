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
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
		
		if let selectedImage = selectedImage {
			stormImageView.image = UIImage(named: selectedImage)
		}
    }
	
	@objc func shareTapped() {
		guard let stormImageName = selectedImage else {
			print("No image name found")
			return
		}
		
		guard let stormImage = stormImageView.image?.jpegData(compressionQuality: 1.0) else {
			print("No image found")
			return
		}
		
		let vc = UIActivityViewController(activityItems: [stormImage, stormImageName], applicationActivities: [])
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vc, animated: true)
	}

}
