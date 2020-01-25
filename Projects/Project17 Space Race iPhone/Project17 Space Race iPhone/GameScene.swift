//
//  GameScene.swift
//  Project17 Space Race iPhone
//
//  Created by Jason Pinlac on 1/24/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var gameOver: SKSpriteNode!
    
    var enemiesEvaded = 0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var isGameOver = false
    var gameTimer: Timer?
    var timeInterval = 0.8
    let possibleEnemies = ["hammer", "ball", "tv"]
    
    
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        starField = SKEmitterNode(fileNamed: "starfield")
        starField.zPosition = -1
        starField.position = CGPoint(x: 896, y: 207)
        starField.advanceSimulationTime(5)
        addChild(starField)
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 150, y: 207)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 15, y: 15)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in self.children {
            if node.position.x < -100 {
                node.removeFromParent()
                enemiesEvaded += 1
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    @objc func createEnemy() {
        if !isGameOver {
            
            if timeInterval > 0.6 && enemiesEvaded >= 10 && enemiesEvaded % 10 == 0 {
                gameTimer?.invalidate()
                timeInterval -= 0.1
                gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            }
            
            
            guard let enemy = possibleEnemies.randomElement() else { return }
            let sprite = SKSpriteNode(imageNamed: enemy)
            sprite.position = CGPoint(x: 950, y: Int.random(in: 0...414))
            addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.categoryBitMask = 1
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.angularVelocity = 5
            sprite.physicsBody?.linearDamping = 0
            sprite.physicsBody?.angularDamping = 0
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        // clamp boundaries
        if location.y < 30 {
            location.y = 30
        } else if location.y > 384 {
            location.y = 384
        }
        
        if location.x < 50 {
            location.x = 50
        } else if location.x > 846{
            location.x = 846
        }
        
        player.position = location
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        isGameOver = true
        player.removeFromParent()
        gameTimer?.invalidate()
        self.view?.isUserInteractionEnabled = false
        
        gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 448, y: 207)
        addChild(gameOver)
        
        guard let explosion = SKEmitterNode(fileNamed: "explosion") else { return }
        explosion.position = player.position
        addChild(explosion)
        DispatchQueue.global().async { [weak self] in
            self?.run(SKAction.playSoundFileNamed("bomb.wav", waitForCompletion: false))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameOver {
            isGameOver = true
            player.removeFromParent()
            gameTimer?.invalidate()
            self.view?.isUserInteractionEnabled = false
            
            gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 448, y: 207)
            addChild(gameOver)
            
            guard let explosion = SKEmitterNode(fileNamed: "explosion") else { return }
            explosion.position = player.position
            addChild(explosion)
            DispatchQueue.global().async { [weak self] in
                self?.run(SKAction.playSoundFileNamed("bomb.wav", waitForCompletion: false))
            }
        }
    }
    
//    func startNewGame() {
//        isGameOver = false
//        score = 0
//        timeInterval = 0.8
//        enemiesEvaded = 0
//        self.view?.isUserInteractionEnabled = true
//
//        player = SKSpriteNode(imageNamed: "player")
//        player.position = CGPoint(x: 150, y: 207)
//        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
//        player.physicsBody?.contactTestBitMask = 1
//        addChild(player)
//
//        gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
//    }
    
}
