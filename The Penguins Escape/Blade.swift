//
//  Blade.swift
//  The Penguins Escape
//
//  Created by Tennant Shaw on 7/23/17.
//  Copyright © 2017 Tennant Shaw. All rights reserved.
//

import SpriteKit

class Blade: SKSpriteNode, GameSprite {
    // MARK: - Properties
    var initialSize = CGSize(width: 185, height: 92)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var spinAnimation = SKAction()
    
    
    // MARK: - Initializers
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        let startTexture = textureAtlas.textureNamed("blade")
        self.physicsBody = SKPhysicsBody(texture: startTexture, size: initialSize)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        createAnimations()
        self.run(spinAnimation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Methods
    func createAnimations() {
        let spinFrames: [SKTexture] = [
        textureAtlas.textureNamed("blade"),
        textureAtlas.textureNamed("blade-2")
        ]
        let spinAction = SKAction.animate(with: spinFrames, timePerFrame: 0.07)
        spinAnimation = SKAction.repeatForever(spinAction)
    }
    
    func onTap() { }
}
