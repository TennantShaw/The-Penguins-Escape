//
//  Ground.swift
//  The Penguins Escape
//
//  Created by Tennant Shaw on 7/21/17.
//  Copyright © 2017 Tennant Shaw. All rights reserved.
//

import SpriteKit

// A new class inheriting from SKSpriteNode and adhering to the GameSprite protocol
class Ground: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    // We will not use initialSize for ground, but we still need to declare it to conofrm to our GameSpriteprotocol:
    var initialSize: CGSize = CGSize.zero
    
    // This function tiles the ground texture across the width of the Ground node. We will call it from our GameScene.
    func createChildren() {
        // This is one of those unique situations where we use a  non-default anchor point. By positioning the ground by its top left corner, we can place it just slightly above the bottom of the screen, on any screen size.
        self.anchorPoint = CGPoint(x: 0, y: 1)
        
        // Load the ground texture from the atlas:
        let texture = textureAtlas.textureNamed("ground")
        var tileCount: CGFloat = 0
        // We will size the tiles with their point size
        // They are 35 points wide and 300 points tall
        let tileSize = CGSize(width: 35, height: 300)
        
        // Build nodes until we cover the entire Ground width
        while tileCount * tileSize.width < self.size.width {
            let tileNode = SKSpriteNode(texture: texture)
            tileNode.size = tileSize
            tileNode.position.x = tileCount * tileSize.width
            // Position child nodes by their upper left corner
            tileNode.anchorPoint = CGPoint(x: 0, y: 1)
            // Add the child texture to the ground node:
            self.addChild(tileNode)
            
            tileCount += 1
        }
    }
    // Implement onTap to adhere to the protocol:
    func onTap() {}
}
