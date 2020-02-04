//
//  GameScene.swift
//  Project11 Pachinko Practice
//
//  Created by Jason Pinlac on 1/31/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var editLabel: SKLabelNode!
    var edit = true {
        didSet {
            if edit {
                editLabel?.text = "Edit Mode"
            } else {
                editLabel?.text = "Play Mode"
            }
        }
    }
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel?.text = "score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        // puts a physics border around screen frame.
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        setBackground()
        for i in 0..<5 {
            createBouncer(at: CGPoint(x: CGFloat(i) * (self.frame.size.width/4), y: 0))
        }
        
        for i in 0..<5 {
            createSlot(at: CGPoint(x: (CGFloat(i) * (self.frame.size.width/4)) + (self.frame.size.width/8), y: 0), isGood: (i % 2 == 0))
        }
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 18
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 30, y: self.frame.height - 30)
        self.addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit Mode"
        editLabel.horizontalAlignmentMode = .right
        editLabel.fontSize = 18
        editLabel.position = CGPoint(x: self.frame.width - 30, y: self.frame.height - 30)
        self.addChild(editLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let touchedNodes = nodes(at: touchLocation)
            if touchedNodes.contains(editLabel) {
                edit.toggle()
            } else {
                if edit {
                    createObstacle(at: touchLocation)
                } else {
                    createBall(at: touchLocation)
                }
            }
        }
    }
    
    func setBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: frame.size.width, height: frame.size.width)
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background.zPosition = -1
        // Colors of the node replace the background scene so no calculations for alpha transparency need to be made making it the fastest possible drawing mode.
        background.blendMode = .replace
        addChild(background)
    }
    
    func createBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.zPosition = 2
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2)
        // The physics body ignores all forces on it. It will not move.
        bouncer.physicsBody?.isDynamic = false
        self.addChild(bouncer)
    }
    
    func createSlot(at position: CGPoint, isGood: Bool) {
        let slot: SKSpriteNode
        let glow: SKSpriteNode
        if isGood  {
            slot = SKSpriteNode(imageNamed: "slotBaseGood")
            slot.name = "good"
            glow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slot = SKSpriteNode(imageNamed: "slotBaseBad")
            slot.name = "bad"
            glow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        
        
        slot.position = position
        slot.zPosition = 1
        slot.physicsBody = SKPhysicsBody(rectangleOf: slot.size)
        slot.physicsBody?.isDynamic = false
        self.addChild(slot)
        
        glow.position = position
        glow.zPosition = 1
        let rotate = SKAction.rotate(byAngle: 2.0 * CGFloat.pi, duration: 10)
        let rotateForever = SKAction.repeatForever(rotate)
        glow.run(rotateForever)
        self.addChild(glow)
    }
    
    func createBall(at position: CGPoint) {
        let ball: SKSpriteNode
        switch Int.random(in: 1...7) {
        case 1:
            ball = SKSpriteNode(imageNamed: "ballRed")
        case 2:
            ball = SKSpriteNode(imageNamed: "ballYellow")
        case 3:
            ball = SKSpriteNode(imageNamed: "ballBlue")
        case 4:
            ball = SKSpriteNode(imageNamed: "ballCyan")
        case 5:
            ball = SKSpriteNode(imageNamed: "ballGreen")
        case 6:
            ball = SKSpriteNode(imageNamed: "ballGrey")
        case 7:
            ball = SKSpriteNode(imageNamed: "ballPurple")
        default:
            ball = SKSpriteNode(imageNamed: "ballRed")
        }
        
        ball.position = CGPoint(x: position.x, y: self.size.height)
        ball.zPosition = 2
        ball.name = "ball"
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.restitution = 0.8
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
        self.addChild(ball)
    }
    
    func createObstacle(at position: CGPoint) {
        let randomWidth = Int.random(in: 10...35)
        let randomHeight = Int.random(in: 10...100)
        let randomColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        let obstacle = SKSpriteNode(color: randomColor, size: CGSize(width: randomWidth, height: randomHeight))
        obstacle.zRotation = CGFloat.random(in: 0...CGFloat.pi)
        obstacle.name = "obstacle"
        obstacle.position = position
        obstacle.zPosition = 2
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        addChild(obstacle)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // This method is called multiple times per contact because you have two objects colliding with each other at the same time and each object collision calls this method. Be careful if you're force unwraping a contact node. This will cause your program to crash if a contact node has been removed from parent the the subsequent didBeginContact methods execute as the response to a collision. The subsequent call will try to force unwrap the contact object that has been removed from the previous execution of hte didBeginContact method. These guard statements below protect the program from crashing if a contact object has already been dealocated on the first didBeginContact method execution.
        guard let contactA = contact.bodyA.node else { return }
        guard let contactB = contact.bodyB.node else { return }
        
        if contactA.name == "ball" && (contactB.name == "good" || contactB.name == "bad") {
            let fire = SKEmitterNode(fileNamed: "FireParticles")!
            fire.position = contact.bodyA.node!.position
            fire.zPosition = 2
            self.addChild(fire)
            contactA.removeFromParent()
            if contactB.name == "good" {
                score += 1
            } else {
                score -= 1
            }
        } else if contactB.name == "ball" && (contactA.name == "good" || contactA.name == "bad") {
            let fire = SKEmitterNode(fileNamed: "FireParticles")!
            fire.position = contact.bodyA.node!.position
            fire.zPosition = 2
            self.addChild(fire)
            contactB.removeFromParent()
            if contactA.name == "good" {
                score += 1
            } else {
                score -= 1
            }
        } else if contactA.name == "ball" && contactB.name == "obstacle" {
            contactB.removeFromParent()
        } else if contactB.name == "ball" && contactA.name == "obstacle" {
            contactA.removeFromParent()
        }
    }
}
