//
//  GameScene.swift
//  Project14 Whack-a-Penguin
//
//  Created by Jason Pinlac on 1/21/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var slots = [WhackSlot]()
    
    var upTime = 0.85
    
    var roundLabel: SKLabelNode!
    var roundLimit = 30
    var round = 0 {
        didSet {
            roundLabel.text = "Round \(round)/\(roundLimit)"
        }
    }
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.position = CGPoint(x: 500, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        addChild(scoreLabel)
        
        roundLabel = SKLabelNode(fontNamed: "Chalkduster")
        roundLabel.text = "Round \(round)/\(roundLimit)"
        roundLabel.position = CGPoint(x: 8, y: 8)
        roundLabel.horizontalAlignmentMode = .left
        roundLabel.fontSize = 48
        addChild(roundLabel)
        
        for i in 0 ..< 5 {
            createSlots(at: CGPoint(x: 100 + (i * 170), y: 410))
        }
        for i in 0 ..< 4 {
            createSlots(at: CGPoint(x: 180 + (i * 170), y: 320))
        }
        for i in 0 ..< 5 {
            createSlots(at: CGPoint(x: 100 + (i * 170), y: 230))
        }
        for i in 0 ..< 4 {
            createSlots(at: CGPoint(x: 180 + (i * 170), y: 140))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
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
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
            
        }
    }
    
    func createSlots(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        round += 1
        
        if round >= roundLimit {
            for slot in slots {
                slot.hide()
            }
            let gameOver  = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            run(SKAction.playSoundFileNamed("gameOver.mp3", waitForCompletion: false))
            return
        }
        
        upTime *= 0.98
        print(upTime)
        
        slots.shuffle()
        slots[0].show(for: upTime)
        
        if Int.random(in: 0...12) > 4 {
            slots[1].show(for: upTime)
        }
        if Int.random(in: 0...12) > 8 {
            slots[2].show(for: upTime)
        }
        if Int.random(in: 0...12) > 10 {
            slots[3].show(for: upTime)
        }
        if Int.random(in: 0...12) > 11 {
            slots[4].show(for: upTime)
        }
        
        let minDelay = upTime / 2.0
        let maxDelay = upTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
        
    }
}
