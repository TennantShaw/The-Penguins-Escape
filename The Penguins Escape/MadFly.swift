//
//  MadFly.swift
//  The Penguins Escape
//
//  Created by Tennant Shaw on 7/23/17.
//  Copyright © 2017 Tennant Shaw. All rights reserved.
//

import SpriteKit

class MadFly: SKSpriteNode, GameSprite {
    // MARK: - Properties
    var initialSize = CGSize(width: 61, height: 29)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    
    // MARK: - Initializers
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        createAnimations()
        self.run(flyAnimation)
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Methods
    func createAnimations() {
        let flyFrames: [SKTexture] = [
        textureAtlas.textureNamed("madfly"),
        textureAtlas.textureNamed("madfly-fly")
        ]
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.14)
        flyAnimation = SKAction.repeatForever(flyAction)
    }
    
    func onTap() { }
}
