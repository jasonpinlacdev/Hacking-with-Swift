//
//  ViewController.swift
//  Milestone8 Extensions
//
//  Created by Jason Pinlac on 3/6/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit


extension UIView {
    func bounceOut(duration: TimeInterval, closure: ((Bool) -> Void)?) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 2, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { finished in
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 2, options: [], animations: {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: closure)
        })
    }
}


extension Int {
    func times(_ closure: (() -> Void)? = nil ) {
        guard let closure = closure else { return }
        guard self > 0 else { return }
        for _ in 0..<self {
            closure()
        }
    }
}

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let indexFound = self.firstIndex(of: item) {
            self.remove(at: indexFound)
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label1.text = "label1"
        label1.backgroundColor = UIColor.systemRed
        label1.textAlignment = NSTextAlignment.center
        
        label2.text = "label2"
        label2.backgroundColor = UIColor.systemRed
        label2.textAlignment = NSTextAlignment.center
        
        label3.text = "label3"
        label3.backgroundColor = UIColor.systemRed
        label3.textAlignment = NSTextAlignment.center
    }
    
    @IBAction func button1Tapped(_ sender: Any) {
        button1.isHidden = true
        label1.bounceOut(duration: 2.0) { [weak self] finished in
            self?.button1.isHidden = false
        }
    }
    
    
    @IBAction func button2Tapped(_ sender: Any) {
        5.times {
            print("Hello world!")
        }
    }
    
    
    @IBAction func button3Tapped(_ sender: Any) {
        var arr = [1,2,3]
        print(arr)
        arr.remove(item: 3)
        print(arr)
    }
    
}

