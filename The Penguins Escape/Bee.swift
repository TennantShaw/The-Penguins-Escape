//
//  Bee.swift
//  The Penguins Escape
//
//  Created by Tennant Shaw on 7/21/17.
//  Copyright © 2017 Tennant Shaw. All rights reserved.
//

import SpriteKit

// Create the new class Bee, inheriting from SKSpriteNode and adopting the GameSprite protocol:
class Bee: SKSpriteNode, GameSprite {
    // We will store our size, texture atlas, and animations as class wide properties
    var initialSize: CGSize = CGSize(width: 28, height: 24)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    // The init function will be called when Bee is instantiated:
    init() {
        // Call the init function on the base class (SKSpriteNode)
        super.init(texture: nil, color: .clear, size: initialSize)
        // Create and run the flying animation:
        createAnimations()
        self.run(flyAnimation)
        // Attach a physics body, shaped like a circle and sized roughly to our bee.
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Our bee only implements one texture based animation.
    // But some classes may be more complicated, so we break out the animation building into this function:
    func createAnimations() {
        let flyFrames: [SKTexture] = [
            textureAtlas.textureNamed("bee"),
            textureAtlas.textureNamed("bee-fly")]
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.14)
        flyAnimation = SKAction.repeatForever(flyAction)
    }
    
    func onTap() {}
    
}
