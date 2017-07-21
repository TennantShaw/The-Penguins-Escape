//
//  GameScene.swift
//  The Penguins Escape
//
//  Created by Tennant Shaw on 7/20/17.
//  Copyright © 2017 Tennant Shaw. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        // Position from the lower left corner
        self.anchorPoint = .zero
        // set the scene's background to a nice sky blue
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        // Create our bee sprite node
        let bee = SKSpriteNode()
        // Size our bee
        bee.size = CGSize(width: 28, height: 24)
        // Position our bee node
        bee.position = CGPoint(x: 250, y: 250)
        // Attach our bee to the scene's node tree
        self.addChild(bee)
        
        // Find our new bee texture atlas
        let beeAtlas = SKTextureAtlas(named: "Enemies")
        // Grab the two bee frames from the texture atlas in an array
        let beeFrames: [SKTexture] = [
            beeAtlas.textureNamed("bee"),
            beeAtlas.textureNamed("bee-fly")
        ]
        // Create a new SKAction to animate between the frames once
        let flyAction = SKAction.animate(with: beeFrames, timePerFrame: 0.14)
        // Create an SKAction to run the flyAction repeatedly
        let beeAction = SKAction.repeatForever(flyAction)
        // Instruct our bee to run the final repeat action:
        bee.run(beeAction)
        
        // Set up new actions to move bee back and forth:
        let pathLeft = SKAction.moveBy(x: -200, y: -10, duration: 2)
        let pathRight = SKAction.moveBy(x: 200, y: 20, duration: 2)
        // These two scaleX actions fip the texture back and forth
        // We will use these to turn the bee to face left and right
        let flipTextureNegative = SKAction.scaleX(to: -1, duration: 0)
        let flipTexturePositive = SKAction.scaleX(to: 1, duration: 0)
        // Combine actions into a cohesive flight sequence for the bee
        let flightOfTheBee = SKAction.sequence([pathLeft, flipTextureNegative,
            pathRight, flipTexturePositive])
        // Last, create a looping action that will repeat forever
        let neverEndingFlight = SKAction.repeatForever(flightOfTheBee)
        // Tell the bee to run the flight path
        bee.run(neverEndingFlight)
    }
    
}
