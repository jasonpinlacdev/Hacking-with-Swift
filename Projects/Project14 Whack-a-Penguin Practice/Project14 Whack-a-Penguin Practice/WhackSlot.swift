//
//  WhackSlot.swift
//  Project14 Whack-a-Penguin Practice
//
//  Created by Jason Pinlac on 2/4/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    var isVisible = false
    var isHit = false
    
    var penguin: SKSpriteNode!

    func configure(at position: CGPoint) {
        self.position = position
        
        let hole = SKSpriteNode(imageNamed: "whackHole")

        let mask = SKCropNode()
        mask.position = CGPoint(x: 0, y: 15)
        mask.zPosition = 1
        mask.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        penguin = SKSpriteNode(imageNamed: "penguinGood")
        penguin.position = CGPoint(x: 0, y: -90)
        
        self.addChild(mask)
        self.addChild(hole)
        mask.addChild(penguin)
    }
    
    
    func show(showTime: Double) {
        if isVisible { return }
        
        if Int.random(in: 0...2) == 0 {
            penguin.texture = SKTexture(imageNamed: "penguinGood")
            penguin.name = "penguinFriend"
        } else {
            penguin.texture = SKTexture(imageNamed: "penguinEvil")
            penguin.name = "penguinEnemy"
        }
        
        penguin.setScale(1.0)
        let moveUp = SKAction.moveBy(x: 0, y: 85, duration: 0.15)
        penguin.run(moveUp)
        isVisible = true
        isHit = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (showTime * Double.random(in: 1.0...2.0))) { [weak self] in
            if !(self?.isHit)! && (self?.isVisible)! {
                self?.hide()
            }
        }
    }
    
    func hide() {
        let moveDown = SKAction.moveBy(x: 0, y: -85, duration: 0.15)
        penguin.run(moveDown)
        isVisible = false
        isHit = false
    }
  
    func hit() {
        self.isHit = true
        let delay = SKAction.wait(forDuration: 0.10)
        let moveDown = SKAction.moveBy(x: 0, y: -85, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
        let sequence = SKAction.sequence([delay, moveDown, notVisible])
        penguin.setScale(0.75)
        penguin.run(sequence)
    }
}
