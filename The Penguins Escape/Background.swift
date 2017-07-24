//
//  Background.swift
//  The Penguins Escape
//
//  Created by Tennant Shaw on 7/24/17.
//  Copyright © 2017 Tennant Shaw. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    // MARK: - Properties
    // movementMultiplier will store a float from 0-1 to indicate how fast the background shoul move past. 0 is full adjustment, no movement as the world goes past. 1 is no adjustment, background passes at normal speed.
    var movementMultiplier = CGFloat(0)
    // jumpAdjustment will store how many points of x position this background has jumped forward, useful for calculating future seamless jump points:
    var jumpAdjustment = CGFloat(0)
    // A constant for background node size:
    let backgroundSize = CGSize(width: 1024, height: 768)
    // Store the backgrounds texture:
    var textureAtlas = SKTextureAtlas(named: "Backgrounds")
    
    
    // MARK: - Methods
    func spawn(parentNode: SKNode, imageName: String, zPosition: CGFloat, movementMultiplier: CGFloat) {
        // Position from the bottom left:
        self.anchorPoint = CGPoint.zero
        // Start backgrounds at the top of the ground
        self.position = CGPoint(x: 0, y: 30)
        // Control the order of backgrounds with zPosition:
        self.zPosition = zPosition
        // Store the movement multiplier:
        self.movementMultiplier = movementMultiplier
        // Add the background to the parentNode:
        parentNode.addChild(self)
        // Grab the texture for this background from the atlas:
        let texture = textureAtlas.textureNamed(imageName)
        // Build three child node instances of the texture, looping from -1 to 1 so the backgrounds cover both forward and behind the player at position zero.
        for i in -1...1 {
            let newBGNode = SKSpriteNode(texture: texture)
            // Set the size for this node from constant:
            newBGNode.size = backgroundSize
            // Position these nodes by their lower left corner:
            newBGNode.anchorPoint = CGPoint.zero
            // Position the background node:
            newBGNode.position = CGPoint(x: i * Int(backgroundSize.width), y: 0)
            self.addChild(newBGNode)
        }
    }
    
    // We will call updatePosition every frame to reposition the background:
    func updatePosition(playerProgress: CGFloat) {
        // Calculate a position adjustment after loops and parallax multiplier:
        let adjustedPosition = jumpAdjustment + playerProgress * (1 - movementMultiplier)
        // Check if we need to jump the background forward:
        if playerProgress - adjustedPosition > backgroundSize.width {
            jumpAdjustment += backgroundSize.width
        }
        // Adjust this background position forward as the camera pans so the background appears slower:
        self.position.x = adjustedPosition
    }
    
}
