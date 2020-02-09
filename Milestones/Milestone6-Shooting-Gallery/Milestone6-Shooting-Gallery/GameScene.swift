//
//  GameScene.swift
//  Milestone6-Shooting-Gallery
//
//  Created by Jason Pinlac on 2/6/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

// MARK: TODO-
// add hit confirm sound
// ADD SOUNDTRACK
// make the limit for each level random

// ADD MAGAZING THAT GIVES YOU A ANOTHER RELOAD. YOU ONLY GET A CERTAIN AMOUNT OF MAGAZINES PER ROUND SO YOU CANT SPAM RELOAD AND SHOTS
// FLASH ACCURACY STATISTIC IT HITS/TOTAL AMOUNT OF SHOTS PER ROUND
// HAVE A ROUND ACCURACY RATING UP TOP
// HAVE A GLOBAL ACCURACY RATING ON TOP RIGHT

// ADD LIFE TARGET THAT GIVES +1 LIFE
// ADD BULLET TARGET THAT RELOADS GUN FOR YOU
// ADD BOSS TARGETS AND BOSS DUCKS THAT ARE 2x 3x AND TAKE MULTIPLE SHOTS TO KILL

// FIX BUG THAT CAUSES GAME TO NOT RESET PROPERLY. THIS MIGHT BE POSSIBLY FIXED

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var numberOfTimerObjects = 0
    
    var woodBackground: SKSpriteNode!
    var grassBackground: SKSpriteNode!
    var waterBackground: SKSpriteNode!
    var waterForeground: SKSpriteNode!
    var curtains: SKSpriteNode!
    var gameOver: SKSpriteNode!

    var bulletsA: SKSpriteNode!
    var bulletsB: SKSpriteNode!
    var bulletsC: SKSpriteNode!
    var bulletsRemaining = 9 {
        didSet {
            switch bulletsRemaining {
            case 9:
                bulletsA.texture = bulletTextures[3]
                bulletsB.texture = bulletTextures[3]
                bulletsC.texture = bulletTextures[3]
            case 8:
                bulletsA.texture = bulletTextures[3]
                bulletsB.texture = bulletTextures[3]
                bulletsC.texture = bulletTextures[2]
            case 7:
                bulletsA.texture = bulletTextures[3]
                bulletsB.texture = bulletTextures[3]
                bulletsC.texture = bulletTextures[1]
            case 6:
                bulletsA.texture = bulletTextures[3]
                bulletsB.texture = bulletTextures[3]
                bulletsC.texture = bulletTextures[0]
            case 5:
                bulletsA.texture = bulletTextures[3]
                bulletsB.texture = bulletTextures[2]
                bulletsC.texture = bulletTextures[0]
            case 4:
                bulletsA.texture = bulletTextures[3]
                bulletsB.texture = bulletTextures[1]
                bulletsC.texture = bulletTextures[0]
            case 3:
                bulletsA.texture = bulletTextures[3]
                bulletsB.texture = bulletTextures[0]
                bulletsC.texture = bulletTextures[0]
            case 2:
                bulletsA.texture = bulletTextures[2]
                bulletsB.texture = bulletTextures[0]
                bulletsC.texture = bulletTextures[0]
            case 1:
                bulletsA.texture = bulletTextures[1]
                bulletsB.texture = bulletTextures[0]
                bulletsC.texture = bulletTextures[0]
            default:
                bulletsA.texture = bulletTextures[0]
                bulletsB.texture = bulletTextures[0]
                bulletsC.texture = bulletTextures[0]
            }
        }
    }
    var bulletTextures = [
        SKTexture(imageNamed: "shots0"),
        SKTexture(imageNamed: "shots1"),
        SKTexture(imageNamed: "shots2"),
        SKTexture(imageNamed: "shots3"),
    ]
    
    var heartA: SKSpriteNode!
    var heartB: SKSpriteNode!
    var heartC: SKSpriteNode!
    var heartD: SKSpriteNode!
    var heartE: SKSpriteNode!
    var livesRemaining = 5 {
           didSet {
            switch livesRemaining {
            case 5:
                heartA.texture = heartTextures[1]
                heartB.texture = heartTextures[1]
                heartC.texture = heartTextures[1]
                heartD.texture = heartTextures[1]
                heartE.texture = heartTextures[1]
            case 4:
                heartA.texture = heartTextures[1]
                heartB.texture = heartTextures[1]
                heartC.texture = heartTextures[1]
                heartD.texture = heartTextures[1]
                heartE.texture = heartTextures[0]
            case 3:
                heartA.texture = heartTextures[1]
                heartB.texture = heartTextures[1]
                heartC.texture = heartTextures[1]
                heartD.texture = heartTextures[0]
                heartE.texture = heartTextures[0]
            case 2:
                heartA.texture = heartTextures[1]
                heartB.texture = heartTextures[1]
                heartC.texture = heartTextures[0]
                heartD.texture = heartTextures[0]
                heartE.texture = heartTextures[0]
            case 1:
                heartA.texture = heartTextures[1]
                heartB.texture = heartTextures[0]
                heartC.texture = heartTextures[0]
                heartD.texture = heartTextures[0]
                heartE.texture = heartTextures[0]
            default:
                heartA.texture = heartTextures[0]
                heartB.texture = heartTextures[0]
                heartC.texture = heartTextures[0]
                heartD.texture = heartTextures[0]
                heartE.texture = heartTextures[0]
            }
           }
       }
    var heartTextures = [
        SKTexture(imageNamed: "emptyHeart"),
        SKTexture(imageNamed: "fullHeart")
    ]
    
    var gameTimer: Timer!
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel?.text = "Score: \(score)"
        }
    }
    
    var levelLabel: SKLabelNode!
    var level = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    
    var reloadSound = SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false)
    var shotSound = SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false)
    var pingSound = SKAction.playSoundFileNamed("ping.mp3", waitForCompletion: false)
    var emptySound = SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false)
    var gameOverSound = SKAction.playSoundFileNamed("gameOver.wav", waitForCompletion: false)
    var hurtSound = SKAction.playSoundFileNamed("hurt.wav", waitForCompletion: false)
    var nextLevelSound = SKAction.playSoundFileNamed("nextLevel.wav", waitForCompletion: false)
    
    var isGameOver = false
    var spawnInterval = 0.5
    var minTravelTime = 4.0
    var maxTravelTime = 10.0
    
    override func didMove(to view: SKView) {
        setupStage()
        animateStage()
        setupBullets()
        setupTimer()
        setupHearts()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver { return }
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        
        for node in touchedNodes {
            if node.name == "bullets" {
                if bulletsRemaining == 0 {
                    run(reloadSound)
                    bulletsRemaining = 9
                }
                return
            } else {
                if bulletsRemaining > 0 {
                    bulletsRemaining -= 1
                    run(shotSound)
                    if bulletsRemaining == 0 {
                        run(pingSound)
                    }
                    
                } else {
                    run(emptySound)
                }
                break
            }
        }
        
        for node in touchedNodes {
            if bulletsRemaining > 0 {
                if node.name == "target" {
                    let drop = SKAction.moveBy(x: 0, y: -50, duration: 0.25)
                    let fade = SKAction.fadeOut(withDuration: 0.25)
                    let rescale = SKAction.scaleX(by: 0.7, y: 0.5, duration: 0.25)
                    let delay = SKAction.wait(forDuration: 1)
                    let remove = SKAction.run { [weak node] in
                        node?.removeFromParent()
                    }
                    let sequence = SKAction.sequence([delay, remove])
                    node.run(fade)
                    node.run(drop)
                    node.run(rescale)
                    node.run(sequence)
                    score += 1
                    
                    if score % 37 == 0 {
                        increaseLevel()
                    }
                    break
                }
            }
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in self.children {
            if node.position.x < -200 || node.position.x > 1100 {
                node.removeFromParent()
                if livesRemaining > 0 {
                    livesRemaining -= 1
                    run(hurtSound)
                }
            }
        }
        if livesRemaining == 0 && !isGameOver {
            isGameOver = true
            gameOver.isHidden = false
            gameTimer.invalidate()
            run(gameOverSound)
            print("A Timer invalidated.")
            numberOfTimerObjects -= 1
            removeAllTargets()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.restartGame()
            }
        }
    }
    
    func setupStage() {
        woodBackground = SKSpriteNode(imageNamed: "wood-background")
        woodBackground.scale(to: CGSize(width: woodBackground.size.width * 1.15, height: woodBackground.size.height))
        woodBackground.position = CGPoint(x: size.width/2, y: size.height/2 - 30)
        woodBackground.zPosition = 0
        addChild(woodBackground)
        
        grassBackground = SKSpriteNode(imageNamed: "grass-trees")
        grassBackground.scale(to: CGSize(width: grassBackground.size.width * 1.15, height: grassBackground.size.height))
        grassBackground.position = CGPoint(x: size.width/2, y: size.height/2)
        grassBackground.zPosition = 100
        addChild(grassBackground)
        
        waterBackground = SKSpriteNode(imageNamed: "water-bg")
        waterBackground.scale(to: CGSize(width: waterBackground.size.width * 1.15, height: waterBackground.size.height))
        waterBackground.position = CGPoint(x: size.width/2, y: size.height/2 - 110)
        waterBackground.zPosition = 200
        addChild(waterBackground)
        
        waterForeground = SKSpriteNode(imageNamed: "water-fg")
        waterForeground.scale(to: CGSize(width: waterForeground.size.width * 1.15, height: waterForeground.size.height))
        waterForeground.position = CGPoint(x: size.width/2, y: size.height/2 - 180)
        waterForeground.zPosition = 300
        addChild(waterForeground)
        
        curtains = SKSpriteNode(imageNamed: "curtains")
        curtains.scale(to: CGSize(width: size.width * 1.2, height: size.height * 1.25))
        curtains.position = CGPoint(x: size.width/2, y: size.height/2)
        curtains.zPosition = 400
        addChild(curtains)
        
        gameOver = SKSpriteNode(imageNamed: "game-over")
        gameOver.setScale(1.25)
        gameOver.position = CGPoint(x: size.width/2, y: size.height/2)
        gameOver.zPosition = 400
        gameOver.isHidden = true
        addChild(gameOver)
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "Level: \(level)"
        levelLabel.fontSize = 24
        levelLabel.position = CGPoint(x: size.width/2, y: size.height - 40)
        levelLabel.zPosition = 500
        levelLabel.horizontalAlignmentMode = .center
        addChild(levelLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.position = CGPoint(x: size.width/2, y: 24)
        scoreLabel.zPosition = 500
        scoreLabel.horizontalAlignmentMode = .center
        addChild(scoreLabel)
    }
    
    func setupBullets() {
        bulletsA = SKSpriteNode(imageNamed: "shots3")
        bulletsA.name = "bullets"
        bulletsA.position = CGPoint(x: size.width - 273, y: 28)
        bulletsA.zPosition = 500
        addChild(bulletsA)
        
        bulletsB = SKSpriteNode(imageNamed: "shots3")
        bulletsB.name = "bullets"
        bulletsB.position = CGPoint(x: size.width - 178, y: 28)
        bulletsB.zPosition = 500
        addChild(bulletsB)
        
        bulletsC = SKSpriteNode(imageNamed: "shots3")
        bulletsC.name = "bullets"
        bulletsC.position = CGPoint(x: size.width - 80, y: 28)
        bulletsC.zPosition = 500
        addChild(bulletsC)
        
        let invisibleArea = SKSpriteNode(color: UIColor.red, size: CGSize(width: 350, height: 80))
        invisibleArea.position = CGPoint(x: size.width - 175, y: 28)
        invisibleArea.alpha = 0.01
        invisibleArea.zPosition = 500
        invisibleArea.name = "bullets"
        self.addChild(invisibleArea)
    }
    
    func setupHearts() {
        heartA = SKSpriteNode(imageNamed: "fullHeart")
        heartA.position = CGPoint(x: 65, y: 28)
        heartA.zPosition = 500
        heartA.setScale(0.85)
        addChild(heartA)
        heartB = SKSpriteNode(imageNamed: "fullHeart")
        heartB.position = CGPoint(x: 115, y: 28)
        heartB.zPosition = 500
        heartB.setScale(0.85)
        addChild(heartB)
        heartC = SKSpriteNode(imageNamed: "fullHeart")
        heartC.position = CGPoint(x: 165, y: 28)
        heartC.zPosition = 500
        heartC.setScale(0.85)
        addChild(heartC)
        heartD = SKSpriteNode(imageNamed: "fullHeart")
        heartD.position = CGPoint(x: 215, y: 28)
        heartD.zPosition = 500
        heartD.setScale(0.85)
        addChild(heartD)
        heartE = SKSpriteNode(imageNamed: "fullHeart")
        heartE.position = CGPoint(x: 265, y: 28)
        heartE.zPosition = 500
        heartE.setScale(0.85)
        addChild(heartE)
    }
    
    func animateStage() {
        let waterBGMove = SKAction.moveBy(x: 0, y: -20, duration: 1)
        let waterBGMoveReverse = SKAction.moveBy(x: 0, y: 20, duration: 1)
        let waterBGMoveSequence = SKAction.sequence([waterBGMove, waterBGMoveReverse])
        let waterBGMoveForever = SKAction.repeatForever(waterBGMoveSequence)
        waterBackground.run(waterBGMoveForever)
        
        let waterFGMove = SKAction.moveBy(x: 0, y: -20, duration: 0.75)
        let waterFGMoveReverse = SKAction.moveBy(x: 0, y: 20, duration: 0.75)
        let waterFGMoveSequence = SKAction.sequence([waterFGMove, waterFGMoveReverse])
        let waterFGMoveForever = SKAction.repeatForever(waterFGMoveSequence)
        waterForeground.run(waterFGMoveForever)
        
        let cloudMove = SKAction.moveBy(x: -75, y: 0, duration: 10)
        let cloudMoveReverse = SKAction.moveBy(x: 75, y: 0, duration: 10)
        let cloudMoveSequence = SKAction.sequence([cloudMove, cloudMoveReverse])
        let cloudMoveForever = SKAction.repeatForever(cloudMoveSequence)
        woodBackground.run(cloudMoveForever)
    }
    
    func setupTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: spawnInterval, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
        numberOfTimerObjects += 1
        print("Created a timer! Number of timer objects: \(numberOfTimerObjects)")
    }
    
    @objc func createTarget() {
        let tier = Int.random(in: 0...2)
        var isMovingLeft = false
        let target = Target()
        target.setup()
        target.name = "target"
        
        switch tier {
        case 2: // grass
            target.setScale(0.65)
            target.position = CGPoint(x: -100, y: self.size.height/2 - 15)
            target.zPosition = 150
        case 1: // water bg
            isMovingLeft = true
            target.setScale(0.85)
            target.position = CGPoint(x: -100, y: self.size.height/2 - 75)
            target.zPosition = 250
        default: // water fg
            target.position = CGPoint(x: -100, y: self.size.height/2 - 170)
            target.zPosition = 350
        }
        
        if isMovingLeft {
            target.position.x = 1000
            target.xScale = -target.xScale
        }
        addChild(target)
        
        let movement: SKAction
        if isMovingLeft {
            movement = SKAction.moveBy(x: -1300, y: 0, duration: Double.random(in: minTravelTime...maxTravelTime))
            
        } else {
            movement = SKAction.moveBy(x: 1300, y: 0, duration: Double.random(in: minTravelTime...maxTravelTime))
        }
        target.run(movement)
    }
    
    func restartGame() {
        gameOver.isHidden = true
        isGameOver = false
        livesRemaining = 5
        bulletsRemaining = 9
        score = 0
        level = 1
        
        spawnInterval = 0.5
        minTravelTime = 4.0
        maxTravelTime = 10.0
        setupTimer()
    }
    
    func increaseLevel() {
        level += 1
        gameTimer.invalidate()
        run(nextLevelSound)
        print("A Timer invalidated.")
        numberOfTimerObjects -= 1
        removeAllTargets()
        
        spawnInterval *= 0.95
        minTravelTime *= 0.95
        maxTravelTime *= 0.95
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.setupTimer()
        }
    }
    
    func removeAllTargets() {
            let drop = SKAction.moveBy(x: 0, y: -50, duration: 0.25)
            let fade = SKAction.fadeOut(withDuration: 0.25)
            let rescale = SKAction.scaleX(by: 0.7, y: 0.5, duration: 0.25)
            let delay = SKAction.wait(forDuration: 1)
            for node in children {
                if node.name == "target" {
                    let remove = SKAction.run { [weak node] in
                        node?.removeFromParent()
                    }
                    let sequence = SKAction.sequence([delay, remove])
                    node.run(fade)
                    node.run(drop)
                    node.run(rescale)
                    node.run(sequence)
                }
            }
    }
    
}
