//
//  WhackSlot.swift
//  Project14 Whack-a-Penguin iPhone
//
//  Created by Jason Pinlac on 1/21/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    
    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        
        self.position = position
        
        // HOLE
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        // CROP NODE
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        // PENGUIN
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(for uptime: Double) {
        if isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.20))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (uptime * 5.0)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.20))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        isVisible = false
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.025))
    }
    
}
