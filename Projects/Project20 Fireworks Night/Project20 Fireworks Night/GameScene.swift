//
//  GameScene.swift
//  Project20 Fireworks Night
//
//  Created by Jason Pinlac on 2/17/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var fireworks = [SKNode]()
    
    let leftEdge: CGFloat = -22.0
    let rightEdge: CGFloat = 896.0 + 22.0
    let topEdge: CGFloat = 414.0 + 22.0
    let bottomEdge: CGFloat = -22.0
    
    var gameTimer: Timer?
    
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel?.text = "Score: \(score)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width/2 + 50, y: size.height/2 - 150)
        background.zPosition = -1
        background.blendMode = SKBlendMode.replace
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 25, y: 25)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 24
        addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let nodesTouched = nodes(at: touchLocation)
        
        for case let rocketNode as SKSpriteNode in nodesTouched where rocketNode.name == "rocket" {
            rocketNode.name = "selected"
            rocketNode.colorBlendFactor = 0

            for firework in fireworks {
                if let rocketPart = firework.children.first as? SKSpriteNode {
                    if rocketPart.name == "selected" && rocketPart.color != rocketNode.color {
                        rocketPart.name = "rocket"
                        rocketPart.colorBlendFactor = 1
                    }
                }
            }
            
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.x < leftEdge - 100 || firework.position.x > rightEdge + 100 || firework.position.y < bottomEdge - 100 || firework.position.y > topEdge + 100 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    
    @objc func launchFireworks() {
        switch Int.random(in: 0...3) {
        case 0: //  left to right
            createFirework(xMovement: 2500, x: leftEdge, y: bottomEdge + 250)
            createFirework(xMovement: 3000, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: 4000, x: leftEdge, y: bottomEdge + 150)
            createFirework(xMovement: 5000, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: 7000, x: leftEdge, y: bottomEdge + 50)
        case 1: // right to left
            createFirework(xMovement: -2500, x: rightEdge, y: bottomEdge + 250)
            createFirework(xMovement: -3000, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -4000, x: rightEdge, y: bottomEdge + 150)
            createFirework(xMovement: -5000, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -7000, x: rightEdge, y: bottomEdge + 50)
        case 2: // stright up
            createFirework(xMovement: 0, x: size.width/2 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: size.width/2 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: size.width/2, y: bottomEdge)
            createFirework(xMovement: 0, x: size.width/2 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: size.width/2 + 200, y: bottomEdge)
        case 3: // fan up
            createFirework(xMovement: -1000, x: size.width/2 - 50, y: bottomEdge)
            createFirework(xMovement: -500, x: size.width/2 - 25, y: bottomEdge)
            createFirework(xMovement: 0, x: size.width/2, y: bottomEdge)
            createFirework(xMovement: 500, x: size.width/2 + 25, y: bottomEdge)
            createFirework(xMovement: 1000, x: size.width/2 + 50, y: bottomEdge)
        default:
            break
        }
    }

    
    func createFirework(xMovement: CGFloat, x: CGFloat, y: CGFloat) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        node.name = "firework"
        addChild(node)
        
        let rocket = SKSpriteNode(imageNamed: "rocket")
        rocket.position = CGPoint(x: 0, y: 0)
        rocket.colorBlendFactor = 1
        rocket.name = "rocket"
        switch Int.random(in: 0...2) {
        case 0:
        rocket.color = UIColor.green
        case 1:
        rocket.color = UIColor.cyan
        case 2:
        rocket.color = UIColor.red
        default:
        break
        }
        node.addChild(rocket)
        
        if let fuse = SKEmitterNode(fileNamed: "fuse") {
            fuse.position = CGPoint(x: 0, y: -22)
            fuse.name = "fuse"
            node.addChild(fuse)
        }
        
        let path = UIBezierPath()
        path.move(to: .zero) // move to zero point so it will starts where the rocket starts
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        let follow = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 100)
        node.run(follow)
        
        fireworks.append(node)
    }
    
    
    func explode(firework: SKNode) {
        if let explosion = SKEmitterNode(fileNamed: "explode") {
            explosion.position = firework.position
            addChild(explosion)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak explosion] in
                explosion?.removeFromParent()
            }
        }
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        for (index, firework) in fireworks.enumerated().reversed() {
            guard let rocketPart = firework.children.first as? SKSpriteNode else { continue }
            if rocketPart.name == "selected" {
                explode(firework: firework)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        if numExploded > 0 {
            let points = numExploded * numExploded
              let pointsLabel = SKLabelNode(fontNamed: "Chalkduster")
              pointsLabel.position = CGPoint(x: Int.random(in: 25...150), y: 75)
              pointsLabel.text = "+\(points)"
              pointsLabel.fontSize = 24 + CGFloat(points)
              addChild(pointsLabel)
              
              let fade = SKAction.fadeOut(withDuration: 1)
              let remove = SKAction.run { [weak pointsLabel] in
                  pointsLabel?.removeFromParent()
              }
              let sequence = SKAction.sequence([fade, remove])
              pointsLabel.run(sequence)
              
              score += points
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        explodeFireworks()
    }
}
