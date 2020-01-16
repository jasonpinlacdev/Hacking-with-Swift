//
//  DetailViewController.swift
//  Milestone4 Caption This
//
//  Created by Jason Pinlac on 1/15/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedPicture: Picture!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var quoteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedPicture = selectedPicture else { return }
        imageView.image = UIImage(contentsOfFile: getApplicationDocumentsDirectory().appendingPathComponent(selectedPicture.imageName).path)
        quoteLabel.text = selectedPicture.quote
        quoteLabel.layer.borderColor = UIColor.white.cgColor
        quoteLabel.layer.borderWidth = 3
        quoteLabel.layer.masksToBounds = true
        quoteLabel.layer.cornerRadius = 30
    }
    
    func getApplicationDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
