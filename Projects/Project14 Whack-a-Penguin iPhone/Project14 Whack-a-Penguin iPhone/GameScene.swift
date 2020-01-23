//  GameScene.swift
//  Project14 Whack-a-Penguin iPhone
//
//  Created by Jason Pinlac on 1/21/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var slots = [WhackSlot]()
    var upTime = 0.7
    
    var highScore = 0 {
        didSet {
            highScoreLabel.text = "High Score: \(highScore)"
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var time = 30 {
        didSet {
            timeLabel.text = "Timer: \(time)"
        }
    }
    
    var timeLabel: SKLabelNode!
    var restartLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    
    
    override func didMove(to view: SKView) {
        let bg = SKSpriteNode(imageNamed: "whackBackground")
        bg.position = CGPoint(x: 448, y: 207)
        bg.blendMode = .replace
        bg.zPosition = -1
        bg.xScale = 0.95
        bg.yScale = 0.85
        addChild(bg)
        
        restartLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartLabel.position = CGPoint(x: 448, y: 107)
        restartLabel.text = "Restarting in 5 seconds..."
        restartLabel.fontSize = 48
        restartLabel.zPosition = 1
        restartLabel.isHidden = true
        addChild(restartLabel)
        
        timeLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLabel.position = CGPoint(x: 600, y: 15)
        timeLabel.horizontalAlignmentMode = .left
        timeLabel.text = "Timer: \(time)"
        timeLabel.fontSize = 36
        addChild(timeLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 25, y: 15)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 36
        addChild(scoreLabel)
        
        highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabel.position = CGPoint(x: 250, y: 15)
        highScoreLabel.horizontalAlignmentMode = .left
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.fontSize = 36
        addChild(highScoreLabel)
        
        for i in 0..<4 { createSlot(at: CGPoint(x: 110 + (i * 170), y: 260)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 190 + (i * 170), y: 200)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 110 + (i * 170), y: 140)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 190 + (i * 170), y: 80)) }
        
        load()
        startGame()
        startGameTimer()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesTouched = nodes(at: location)
        
        for node in nodesTouched {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            
            if node.name == "charFriend" {
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy" {
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        if time == 0 {
            for slot in slots { slot.hide(); slot.isHidden = true }
            timeLabel.isHidden = true
            restartLabel.isHidden = false
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 448, y: 207)
            gameOver.zPosition = 1
            addChild(gameOver)
            run(SKAction.playSoundFileNamed("gameOver.mp3", waitForCompletion: false))
            if score > highScore { highScore = score; save() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.removeChildren(in: [gameOver])
                self?.startGame()
            }
            return
        }
        
        upTime *= 0.98
        print(upTime)
        slots.shuffle()
        
        slots[0].show(for: upTime)
        if Int.random(in: 0...12) > 3 {slots[1].show(for: upTime)}
        if Int.random(in: 0...12) > 6 {slots[2].show(for: upTime)}
        if Int.random(in: 0...12) > 8 {slots[3].show(for: upTime)}
        if Int.random(in: 0...12) > 10 {slots[4].show(for: upTime)}
        
        let minDelay = upTime / 2.0
        let maxDelay = upTime * 2.0
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
    
    func startGame() {
        score = 0
        time = 31
        upTime = 0.7
        timeLabel.isHidden = false
        restartLabel.isHidden = true
        for slot in slots { slot.isHidden = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.createEnemy()
        }
    }
    
    func startGameTimer() {
        let wait = SKAction.wait(forDuration: 1.0)
        let countDown = SKAction.run { [weak self] in self?.time -= 1 }
        let sequence = SKAction.sequence([wait, countDown])
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.run(SKAction.repeatForever(sequence))
        }
        
    }
    
    
    
    
    func save() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let encoder = JSONEncoder()
            if let saveData = try? encoder.encode(self?.highScore) {
                let defaults = UserDefaults.standard
                defaults.set(saveData, forKey: "highScore")
            } else {
                print("Failed to save data")
            }
        }
    }
    
    func load() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let defaults = UserDefaults.standard
            if let savedData = defaults.object(forKey: "highScore") as? Data {
                let decoder = JSONDecoder()
                do {
                    self?.highScore = try decoder.decode(Int.self, from: savedData)
                } catch {
                    print("Failed to load data")
                }
            }
        }
    }
    
}

