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
    // Create our bee node as a property of GameScene so we can access it throughout the class
    let bee = SKSpriteNode()

    // MARK: - View Life Cycle
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        // Assign the camera to the scene
        self.camera = cam
        // Call the new bee function
        self.addTheFlyingBee()
        
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
    }
    
    override func didSimulatePhysics() {
        // Keep the camera centered on the bee
        self.camera!.position = bee.position
    }
    func addTheFlyingBee() {
        // Position our bee
        bee.position = CGPoint(x: 250, y: 250)
        bee.size = CGSize(width: 28, height: 24)
        // Add the bee to the scene
        self.addChild(bee)
        
        // Find the bee textures from the texture atlas
        let beeAtlas = SKTextureAtlas(named: "Enemies")
        let beeFrames: [SKTexture] = [
            beeAtlas.textureNamed("bee"),
            beeAtlas.textureNamed("bee-fly")
        ]
        // Create a new SKAction to animate between the frames
        let flyAction = SKAction.animate(with: beeFrames, timePerFrame: 0.14)
        // Create an SKAction to run the flyAction repeatedly
        let beeAction = SKAction.repeatForever(flyAction)
        // Instruct our bee to run the final repeat action:
        bee.run(beeAction)
        
        // Set up new actions to move our bee back and forth:
        let pathLeft = SKAction.moveBy(x: -200, y: -10, duration: 2)
        let pathRight = SKAction.moveBy(x: 200, y: 10, duration: 2)
        let flipTextureNegative = SKAction.scaleX(to: -1, duration: 0)
        let flipTexturePositive = SKAction.scaleX(to: 1, duration: 0)
        // Combine actions into a cohesive flight sequence
        let flightOfTheBee = SKAction.sequence([pathLeft, flipTextureNegative,
                                               pathRight, flipTexturePositive])
        // Create a looping action that will repeat forever:
        let neverEndingFlight = SKAction.repeatForever(flightOfTheBee)
        // Tell the bee to run the flight path
        bee.run(neverEndingFlight)

    }
    
}
