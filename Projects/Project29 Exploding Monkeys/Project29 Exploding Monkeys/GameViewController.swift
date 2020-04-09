//
//  GameViewController.swift
//  Project29 Exploding Monkeys
//
//  Created by Jason Pinlac on 4/1/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var currentGame: GameScene!
    
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var velocitySlider: UISlider!
    
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocityLabel: UILabel!
    
    @IBOutlet var launchButton: UIButton!
    
    @IBOutlet var playerNumberLabel: UILabel!
    
    @IBOutlet var windLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                currentGame = scene as? GameScene
                currentGame.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        angleChanged(angleSlider)
        velocityChanged(velocitySlider)
        let windFormatted = String(format: "Wind: %.3f", currentGame.physicsWorld.gravity.dx)
        windLabel.text = windFormatted
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func angleChanged(_ sender: UISlider) {
        angleLabel.text = "Angle: \(Int(sender.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: UISlider) {
        velocityLabel.text = "Velocity: \(Int(sender.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        angleLabel.isHidden = true
        velocityLabel.isHidden = true
        
        angleSlider.isHidden = true
        velocitySlider.isHidden = true
        
        playerNumberLabel.isHidden = true
        
        windLabel.isHidden = true
        
        launchButton.isHidden = true
        
        currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activateLabelsFor(player: Int) {
        if player == 1 {
            playerNumberLabel.text = "<<< PLAYER ONE"
        } else {
            playerNumberLabel.text = "PLAYER TWO >>>"
        }
        
        angleLabel.isHidden = false
        velocityLabel.isHidden = false
        
        angleSlider.isHidden = false
        velocitySlider.isHidden = false
        
        playerNumberLabel.isHidden = false
        
        windLabel.isHidden = false
        
        launchButton.isHidden = false
    }
}
