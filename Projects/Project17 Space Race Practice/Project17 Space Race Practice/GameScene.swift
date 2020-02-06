//
//  GameScene.swift
//  Project17 Space Race Practice
//
//  Created by Jason Pinlac on 2/5/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import SpriteKit
import GameplayKit



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false
    var gameOver: SKSpriteNode!
    var player: SKSpriteNode!
    var starfield: SKEmitterNode!
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel?.text = "Score: \(score)"
        }
    }
    var highScoreLabel: SKLabelNode!
    var highScore = 0 {
        didSet {
            highScoreLabel?.text = "High Score: \(highScore)"
        }
    }
    
    var explosion: SKEmitterNode!
    let explosionSound = SKAction.playSoundFileNamed("bomb.wav", waitForCompletion: false)
    
    
    
    override func didMove(to view: SKView) {
        setupWorld()
        setupPlayer()
        setupLabels()
        setupNewTimer()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        for node in self.children {
            if node.name == "enemy" && node.position.x < -200 {
                node.removeFromParent()
            }
        }
        clampBoundaries()
        if !isGameOver {
            score += 1
        }
    }
    
    //  THIS GETS EXECUTED MULTIPLE TIMES ON CONTACT -> A TO B, B TO A, and/or SAME TIME. WE NEED TO GUARD AGAINST MULTIPLE CALLS!
    func didBegin(_ contact: SKPhysicsContact) {
        if !isGameOver {
            isGameOver = true
            explosion = SKEmitterNode(fileNamed: "explosion")
            explosion.position = player.position
            addChild(explosion)
            self.run(explosionSound)
            restartGame()
        }
    }
    
    
    func restartGame() {
        gameTimer?.invalidate()
        player.removeFromParent()
    
        gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        gameOver.zPosition = 10
        gameOver.setScale(1.5)
        addChild(gameOver)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.gameOver.removeFromParent()
            self?.explosion.removeFromParent()
            let wait = SKAction.wait(forDuration: 2)
            self?.run(wait)
            self?.setHighScore()
            self?.score = 0
            self?.isGameOver = false
            self?.setupNewTimer()
            self?.setupPlayer()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        let xDifference = touchLocation.x - player.position.x
        let yDifference = touchLocation.y - player.position.y
        
        player.physicsBody?.linearDamping = 0.1
        
        if xDifference < 0 {
            player.physicsBody?.velocity = CGVector(dx: xDifference * 2 , dy: yDifference * 2.165 )
        } else {
            player.physicsBody?.velocity = CGVector(dx: xDifference, dy: yDifference * 2.165 )
            
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        let xDifference = touchLocation.x - player.position.x
        let yDifference = touchLocation.y - player.position.y
        
        player.physicsBody?.linearDamping = 0.1
        
        if xDifference < 0 {
            player.physicsBody?.velocity = CGVector(dx: xDifference * 2 , dy: yDifference * 2.165 )
        } else {
            player.physicsBody?.velocity = CGVector(dx: xDifference, dy: yDifference * 2.165 )
            
        }
        
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.physicsBody?.linearDamping = 5.0
    }
    
    
    func clampBoundaries() {
        if player.position.x < 40.0 {
            player.position.x = 40.0
        }
        if player.position.x > self.size.width - 60.0 {
            player.position.x = self.size.width - 60.0
        }
        if player.position.y < 40.0 {
            player.position.y = 40.0
        }
        if player.position.y > self.size.height - 40.0 {
            player.position.y = self.size.height - 40.0
        }
    }
    
    
    func setupWorld() {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        self.backgroundColor = .black
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: self.size.width, y: self.size.height/2.0)
        starfield.advanceSimulationTime(10.0)
        starfield.zPosition = -1
        addChild(starfield)
    }
    
    
    func setupPlayer() {
            player = SKSpriteNode(imageNamed: "player")
            player.setScale(0.5)
            player.position = CGPoint(x: 200, y: self.size.height)
            player.zPosition = 5
            player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
            player.physicsBody?.contactTestBitMask = 1
            player.physicsBody?.velocity = CGVector(dx: 0, dy: -200)
            player.physicsBody?.linearDamping = 0.5
            addChild(player)
    }
    
    
    func setupLabels() {
        highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabel.horizontalAlignmentMode = .left
        highScoreLabel.fontSize = 18
        highScoreLabel.text = "High Score: \(score)"
        highScoreLabel.position = CGPoint(x: 20, y: self.size.height - 30)
        addChild(highScoreLabel)
        loadHighScore()
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 18
        scoreLabel.text = "Score: \(score)"
        scoreLabel.position = CGPoint(x: 20, y: self.size.height - 50)
        addChild(scoreLabel)
    }
    
    
    func setupNewTimer() {
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    
    @objc func createEnemy() {
        possibleEnemies.shuffle()
        let enemy = SKSpriteNode(imageNamed: possibleEnemies.randomElement()!)
        enemy.name = "enemy"
        enemy.setScale(CGFloat.random(in: 0.35...0.75))
        enemy.position = CGPoint(x: self.size.width + 100, y: CGFloat.random(in: 50...self.size.height - 50))
        enemy.zPosition = 5
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.size)
        enemy.physicsBody?.velocity = CGVector(dx: -300, dy: 0)
        enemy.physicsBody?.categoryBitMask = 1
        enemy.physicsBody?.angularVelocity = CGFloat.pi
        enemy.physicsBody?.linearDamping = 0
        enemy.physicsBody?.angularDamping = 0
        addChild(enemy)
    }
    
    func setHighScore() {
        if score > highScore {
            highScore = score
            saveHighScore()
        }
    }
    
    
    func saveHighScore() {
        let encoder = JSONEncoder()
        if let saveData = try? encoder.encode(highScore) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "highScore")
        } else {
            print("Error saving high score data.")
        }
    }
    
    func loadHighScore() {
        let defaults = UserDefaults.standard
        if let loadData = defaults.object(forKey: "highScore") as? Data {
            let decoder = JSONDecoder()
            do {
                highScore = try decoder.decode(Int.self, from: loadData)
            } catch {
                print("Error loading high score data.")
            }
        }
    }
    
    
}
