//
//  GameScene.swift
//  The Penguins Escape
//
//  Created by Tennant Shaw on 7/20/17.
//  Copyright © 2017 Tennant Shaw. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - Properties
    // Create a constant cam as SKCameraNode:
    let cam = SKCameraNode()
    let ground = Ground()
    let player = Player()
    var ScreenCenterY = CGFloat()
    let initialPlayerPosition = CGPoint(x: 150, y: 250)
    var playerProgress = CGFloat()
    let encounterManager = EncounterManager()
    var nextEncounterSpawnPosition = CGFloat(150)
    let powerUpStar = Star()
    
    // MARK: - View Life Cycle
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        // Assign the camera to the scene
        self.camera = cam
        
        // Position the ground based on the screen size.
        // Position X: Negative one screen width.
        // Position Y: 150 abov the bottom
        ground.position = CGPoint(x: -self.size.width * 2, y: 30)
        // Set the ground width to 3x the width of the scene
        ground.size = CGSize(width: self.size.width * 6, height: 0)
        // Run the ground's createChildren function to build the child texture tiles:
        ground.createChildren()
        // Add the ground node to the scene:
        self.addChild(ground)
        
        // Position the player:
        player.position = initialPlayerPosition
        // Add the player node to the scene:
        self.addChild(player)
        
        // Set gravity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        // Store the vertical center of the screen:
        ScreenCenterY = self.size.height / 2
        
        encounterManager.addEncountersToScene(gameScene: self)
        encounterManager.encounters[0].position = CGPoint(x: 400, y: 330)
        
        // Place the star out of the way for now:
        self.addChild(powerUpStar)
        powerUpStar.position = CGPoint(x: -2000, y: -2000)
        self.physicsWorld.contactDelegate = self
    }
    
    
    // MARK: - Physics Contact Delegate Methods
    func didBegin(_ contact: SKPhysicsContact) {
        // Each contact has two bodies, we do not know which is which. We will find the penguin body first, then use the other body to determine the type of contact.
        let otherBody: SKPhysicsBody
        // Combine the two penguin physics categories into one bitmask using the bitwise OR operator |
        let penguinMask = PhysicsCategory.penguin.rawValue | PhysicsCategory.damagedPenguin.rawValue
        // Use the bitwise AND operator & to find the penguin. This returns a positive number if body A's category is the same as either the penguin or damagedPenguin:
        if (contact.bodyA.categoryBitMask & penguinMask) > 0 {
            // bodyA is the penguin, we will test bodyB's type:
            otherBody = contact.bodyB
        } else {
            // bodyB is the penguin, we will test bodyA's type:
            otherBody = contact.bodyA
        }
        // Find the type of contact:
        switch otherBody.categoryBitMask {
        case PhysicsCategory.ground.rawValue:
            print("hit the ground")
        case PhysicsCategory.enemy.rawValue:
            print("take damage")
        case PhysicsCategory.coin.rawValue:
            print("collect a coin")
        case PhysicsCategory.powerup.rawValue:
            print("start the power-up")
        default:
            print("Contact with no game logic")
        }
    }
    
    
    // MARK: - Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            // Find the location of the touch:
            let location = touch.location(in: self)
            // Locate the node at this location:
            let nodeTouched = atPoint(location)
            // Attempt to downcast the node to the GameSprite protocol
            if let gameSprite = nodeTouched as? GameSprite {
                // If this node adheres to GameSprite, call onTap:
                gameSprite.onTap()
            }
        }
        
        player.startFlapping()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    
    // MARK: - Physics
    override func didSimulatePhysics() {
        // Keep the camera locked at mid screen by default:
        var cameraYPos = ScreenCenterY
        cam.yScale = 1
        cam.xScale = 1
        
        // Follow the player up if higher than half the screen:
        if (player.position.y > ScreenCenterY) {
            cameraYPos = player.position.y
            // Scale out the camera as they go higher:
            let percentOfMaxHeight = (player.position.y - ScreenCenterY) / (player.maxHeight - ScreenCenterY)
            let newScale = 1 + percentOfMaxHeight
            cam.yScale = newScale
            cam.xScale = newScale
            
            // Keep track of how far the player has flown
            playerProgress = player.position.x - initialPlayerPosition.x
            // Check to see if the ground should jump forward:
            ground.checkForReposition(playerProgress: playerProgress)
        }
        
        // Move the camera for our adjustment:
        self.camera!.position = CGPoint(x: player.position.x, y: cameraYPos)
        // Check to see if we should set a new encounter:
        if player.position.x > nextEncounterSpawnPosition {
            encounterManager.placeNextEncounter(currentXPos: nextEncounterSpawnPosition)
            nextEncounterSpawnPosition += 1200
            // Each encounter has a 10% chance to spawn a star:
            let starRoll = Int(arc4random_uniform(10))
            if starRoll == 0 {
                // Only move the star if it is off the screen
                if abs(player.position.x - powerUpStar.position.x) > 1200 {
                    // Y Position 50 - 450:
                    let randomYPos = 50 + CGFloat(arc4random_uniform(400))
                    powerUpStar.position = CGPoint(x: nextEncounterSpawnPosition, y: randomYPos)
                    // Remove any previous velocity and spin:
                    powerUpStar.physicsBody?.angularVelocity = 0
                    powerUpStar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                }
            }
        }
    }
    
    
    // MARK: - Updating frames
    override func update(_ currentTime: TimeInterval) {
        player.update()
    }
    
}


enum PhysicsCategory: UInt32 {
    case penguin = 1
    case damagedPenguin = 2
    case ground = 4
    case enemy = 8
    case coin = 16
    case powerup = 32
}
