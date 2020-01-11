//
//  GameScene.swift
//  Project11 Pachinko
//
//  Created by Jason Pinlac on 1/9/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var editLabel: SKLabelNode!
    var ballsLabel: SKLabelNode!
    var ballTypes = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
    var balls = 0 {
        didSet {
            ballsLabel.text = "Balls: \(balls)"
        }
    }
    var inEditingMode = true {
        didSet {
            if inEditingMode == true {
                editLabel.text = "Edit Mode"
            } else {
                editLabel.text = "Ball Mode"
                balls += 10
            }
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        self.addChild(background)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        editLabel = SKLabelNode(fontNamed: "ChalkDuster")
        editLabel.text = "Edit Mode"
        editLabel.horizontalAlignmentMode = .left
        editLabel.position = CGPoint(x: 50, y: 700)
        addChild(editLabel)
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 50, y: 650)
        addChild(scoreLabel)
        ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLabel.text = "Balls: \(balls)"
        ballsLabel.horizontalAlignmentMode = .left
        ballsLabel.position = CGPoint(x: 50, y: 600)
        addChild(ballsLabel)
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            inEditingMode.toggle()
        } else {
            if inEditingMode {
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0), size: CGSize(width: CGFloat.random(in: 16...128), height: 16))
                box.name = "obstacle"
                box.zRotation = CGFloat.random(in: 0...(2*CGFloat.pi))
                box.position = location
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                
                addChild(box)
            } else {
                if balls > 0 {
                    balls -= 1
                    let ball = SKSpriteNode(imageNamed: ballTypes[Int.random(in: 0..<ballTypes.count)])
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.restitution = 1.0
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                    ball.position = CGPoint(x: location.x, y: 768)
                    ball.name = "ball"
                    self.addChild(ball)
                }
            }
        }
    }
    
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        self.addChild(bouncer)
    }
    
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        if isGood {
            slotBase =  SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        slotGlow.position = position
        let spin  = SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
        self.addChild(slotBase)
        self.addChild(slotGlow)
    }
    
    
    func collison(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            score += 1
            balls += 1
            destroy(ball: ball)
        } else if object.name == "bad" {
            score -= 1
            destroy(ball: ball)
        } else if object.name == "obstacle"{
            destroy(obstacle: object)
        }
    }
    
    func destroy(obstacle: SKNode) {
        obstacle.removeFromParent()
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name == "ball" {
            collison(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collison(between: nodeB, object: nodeA)
        }
    }
    
}
