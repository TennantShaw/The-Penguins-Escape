//
//  Player.swift
//  The Penguins Escape
//
//  Created by Tennant Shaw on 7/21/17.
//  Copyright © 2017 Tennant Shaw. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode, GameSprite {
    // MARK: - Properties
    var initialSize = CGSize(width: 64, height: 64)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Pierre")
    // Pierre has multiple animations. right now we will create one animation for flying up and one for going down:
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    
    // Store whether we are flapping our wings or in free-fall:
    var flapping = false
    // Set a maximum upward force:
    let maxFlappingForce: CGFloat = 57000
    // Pierre should slow down when he flies too high:
    let maxHeight: CGFloat = 1000
    // The player will be able to take 3 hits before game over:
    var health: Int = 3
    // Keep track of when the player is invulnerable:
    var invulnerable = false
    // Keep track of when the player is newly damaged:
    var damaged = false
    // We will create animations to run when the player takes damage or dies. Add these properties to store them:
    var damageAnimation = SKAction()
    var dieAnimation = SKAction()
    // We want to stop forward velocity if the player dies, so we will store forward velocity as a property:
    var forawrdVelocity: CGFloat = 200
    
    
    // MARK: - Initializers
    init() {
        // Call the init function on the base class (SKSpriteNode)
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimations()
        // If we run an action with a key, "flapAnimation", we can later reference that key to remove the action.
        self.run(flyAnimation, withKey: "soarAnimation")
        // Create a physics body based on one frame of Pierre's animation.
        // We will use the third frame, when his wings are tucked in
        let bodyTexture = textureAtlas.textureNamed("pierre-flying-3")
        self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: self.size)
        // Pierre will lose momentum quickly with a high linearDamping:
        self.physicsBody?.linearDamping = 0.9
        // Adult penguins weigh around 30kg:
        self.physicsBody?.mass = 30
        // Prevent Pierre from rotating:
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue |
            PhysicsCategory.ground.rawValue |
            PhysicsCategory.powerup.rawValue |
            PhysicsCategory.coin.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
    }
    
    // Satisfy the NSCoder required init:
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Methods
    func createAnimations() {
        let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
        rotateUpAction.timingMode = .easeOut
        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.8)
        rotateDownAction.timingMode = .easeIn
        
        // Create the flying animation:
        let flyFrames: [SKTexture] = [
            textureAtlas.textureNamed("pierre-flying-1"),
            textureAtlas.textureNamed("pierre-flying-2"),
            textureAtlas.textureNamed("pierre-flying-3"),
            textureAtlas.textureNamed("pierre-flying-4"),
            textureAtlas.textureNamed("pierre-flying-3"),
            textureAtlas.textureNamed("pierre-flying-2"),
        ]
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.03)
        // Group together the flying animation with rotation:
        flyAnimation = SKAction.group([SKAction.repeatForever(flyAction), rotateUpAction])
        // Create the soaring animation,
        let soarFrames: [SKTexture] = [textureAtlas.textureNamed("pierre-flying-1")]
        let soarAction = SKAction.animate(with: soarFrames, timePerFrame: 1)
        // Group the soaring animation with the rotation down:
        soarAnimation = SKAction.group([SKAction.repeatForever(soarAction),
                                        rotateDownAction])
    }
    
    // Implement onTap to conform to the GameSprite protocol:
    func onTap() {
    }
    
    func update() {
        // If flapping, apply a new force to push Pierre higher.
        if self.flapping {
            var forceToApply = maxFlappingForce
            // Apply less force if Pierre is above position 600
            if position.y > 600 {
                // The higher Pierre goes, the more force we remove. These next three lines determine the force to subtract:
                let percentageOfMaxHeight = position.y / maxHeight
                let flappingForceSubtraction = percentageOfMaxHeight * maxFlappingForce
                forceToApply -= flappingForceSubtraction
            }
            // Apply the final force:
            self.physicsBody?.applyForce(CGVector(dx: 0, dy: forceToApply))
        }
        // Limit Pierre's top speed as he climbs the y-axis. This prevents him from gaining enough momentum to shoot over our max height:
        if self.physicsBody!.velocity.dy > 300 {
            self.physicsBody!.velocity.dy = 300
        }
        
        // Set a constant velocity to the right:
        self.physicsBody?.velocity.dx = self.forawrdVelocity
    }
    
    // Begin the flap animation, set flapping to true:
    func startFlapping() {
        if self.health <= 0 { return }
        self.removeAction(forKey: "soarAnimation")
        self.run(flyAnimation, withKey: "flapAnimation")
        self.flapping = true
    }
    
    // Stop the flap animation, set flapping to false:
    func stopFlapping() {
        if self.health <= 0 { return }
        self.removeAction(forKey: "flapAnimation")
        self.run(soarAnimation, withKey: "soarAnimation")
        self.flapping = false
    }
    
    func die() {
        // Make sure the player is fully visible:
        self.alpha = 1
        // Remove all animations:
        self.removeAllActions()
        // Run the die animation:
        self.run(self.dieAnimation)
        // Prevent any further upward movement:
        self.flapping = false
        // Stop forward movement:
        self.forawrdVelocity = 0
    }
    
    func takeDamage() {
        // if invulnerable or damaged, return:
        if self.invulnerable || self.damaged { return }
        
        // Remove one from our health pool
        self.health -= 1
        if self.health == 0 {
            // If we are out of health, run the die function:
            die()
        } else {
            // Run the take damage animation:
            self.run(self.damageAnimation)
        }
    }
}
