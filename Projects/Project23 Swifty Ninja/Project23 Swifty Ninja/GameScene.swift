//
//  GameScene.swift
//  Project23 Swifty Ninja
//
//  Created by Jason Pinlac on 3/3/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation


enum ForceBomb {
    case never, always, random
}

enum SequenceType: CaseIterable {
    case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
}

class GameScene: SKScene {
    
    var isGameEnded = false
    
    var gameScoreLabel: SKLabelNode!
    var gameScore = 0 {
        didSet {
            gameScoreLabel.text = "Score: \(gameScore)"
        }
    }
    
    var lives = 3
    var livesImages = [SKSpriteNode]()
    
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    var activeSlicePoints = [CGPoint]()
    
    var activeEnemies = [SKSpriteNode]()
    var popUpTime = 0.9
    var chainDelay = 3.0
    
    var sequence = [SequenceType]()
    var sequencePosition = 0
    var nextSequenceQueued = true
    
    var isSwooshSoundActive = false
    var swooshSounds = [
        SKAction.playSoundFileNamed("swoosh1", waitForCompletion: true),
        SKAction.playSoundFileNamed("swoosh2", waitForCompletion: true),
        SKAction.playSoundFileNamed("swoosh3", waitForCompletion: true)]
    var launchSound = SKAction.playSoundFileNamed("launch", waitForCompletion: false)
    var whackSound = SKAction.playSoundFileNamed("whack", waitForCompletion: false)
    var wrongSound = SKAction.playSoundFileNamed("wrong", waitForCompletion: false)
    var explosionSound = SKAction.playSoundFileNamed("explosion", waitForCompletion: false)
    var bombSound: AVAudioPlayer?
    

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
        
        sequence = [.oneNoBomb, .one, .twoWithOneBomb, .twoWithOneBomb, .three, .chain]
        
