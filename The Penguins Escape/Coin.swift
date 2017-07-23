//
//  Coin.swift
//  The Penguins Escape
//
//  Created by Tennant Shaw on 7/23/17.
//  Copyright © 2017 Tennant Shaw. All rights reserved.
//

import SpriteKit

class Coin: SKSpriteNode, GameSprite {
    // MARK: - Properties
    var initialSize = CGSize(width: 26, height: 26)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var value = 1
    
    
    // MARK: - Initializers
    init() {
        let bronzeTexture = textureAtlas.textureNamed("coin-bronze")
        super.init(texture: bronzeTexture, color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Methods
    func turnToGold() {
        self.texture = textureAtlas.textureNamed("coin-gold")
        self.value = 5
    }
    
    func onTap() { }
}
