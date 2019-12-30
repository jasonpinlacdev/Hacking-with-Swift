//
//  FlagViewController.swift
//  Milestone1 Country Flag
//
//  Created by Jason Pinlac on 12/12/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class FlagViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var selectedFlag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let selectedFlag = selectedFlag {
            imageView.image = UIImage(named: selectedFlag)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        }
    }
    
    @objc func share() {
        guard let image = imageView.image?.jpegData(compressionQuality: 1) else {
            print("No image available to share.")
            return
        }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
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
