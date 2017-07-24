//
//  MenuScene.swift
//  The Penguins Escape
//
//  Created by Tennant Shaw on 7/24/17.
//  Copyright © 2017 Tennant Shaw. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    // MARK: - Properties
    // Grab the HUD sprite atlas:
    let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "HUD")
    // Instantiate a sprite node for the start button:
    let startButton = SKSpriteNode()
    
    
    // MARK: - Methods
    override func didMove(to view: SKView) {
        // Position nodes from the center of the scene:
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // Add the background image:
        let backgroundImage = SKSpriteNode(imageNamed: "background-menu")
        backgroundImage.size = CGSize(width: 1024, height: 768)
        backgroundImage.zPosition = -1
        self.addChild(backgroundImage)
        // Draw the name of the game:
        let logoText = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        logoText.text = "The Penguin's Escape"
        logoText.position = CGPoint(x: 0, y: 100)
        logoText.fontSize = 60
        self.addChild(logoText)
        
        // Build the start game button:
        startButton.texture = textureAtlas.textureNamed("button")
        startButton.size = CGSize(width: 295, height: 76)
        // Name the start node for touch detection:
        startButton.name = "StartBtn"
        startButton.position = CGPoint(x: 0, y: -20)
        self.addChild(startButton)
        
        // Add text to the start button:
        let startText = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        startText.text = "START GAME"
        startText.verticalAlignmentMode = .center
        startText.position = CGPoint(x: 0, y: 2)
        startText.fontSize = 40
        // Name the text node for touch detection:
        startText.name = "StartBtn"
        startText.zPosition = 5
        startButton.addChild(startText)
        
        // Pulse the start text in and out gently:
        let pulseAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.9),
            SKAction.fadeAlpha(to: 1, duration: 0.9)])
        startText.run(SKAction.repeatForever(pulseAction))
    }
}
