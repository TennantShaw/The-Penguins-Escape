//
//  Bat.swift
//  The Penguins Escape
//
//  Created by Tennant Shaw on 7/23/17.
//  Copyright © 2017 Tennant Shaw. All rights reserved.
//

import SpriteKit

class Bat: SKSpriteNode, GameSprite {
    // MARK: - Properties
    var initialSize = CGSize(width: 44, height: 24)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    
    // MARK: - Initializers
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        createAnimations()
        self.run(flyAnimation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Methods
    func createAnimations() {
        let flyFrames: [SKTexture] = [
        textureAtlas.textureNamed("bat"),
        textureAtlas.textureNamed("bat-fly")
        ]
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.12)
        flyAnimation = SKAction.repeatForever(flyAction)
    }
    
    func onTap() { }
}
