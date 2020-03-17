//
//  DetailViewController.swift
//  Project1 Storm Viewer
//
//  Created by Jason Pinlac on 12/11/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageStr = selectedImage {
            guard let image = UIImage(named: imageStr) else { return }
            
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: image.size.width, height: image.size.height))
            let renderedImage = renderer.image {
                ctx in
                // 1 draw the image in
                image.draw(at: CGPoint(x: 0, y: 0))
                
                // 2 draw the text
                let str = "From Storm Viewer"
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 100),
                    .foregroundColor: UIColor.red,
                ]
                let attributedStr = NSAttributedString(string: str, attributes: attributes)
                attributedStr.draw(at: CGPoint(x: 100, y: 20))
            }
            
            imageView.image = renderedImage
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
