//
//  GameSprite.swift
//  The Penguins Escape
//
//  Created by Tennant Shaw on 7/21/17.
//  Copyright © 2017 Tennant Shaw. All rights reserved.
//

import SpriteKit

protocol GameSprite {
    var textureAtlas: SKTextureAtlas { get set }
    var initialSize: CGSize { get set }
    func onTap()
}
