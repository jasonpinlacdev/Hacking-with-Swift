//
//  GameScene.swift
//  Project26 Marble Maze
//
//  Created by Jason Pinlac on 3/10/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion


enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case teleport = 16
    case finish = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var isGameOver = false
    var motionManager: CMMotionManager?
    
    var player: SKSpriteNode!
    var playerStartPosition: CGPoint?
    var lastTouchPosition: CGPoint?
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel?.text = "Score: \(score)"
        }
    }
    
    var levels = [String]()
    var currentLevel = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
        
        addBackground()
        getLevelsFromTxtFile()
        loadLevel(currentLevel)
    }
    
    func addBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 24
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 40, y: size.height - 25)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
    }
    
    func getLevelsFromTxtFile() {
        guard let levelsURL = Bundle.main.url(forResource: "mylevels", withExtension: "txt") else { fatalError("Could not find mylevels.txt in the app bundle.") }
        guard let levelsString = try? String(contentsOf: levelsURL) else { fatalError("Could not use mylevels.txt URL.") }
        
        let levelsStringTrimmed = levelsString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        levels = levelsStringTrimmed.components(separatedBy: "||")
    }
    
    func loadLevel(_ level: Int) {
        isGameOver = false
        removeAllChildren()
        addBackground()
        
        let trimmedLevel = levels[level].trimmingCharacters(in: .whitespacesAndNewlines)
        let lines = trimmedLevel.components(separatedBy: "\n")
        
        // reading from bottom to top, left to right
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                
                let position = CGPoint(x: (34.5 * CGFloat(column)) + 17.25, y: (34.5 * CGFloat(row)) + 17.25)
                
                if letter == "x" {
                    createWall(position: position)
                } else if letter == "v" {
                    createVortex(position: position)
                } else if letter == "s" {
                    createStar(position: position)
                } else if letter == "f" {
                    createFinish(position: position)
                } else if letter == "p" {
                    createPlayer(position: position)
                    playerStartPosition = position
                } else if letter == "t" {
                    createTeleport(position: position)
                } else if letter == " " {
                    // do nothing
                } else {
                    fatalError("Unknown level letter \(letter).")
                }
            }
        }
    }
    
    func createTeleport(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "teleport")
        node.position = position
        node.scale(to: CGSize(width: 34.5, height: 34.5))
        node.name = "teleport"
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        node.physicsBody?.collisionBitMask = .zero
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 5)))
        node.colorBlendFactor = 0.99
        node.color = UIColor.systemRed
        addChild(node)
    }
    
    func createFinish(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.scale(to: CGSize(width: 34.5, height: 34.5))
        node.position = position
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.collisionBitMask = .zero
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        addChild(node)
    }
    
    func createStar(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.scale(to: CGSize(width: 34.5, height: 34.5))
        node.name = "star"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 5)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.collisionBitMask = .zero
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        addChild(node)
    }
    
    func createWall(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.scale(to: CGSize(width: 34.5, height: 34.5))
        node.position = position
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    func createVortex(position: CGPoint){
        let node = SKSpriteNode(imageNamed: "vortex")
        node.scale(to: CGSize(width: 34.5, height: 34.5))
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 0.5)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2 - 10)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.collisionBitMask = .zero
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        addChild(node)
    }
    
    func createPlayer(position: CGPoint) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = position
        player.zPosition = 1
        player.scale(to: CGSize(width: 22, height: 22))
        player.name = "player"
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.1
        //
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        //        player.physicsBody?.contactTestBitMask = 28
        //        the pipe operator below is used to add the raw values together
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.teleport.rawValue
        addChild(player)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }
        
        #if targetEnvironment(simulator)
        guard let lastTouchPosition = lastTouchPosition else { return }
        let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
        physicsWorld.gravity = CGVector(dx: diff.x/100.0, dy: diff.y/100.0)
        #else
        guard let accelerometerData = motionManager?.accelerometerData else { return }
        // flip coordinates around because you rotated the phone in landscape mode so X become Y and vise-versa
        physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * 9.8, dy: -accelerometerData.acceleration.x * 9.8)
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // we need these guards here because the didBegin method gets called multiple times A -> B, B -> A, or even Unknown as in both at the same time.
        print("didBeginContact method invoked")
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "player" {
            if nodeB.name == "vortex" {
                nodeA.physicsBody?.isDynamic = false
                isGameOver = true
                score -= 1
                let move = SKAction.move(to: nodeB.position, duration: 0.25)
                let scaleDown = SKAction.scale(by: 0.05, duration: 0.25)
                let remove = SKAction.removeFromParent()
                let sequence = SKAction.sequence([move, scaleDown, remove])
                nodeA.run(sequence) {
                    [weak self] in
                    self?.createPlayer(position: (self?.playerStartPosition)!)
                    self?.isGameOver = false
                }
            } else if nodeB.name == "star" {
                score += 1
                let fade = SKAction.fadeOut(withDuration: 0.25)
                let scale = SKAction.scale(by: 0.05, duration: 0.25)
                let group = SKAction.group([fade, scale])
                let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
                nodeB.run(sequence)
            } else if nodeB.name == "teleport" {
                playerStartPosition = nodeB.position
                let fade = SKAction.fadeOut(withDuration: 0.25)
                let scale = SKAction.scale(by: 0.05, duration: 0.25)
                let group = SKAction.group([fade, scale])
                let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
                nodeB.run(sequence)
            } else if nodeB.name == "finish" {
                // Go to the next level
                isGameOver = true
                score = 0
                nodeA.physicsBody?.isDynamic = false
                nodeA.removeFromParent()
                if currentLevel == 1 {
                    currentLevel = 0
                } else {
                    currentLevel = 1
                }
                loadLevel(currentLevel)
            }
        } else if nodeB.name == "player" {
            if nodeA.name == "vortex" {
                nodeB.physicsBody?.isDynamic = false
                isGameOver = true
                score -= 1
                let move = SKAction.move(to: nodeA.position, duration: 0.25)
                let scaleDown = SKAction.scale(by: 0.05, duration: 0.25)
                let remove = SKAction.removeFromParent()
                let sequence = SKAction.sequence([move, scaleDown, remove])
                nodeB.run(sequence) {
                    [weak self] in
                    self?.createPlayer(position: (self?.playerStartPosition)!)
                    self?.isGameOver = false
                }
            } else if nodeA.name == "teleport" {
                playerStartPosition = nodeA.position
                let fade = SKAction.fadeOut(withDuration: 0.25)
                let scale = SKAction.scale(by: 0.05, duration: 0.25)
                let group = SKAction.group([fade, scale])
                let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
                nodeA.run(sequence)
            }
            else if nodeA.name == "star" {
                score += 1
                let fade = SKAction.fadeOut(withDuration: 0.25)
                let scale = SKAction.scale(by: 0.05, duration: 0.25)
                let group = SKAction.group([fade, scale])
                let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
                nodeA.run(sequence)
            } else if nodeA.name == "finish" {
                // Go to the next level
                isGameOver = true
                score = 0
                nodeB.physicsBody?.isDynamic = false
                nodeB.removeFromParent()
                if currentLevel == 1 {
                    currentLevel = 0
                } else {
                    currentLevel = 1
                }
                loadLevel(currentLevel)
            }
        }
    }
    
}
