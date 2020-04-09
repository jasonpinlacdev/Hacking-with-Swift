//
//  BuildingNode.swift
//  Project29 Exploding Monkeys
//
//  Created by Jason Pinlac on 4/1/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit
import SpriteKit

class BuildingNode: SKSpriteNode {
    
    var currentImage: UIImage!
    
    
    func setup() {
        // sets up the basic work to make this object a build IE name, texture, and physics
        name = "building"
        
        currentImage = drawBuilding(size: size)
        texture = SKTexture(image: currentImage)
        
        configurePhysics()
    }
    
    func configurePhysics() {
        // sets up per-picel physics for the sprites current text
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
    }
    
    
    func drawBuilding(size: CGSize) -> UIImage {
        // does the Core Graphics rendering of the building and returns it as a UIImage
        let renderer = UIGraphicsImageRenderer(size: size)
        let imageRendered = renderer.image { context in
            
            let building = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let buildingColor: UIColor
            
            switch Int.random(in: 0...2) {
            case 0:
                buildingColor = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
            case 1:
                buildingColor = UIColor(hue: 0.999, saturation: 0.98, brightness: 0.67, alpha: 1)
            default:
                buildingColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.67, alpha: 1)
            }
            
            context.cgContext.setFillColor(buildingColor.cgColor)
            
            context.cgContext.addRect(building)
            context.cgContext.drawPath(using: .fill)
            
            
            let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
            let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
            
            for row in stride(from: 10, to: Int(size.height) - 10, by: 35) {
                for column in stride(from: 10, to: Int(size.width) - 10, by: 35) {
                    switch Bool.random() {
                    case true:
                        context.cgContext.setFillColor(lightOnColor.cgColor)
                        
                    case false:
                        context.cgContext.setFillColor(lightOffColor.cgColor)
                        
                    }
                    
                    let window = CGRect(x: column, y: row, width: 15, height: 20)
                    
                    context.cgContext.addRect(window)
                    context.cgContext.drawPath(using: .fill)
                }
            }
        }
        return imageRendered
    }
    
    func hit(at point: CGPoint) {
        // point is where building was hit in reference to the building. remember sprite kit position things from the center. Core Graphics positions things from the bottom left.
        let convertedPoint = CGPoint(x: point.x + size.width/2, y: abs(point.y - (size.height/2)))
        
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderedImage = renderer.image { context in
            currentImage.draw(at: .zero)
            
            let ellipseOfDestruction = CGRect(x: convertedPoint.x - 32, y: convertedPoint.y - 32, width: 64, height: 64)
            context.cgContext.addEllipse(in: ellipseOfDestruction)
            context.cgContext.setBlendMode(.clear)
            context.cgContext.drawPath(using: .fill)
        }
        
        texture = SKTexture(image: renderedImage)
        currentImage = renderedImage
        configurePhysics()
    }
    
    
}
