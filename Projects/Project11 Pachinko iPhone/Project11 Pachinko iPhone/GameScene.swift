//
//  GameScene.swift
//  Project11 Pachinko iPhone
//
//  Created by Jason Pinlac on 1/10/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var balls = 0 {
        didSet {
            ballsLabel.text = "Balls: \(balls)"
        }
    }
    
    var scoreLabel: SKLabelNode!
    var ballsLabel: SKLabelNode!
    var leftLabel: SKLabelNode!
    var middleLabel: SKLabelNode!
    var rightLabel: SKLabelNode!
    var resetLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        setupBackground()
        
        addSlot(at: CGPoint(x: 69, y: 0), isGood: false)
        addSlot(at: CGPoint(x: 207, y: 0), isGood: true)
        addSlot(at: CGPoint(x: 345, y: 0), isGood: false)
        
        addBouncer(at: CGPoint(x: 0, y: 0))
        addBouncer(at: CGPoint(x: 138, y: 0))
        addBouncer(at: CGPoint(x: 276, y: 0))
        addBouncer(at: CGPoint(x: 414, y: 0))
        
        addEvenRow(at: 800)
        addOddRow(at: 700)
        addEvenRow(at: 600)
        addOddRow(at: 500)
        addEvenRow(at: 400)
        addOddRow(at: 300)
        addEvenRow(at: 200)
        addOddRow(at: 100)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let objectsTouched = nodes(at: touchLocation)
        
        if objectsTouched.contains(resetLabel) {
            balls = 0
            score = 0
        } else {
            let ball = SKSpriteNode(imageNamed: "ballRed")
            ball.size = CGSize(width: 25, height: 25)
            ball.position = CGPoint(x: touchLocation.x, y: 896)
            //        ball.position = touchLocation
            ball.name = "ball"
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
            ball.physicsBody?.restitution = 0.4
            // This line of code below allow us to detect collisions
            ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
            addChild(ball)
            balls += 1
        }
    }
    
    func setupBackground() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsWorld.contactDelegate = self
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: 414, height: 896)
        background.position = CGPoint(x: 207, y: 448)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        resetLabel = SKLabelNode(fontNamed: "Chalkduster")
        resetLabel.text = "Reset"
        resetLabel.fontSize = 20
        resetLabel.horizontalAlignmentMode = .left
        resetLabel.position = CGPoint(x: 20, y: 866)
        addChild(resetLabel)
        
        ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLabel.text = "Balls: \(balls)"
        ballsLabel.fontSize = 20
        ballsLabel.horizontalAlignmentMode = .left
        ballsLabel.position = CGPoint(x: 20, y: 836)
        addChild(ballsLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 20
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 20, y: 816)
        addChild(scoreLabel)
        
        leftLabel = SKLabelNode(fontNamed: "Chalkduster")
        leftLabel.text = "-1"
        leftLabel.position = CGPoint(x: 63.5, y: 50)
        addChild(leftLabel)
        
        middleLabel = SKLabelNode(fontNamed: "Chalkduster")
        middleLabel.text = "+10"
        middleLabel.position = CGPoint(x: 207, y: 50)
        addChild(middleLabel)
        
        rightLabel = SKLabelNode(fontNamed: "Chalkduster")
        rightLabel.text = "-1"
        rightLabel.position = CGPoint(x: 350.5, y: 50)
        addChild(rightLabel)
    }
    
    func addBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.size = CGSize(width: 75, height: 75)
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func addSlot(at position: CGPoint, isGood: Bool) {
        let slot: SKSpriteNode
        let glow: SKSpriteNode
        if isGood {
            slot = SKSpriteNode(imageNamed: "slotBaseGood")
            slot.name = "good"
            glow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slot = SKSpriteNode(imageNamed: "slotBaseBad")
            slot.name = "bad"
            glow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        
        slot.size = CGSize(width: 63, height: 2)
        slot.position = position
        slot.physicsBody = SKPhysicsBody(rectangleOf: slot.size)
        slot.physicsBody?.isDynamic = false
        addChild(slot)
        
        glow.size = CGSize(width: 100, height: 100)
        glow.position = position
        let spin  = SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        glow.run(spinForever)
        addChild(glow)
    }
    
    func addEvenRow(at height: Int) {
        for i in 0..<7 {
            let peg = SKSpriteNode(imageNamed: "ballGrey")
            peg.size = CGSize(width: 10, height: 10)
            peg.position = CGPoint(x: i * 69, y: height)
            peg.physicsBody = SKPhysicsBody(circleOfRadius: peg.size.width/2)
            peg.physicsBody?.isDynamic = false
            addChild(peg)
        }
    }
    
    func addOddRow(at height: Double) {
        for i in 1..<7 {
            let peg = SKSpriteNode(imageNamed: "ballGrey")
            peg.size = CGSize(width: 10, height: 10)
            peg.position = CGPoint(x: ((Double(i) * 69)) - 34.5, y: height)
            peg.physicsBody = SKPhysicsBody(circleOfRadius: peg.size.width/2)
            peg.physicsBody?.isDynamic = false
            addChild(peg)
        }
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            score += 10
            destroy(ball: ball)
        } else if object.name == "bad" {
            score -= 1
            destroy(ball: ball)
        }
    }
    
    func destroy(ball: SKNode) {
        if let fire = SKEmitterNode(fileNamed: "FireParticles") {
            fire.position = ball.position
            addChild(fire)
        }
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
}