        for _ in 0...100 {
            if let nextSequence = SequenceType.allCases.randomElement() {
                sequence.append(nextSequence)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            [weak self] in
            self?.tossEnemies()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    if node.name == "enemy" || node.name == "enemyRed" {
                        subtractLife()
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    } else if node.name == "bombContainer" {
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }
                }
            }
        } else {
            if !nextSequenceQueued && sequencePosition < sequence.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + popUpTime) { [weak self] in
                    self?.tossEnemies()
                }
                nextSequenceQueued = true
            }
        }
        
        var bombCount = 0
        
        for node in activeEnemies {
            if node.name == "bombContainer" {
                bombCount += 1
                break
            }
        }
        
        if bombCount == 0 {
            // no bombs – stop the fuse sound!
            bombSound?.stop()
            bombSound = nil
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isGameEnded == false else { return }
        guard let touch = touches.first else { return }
        
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        let touchLocation = touch.location(in: self)
        activeSlicePoints.append(touchLocation)
        
        redrawActiveSlice()
        
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()
        
        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isGameEnded == false else { return }
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        activeSlicePoints.append(touchLocation)
        redrawActiveSlice()
        if !isSwooshSoundActive { playSwooshSound() }
        
        
        let nodesTouched = nodes(at: touchLocation)
        for case let node as SKSpriteNode in nodesTouched {
            if node.name == "enemy" {
                // destroy penguin
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy.sks") {
                    emitter.position = node.position
                    addChild(emitter)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        [weak emitter] in
                        emitter?.removeFromParent()
                    }
                }
                
                node.name = ""
                node.physicsBody?.isDynamic = false
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                let sequence = SKAction.sequence([group, .removeFromParent()])
                node.run(sequence)
                gameScore += 1
                
                // remove node from active enemies
                if let indexFound = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: indexFound)
                }
                run(whackSound)
                
            } else if node.name == "enemyRed" {
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy.sks") {
                    emitter.position = node.position
                    addChild(emitter)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        [weak emitter] in
                        emitter?.removeFromParent()
                    }
                }
                node.name = ""
                node.physicsBody?.isDynamic = false
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                let sequence = SKAction.sequence([group, .removeFromParent()])
                node.run(sequence)
                gameScore += 2
                
                if let indexFound = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: indexFound)
                }
                run(whackSound)
                
            } else if node.name == "bomb" {
                // destroy the bomb, fuse, and bomb container
                guard let bombContainer = node.parent as? SKSpriteNode else { continue }
                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb.sks") {
                    emitter.position = bombContainer.position
                    addChild(emitter)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        [weak emitter] in
                        emitter?.removeFromParent()
                    }
                }
                node.name = ""
                bombContainer.physicsBody?.isDynamic = false
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                let sequence = SKAction.sequence([group, .removeFromParent()])
                bombContainer.run(sequence)
                
                if let indexFound = activeEnemies.firstIndex(of: bombContainer) {
                    activeEnemies.remove(at: indexFound)
                }
                run(explosionSound)
                endGame(triggeredByBomb: true)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    func redrawActiveSlice() {
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1..<activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    
    
    
    func createEnemy(forceBomb: ForceBomb = .never) {
        let enemy: SKSpriteNode
        
        var enemyType = Int.random(in: 0...6)
        
        switch forceBomb {
        case.always:
            enemyType = 0
        default:
            break
        }
        
        switch enemyType {
        case 0:
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"
            
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            
            if bombSound != nil {
                bombSound?.stop()
                bombSound = nil
            }
            
            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    bombSound = sound
                    bombSound?.play()
                }
            }
            
            if let fuse = SKEmitterNode(fileNamed: "sliceFuse.sks") {
                fuse.position = CGPoint(x: 76, y: 64)
                enemy.addChild(fuse)
            }
        case 1:
            enemy = SKSpriteNode(imageNamed: "penguinRed")
            enemy.name = "enemyRed"
            run(launchSound)
        default:
            enemy = SKSpriteNode(imageNamed: "penguin")
            enemy.name = "enemy"
            run(launchSound)
        }
        
        // positioning and physics
        let randomPosition = CGPoint(x: Int.random(in: 0...896), y: -128)
        enemy.position = randomPosition
        let randomAngularVelocity = CGFloat.random(in: -3...3 )
        let randomXVelocity: Int
        
        if randomPosition.x < 224 {
            randomXVelocity = Int.random(in: 8...10)
        } else if randomPosition.x < 448 {
            randomXVelocity = Int.random(in: 3...5)
        } else if randomPosition.x < 672 {
            randomXVelocity = -Int.random(in: 3...5)
        } else {
            randomXVelocity = -Int.random(in: 8...10)
        }
        let randomYVelocity = Int.random(in: 30...32)
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 35, dy: randomYVelocity * 32)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        addChild(enemy)
        activeEnemies.append(enemy)
    }
    
    func tossEnemies() {
        guard isGameEnded == false else { return }
        if sequencePosition == sequence.count - 1 {
            for _ in 0...3 {
                if let nextSequence = SequenceType.allCases.randomElement() {
                    sequence.append(nextSequence)
                }
            }
        }
              
        if popUpTime > 0.5 {
            popUpTime *= 0.991
        }
        if chainDelay > 1.5 {
            chainDelay *= 0.99
        }
        if physicsWorld.speed < 2.0 {
            physicsWorld.speed *= 1.02
        }
        
        print("popup time: \(popUpTime)")
        print("chain delay: \(chainDelay)")
        print("physics speed: \(physicsWorld.speed)")
        
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
            
        case .one:
            createEnemy()
            
        case .twoWithOneBomb:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)
            
        case .two:
            createEnemy()
            createEnemy()
            
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
            
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
            
        case .chain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [weak self] in self?.createEnemy() }
            
        case .fastChain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [weak self] in self?.createEnemy() }
        }
        
        sequencePosition += 1
        nextSequenceQueued = false
    }
    
    
    
    func subtractLife() {
        lives -= 1
        run(wrongSound)
        var life: SKSpriteNode
        
        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages[1]
        } else {
            life = livesImages[2]
            endGame(triggeredByBomb: false)
        }
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.setScale(1.3)
        life.run(SKAction.scale(to: 1, duration: 0.1))
    }

    func endGame(triggeredByBomb: Bool) {
        guard isGameEnded == false else { return }
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        bombSound?.stop()
        bombSound = nil
        
        if triggeredByBomb {
            for image in livesImages {
                image.texture = SKTexture(imageNamed: "sliceLifeGone")
                image.setScale(1.3)
                image.run(SKAction.scale(to: 1, duration: 0.1))
            }
        }
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.zPosition = 5
        gameOver.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(gameOver)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            [weak self, weak gameOver] in
            gameOver?.removeFromParent()
            self?.restartGame()
        }
    }
    
    
    func restartGame() {
        for enemy in activeEnemies {
            enemy.removeFromParent()
        }
        
        physicsWorld.speed = 0.85
        isUserInteractionEnabled = true
        
        isGameEnded = false
        gameScore = 0
        lives = 3
        for i in 0...lives - 1 {
            livesImages[i].texture = SKTexture(imageNamed: "sliceLife")
        }
        
        activeEnemies.removeAll(keepingCapacity: true)
        popUpTime = 0.9
        chainDelay = 3.0
        
        isSwooshSoundActive = false
               bombSound = nil
        
        nextSequenceQueued = true
        sequencePosition = 0
        sequence.removeAll(keepingCapacity: true)
        sequence = [.oneNoBomb, .one, .twoWithOneBomb, .twoWithOneBomb, .three, .chain]
        
        for _ in 0...25 {
            if let nextSequence = SequenceType.allCases.randomElement() {
                sequence.append(nextSequence)
            }
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            [weak self] in
            self?.tossEnemies()
        }
    }
    
    
    func createScore() {
        gameScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameScoreLabel.horizontalAlignmentMode = .left
        gameScoreLabel.fontSize = 24
        gameScoreLabel.position = CGPoint(x: 15, y: 17)
        gameScore = 0
        addChild(gameScoreLabel)
    }
    
    func createLives() {
        for i in 0...2 {
            let life = SKSpriteNode(imageNamed: "sliceLife")
            life.position = CGPoint(x: CGFloat(710 + (i * 70)), y: 375)
            addChild(life)
            livesImages.append(life)
        }
    }
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1.0)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    func playSwooshSound() {
        isSwooshSoundActive = true
        run(swooshSounds[Int.random(in: 0...2)]) {
            [weak self] in
            self?.isSwooshSoundActive = false
        }
    }
}
