//
//  Target.swift
//  Milestone6-Shooting-Gallery
//
//  Created by Jason Pinlac on 2/7/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit
import SpriteKit

class Target: SKNode {
    
    var target: SKSpriteNode!
    var stick: SKSpriteNode!
    
    var possibleTargets = ["target0", "target1", "target2"]
    var possibleSticks = ["stick0", "stick1", "stick2"]
    
    func setup() {
        stick = SKSpriteNode(imageNamed: possibleSticks.randomElement()!)
        stick.position = CGPoint(x: 0, y: 0)
        addChild(stick)
        target = SKSpriteNode(imageNamed: possibleTargets.randomElement()!)
        target.position = CGPoint(x: 0, y: stick.size.height - 10)
//        target.name = "target"
        addChild(target)
    }
    
    
    
}
