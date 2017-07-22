//
//  GameScene.swift
//  The Penguins Escape
//
//  Created by Tennant Shaw on 7/20/17.
//  Copyright © 2017 Tennant Shaw. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    // MARK: - Properties
    // Create a constant cam as SKCameraNode:
    let cam = SKCameraNode()
    let ground = Ground()
    let player = Player()
    
    
    // MARK: - View Life Cycle
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        // Assign the camera to the scene
        self.camera = cam
        
        // Add a second Bee to the scene:
        let bee2 = Bee()
        bee2.position = CGPoint(x: 325, y: 325)
        self.addChild(bee2)
        // ... and a third Bee:
        let bee3 = Bee()
        bee3.position = CGPoint(x: 200, y: 325)
        self.addChild(bee3)
        
        // Position the ground based on the screen size.
        // Position X: Negative one screen width.
        // Position Y: 150 abov the bottom
        ground.position = CGPoint(x: -self.size.width * 2, y: 150)
        // Set the ground width to 3x the width of the scene
        ground.size = CGSize(width: self.size.width * 6, height: 0)
        // Run the ground's createChildren function to build the child texture tiles:
        ground.createChildren()
        // Add the ground node to the scene:
        self.addChild(ground)
        
        // Position the player:
        player.position = CGPoint(x: 150, y: 250)
        // Add the player node to the scene:
        self.addChild(player)
        bee2.physicsBody?.mass = 0.2
        bee2.physicsBody?.applyImpulse(CGVector(dx: -25, dy: 0))
    }
    
    override func didSimulatePhysics() {
        // Keep the camera centered on the bee
        self.camera!.position = player.position
    }
    
}
