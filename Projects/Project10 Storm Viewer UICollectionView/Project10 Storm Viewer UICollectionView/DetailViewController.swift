//
//  DetailViewController.swift
//  Project10 Storm Viewer UICollectionView
//
//  Created by Jason Pinlac on 1/8/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedImage: String?
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let image = selectedImage {
            navigationItem.largeTitleDisplayMode = .never
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
            title = image
            imageView.image = UIImage(named: image)
        }
    }
    
    @objc func shareTapped() {
           guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
               print("The DetailViewController has no image.")
               return
           }
           
           guard let imageName = selectedImage else {
               print("The DetailViewController has no image name.")
               return
           }
           
           let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
           vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
           present(vc, animated: true)
       }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         navigationController?.hidesBarsOnTap = true
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillAppear(animated)
         navigationController?.hidesBarsOnTap = false
     }
}
