//
//  GameScene.swift
//  Project29 Exploding Monkeys
//
//  Created by Jason Pinlac on 4/1/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//



import SpriteKit
import GameplayKit


enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene {
    
    weak var viewController: GameViewController!
    
    var buildings = [BuildingNode]()
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var currentPlayer = 1
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        createWind()
        createBuildings()
        createPlayers()
    }
    
    
    func launch(angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10.0
        let radians = deg2rad(degrees: angle)
        
        if banana != nil {
            banana.removeFromParent()
            banana = nil
            print("Excess bananas being removed")
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width/2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.player.rawValue | CollisionTypes.building.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue | CollisionTypes.building.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let wait = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, wait, lowerArm])
            player1.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let wait = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, wait, lowerArm])
            player2.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
        
    }
    
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else { return }
        
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = contactPoint
            addChild(explosion)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak explosion] in
                explosion?.removeFromParent()
            }
        }
        
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        print("Removing banana off buildings")
        
        changePlayer()
    }
    
    
    func destroy(player: SKSpriteNode) {
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
            
            player.removeFromParent()
            banana.removeFromParent()
            banana = nil
            print("Removing banana off player face")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak explosion] in
                explosion?.removeFromParent()
                let newGame = GameScene(size: self.size)
                newGame.viewController = self.viewController
                self.viewController.currentGame = newGame
                self.changePlayer()
                newGame.currentPlayer = self.currentPlayer
                
                let transition = SKTransition.fade(withDuration: 1.5)
                self.view?.presentScene(newGame, transition: transition)
                
                newGame.viewController.windLabel.text = String(format: "Wind: %.3f", newGame.physicsWorld.gravity.dx)
            }
        }
    }
    
    
    func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        
        viewController.activateLabelsFor(player: currentPlayer)
    }
    
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < 896 {
            let size = CGSize(width: Int.random(in: 2...4) * 35, height: Int.random(in: 50...250))
            currentX += size.width + 2
            
            let building = BuildingNode(color: UIColor.red, size: size)
            building.position = CGPoint(x: currentX - (size.width/2), y: size.height/2)
            building.setup()
            self.addChild(building)
            buildings.append(building)
        }
    }
    
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width/2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + (player1Building.size.height/2 + player1.size.height/2))
        self.addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width/2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + (player2Building.size.height/2 + player2.size.height/2))
        player2.zPosition = 0
        addChild(player2)
    }
    
    
    func createWind() {
        physicsWorld.gravity = CGVector(dx: CGFloat.random(in: -1...1), dy: -9.8)
    }
    
    
    func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * Double.pi / 180
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            print("Removing bananas that flew out of bounds")
            changePlayer()
        }
    }
    
}


extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }
        
        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player1" {
            destroy(player: player1)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player2" {
            destroy(player: player2)
        }
    }
}
