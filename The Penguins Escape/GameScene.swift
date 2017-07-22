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
    var ScreenCenterY = CGFloat()
    
    
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
        ground.position = CGPoint(x: -self.size.width * 2, y: 30)
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
        
        // Set gravity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        // Store the vertical center of the screen:
        ScreenCenterY = self.size.height / 2
    }
    
    
    // MARK: - Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            // Find the location of the touch:
            let location = touch.location(in: self)
            // Locate the node at this location:
            let nodeTouched = atPoint(location)
            // Attempt to downcast the node to the GameSprite protocol
            if let gameSprite = nodeTouched as? GameSprite {
                // If this node adheres to GameSprite, call onTap:
                gameSprite.onTap()
            }
        }
        
        player.startFlapping()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    
    // MARK: - Physics
    override func didSimulatePhysics() {
        // Keep the camera locked at mid screen by default:
        var cameraYPos = ScreenCenterY
        cam.yScale = 1
        cam.xScale = 1
        
        // Follow the player up if higher than half the screen:
        if (player.position.y > ScreenCenterY) {
            cameraYPos = player.position.y
            // Scale out the camera as they go higher:
            let percentOfMaxHeight = (player.position.y - ScreenCenterY) / (player.maxHeight - ScreenCenterY)
            let newScale = 1 + percentOfMaxHeight
            cam.yScale = newScale
            cam.xScale = newScale
        }
        
        // Move the camera for our adjustment:
        self.camera!.position = CGPoint(x: player.position.x, y: cameraYPos)
    }
    
    
    // MARK: - Updating frames
    override func update(_ currentTime: TimeInterval) {
        player.update()
    }
    
}
