//
//  CardButton.swift
//  Milestone10 Concentration
//
//  Created by Jason Pinlac on 4/14/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class CardButton: UIButton {
    
    var content = ""
    var isFlippedToShowContent = false
    var isMatched = false
    
    func configure(content: String) {
        self.content = content
        
        setTitle("", for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 72)
        
        backgroundColor = UIColor.systemRed
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 8.0
        clipsToBounds = true
    }
    
    func flipUp() {
        guard !isFlippedToShowContent else { return }
        setTitle(content, for: .normal)
        backgroundColor = UIColor.white
        isFlippedToShowContent = true
    }
    
    func flipDown() {
        guard isFlippedToShowContent else { return }
        setTitle("", for: .normal)
        backgroundColor = UIColor.systemRed
        isFlippedToShowContent = false
    }
    
    func blackOut() {
        flipDown()
        backgroundColor = UIColor.black
        layer.borderColor = UIColor.black.cgColor
    }
    
}
