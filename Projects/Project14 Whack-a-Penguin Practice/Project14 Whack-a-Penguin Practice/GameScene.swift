//
//  GameScene.swift
//  Project14 Whack-a-Penguin Practice
//
//  Created by Jason Pinlac on 2/4/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var slots = [WhackSlot]()
    var showTime = 0.65
    
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
    
    var gameTimeLabel: SKLabelNode!
    var gameTime = 30 {
        didSet {
            gameTimeLabel?.text = "Time: \(gameTime)"
        }
    }
    var gameTimer: Timer!
    
    var gameOverSprite: SKSpriteNode?
    
    
    override func didMove(to view: SKView) {
        setupBackground()
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 24
        scoreLabel.position = CGPoint(x: 30, y: 25)
        self.addChild(scoreLabel)
        
        gameTimeLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameTimeLabel.text = "Time: \(gameTime)"
        gameTimeLabel.horizontalAlignmentMode = .right
        gameTimeLabel.fontSize = 24
        gameTimeLabel.position = CGPoint(x: self.size.width - 50, y: 25)
        self.addChild(gameTimeLabel)
        
        highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.fontSize = 24
        highScoreLabel.position = CGPoint(x: size.width/2, y: 25)
        self.addChild(highScoreLabel)
        loadHighScore()
        
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 160), y: 280)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 160), y: 215)) }
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 160), y: 150)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 160), y: 85)) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            self?.createEnemy()
            self?.startTimer()
            self?.gameTime = 30
            self?.score = 0
        }
    }
    
    
    func startNewGame() {
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 160), y: 280)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 160), y: 215)) }
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 160), y: 150)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 160), y: 85)) }
        gameOverSprite?.removeFromParent()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.startTimer()
        }
    }
    
    
    func startTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.gameTime -= 1
            // If Time reaches 0 GAME OVER
            if self?.gameTime == 0 {
                self?.endGame()
            }
        }
    }
    
    
    func endGame() {
        gameOverSprite = SKSpriteNode(imageNamed: "gameOver")
        gameOverSprite?.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        addChild(gameOverSprite!)
        
        gameTimer.invalidate()
        
        for slot in slots {
            slot.removeFromParent()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.checkAndSaveHighScore()
            self?.gameTime = 10
            self?.score = 0
            self?.startNewGame()
        }
    }
    
    
    func checkAndSaveHighScore() {
        if score > highScore {
            highScore = score
            saveHighScore()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        let touchLocation = firstTouch.location(in: self)
        let nodesTouched = nodes(at: touchLocation)
        
        for node in nodesTouched {
            guard let slot = node.parent?.parent as? WhackSlot else { return }
            if !slot.isVisible { continue }
            if slot.isHit { continue }
            
            if node.name == "penguinFriend" {
                score -= 5
                DispatchQueue.global(qos: .default).async { [weak self] in
                    self?.run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:false))
                }
            } else if node.name == "penguinEnemy" {
                score += 1
                DispatchQueue.global(qos: .default).async { [weak self] in
                    self?.run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:false))
                }
            }
            slot.hit()
        }
    }
    
    
    func setupBackground() {
         let bg = SKSpriteNode(imageNamed: "whackBackground")
         bg.zPosition = -1
         bg.zRotation = 0.09
         bg.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
         bg.blendMode = SKBlendMode.replace
         self.addChild(bg)
     }
     
     
     func createSlot(at position: CGPoint) {
         let slot = WhackSlot()
         slot.configure(at: position)
         slots.append(slot)
         self.addChild(slot)
     }
    
    
    func createEnemy() {
          slots.shuffle()
          slots[0].show(showTime: showTime)
          if Int.random(in: 0...12) > 1 { slots[1].show(showTime: showTime) }
          if Int.random(in: 0...12) > 3 { slots[2].show(showTime: showTime) }
          if Int.random(in: 0...12) > 6 { slots[3].show(showTime: showTime) }
          if Int.random(in: 0...12) > 9 { slots[4].show(showTime: showTime) }
          if Int.random(in: 0...12) > 10 { slots[5].show(showTime: showTime) }
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
              self?.createEnemy()
          }
      }
    
    
    func saveHighScore() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let encoder = JSONEncoder()
            if let savedData = try? encoder.encode(self?.highScore) {
                let defaults = UserDefaults.standard
                defaults.set(savedData, forKey: "highScore")
            } else {
                print("Failed to save the highScore")
            }
        }
        
        
    }
    
    
    func loadHighScore() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let defaults = UserDefaults.standard
            if let savedData = defaults.object(forKey: "highScore") as? Data {
                let decoder = JSONDecoder()
                do {
                    self?.highScore = try decoder.decode(Int.self, from: savedData)
                } catch {
                    print("Failed to load the highScore")
                }
            }
        }
    }
    
    
}
