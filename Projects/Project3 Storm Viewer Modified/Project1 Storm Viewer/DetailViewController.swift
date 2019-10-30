//
//  DetailViewController.swift
//  Project1 Storm Viewer
//
//  Created by Jason Pinlac on 9/20/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	var selectedImage: String?
	
	@IBOutlet var imageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		navigationItem.largeTitleDisplayMode = .never
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
		
		if let imageToLoad = selectedImage {
			imageView.image = UIImage(named: imageToLoad)
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnTap = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.hidesBarsOnTap = false
	}
	
	@objc func shareTapped() {
		guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
			print("No image found")
			return
		}
		
		guard let imageName = selectedImage else {
			print("No image name found")
			return
		}
		
		let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vc, animated: true)
	}
}
