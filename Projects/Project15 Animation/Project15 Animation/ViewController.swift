//
//  ViewController.swift
//  Project15 Animation
//
//  Created by Jason Pinlac on 1/22/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView: UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 207, y: 448)
        view.addSubview(imageView)
    }


    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true
        
        
//        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations:  {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            case 1:
                self.imageView.transform = .identity
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -100, y: -200)
            case 3:
                self.imageView.transform = .identity
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            case 5:
                self.imageView.transform = .identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .systemGreen
            case 7:
                self.imageView.alpha = 1.0
                self.imageView.backgroundColor = .clear
            default:
                break
            }
            
        }) { finished in
            sender.isHidden = false
            
        }
        
        
        currentAnimation += 1
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
}

