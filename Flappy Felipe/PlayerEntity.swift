//
//  PlayerEntity.swift
//  Flappy Phil
//
//  Created by Alex Cevallos on 5/9/17.
//  Copyright © 2017 Alex Cevallos. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayerEntity: GKEntity {
    
    // MARK: Components
    var spriteComponent: SpriteComponent!
    var movementComponent: MovementComponent!
    var animationComponent: AnimationComponent!
    
    var movementAllowed = false
    var numberOfFrames = 3
    
    // Sombrero
    let sombrero = SKSpriteNode(imageNamed: "Sombrero")
    
    // MARK: - Initialization Methods
    init(imageName: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        
        // Sprite component (image!)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        // Sombrero on his head
        sombrero.position = CGPoint(x: 31 - sombrero.size.width / 2, y: 29 - sombrero.size.height / 2)
        sombrero.zPosition = Layer.sombrero.rawValue
        spriteComponent.node.addChild(sombrero)
        
        movementComponent = MovementComponent(entity: self)
        addComponent(movementComponent)
        
        // Adds frames in forward motion
        var textures: Array<SKTexture> = []
        for i in 0..<numberOfFrames {
            
            textures.append(SKTexture(imageNamed: "Bird\(i)"))
        }

        // Adds frames in a backwards motion
        for i in stride(from: numberOfFrames, to: 0, by: -1) {
            textures.append(SKTexture(imageNamed: "Bird\(i)"))
        }
        
        // Now add textures to animation component
        animationComponent = AnimationComponent(entity: self, textures: textures)
        // Now add component to this Entity (Phil!)
        addComponent(animationComponent)
        
        // So phil points up on start
        movementComponent.applyInitialImpulse()
        
        // Add Physics
        let spriteNode = spriteComponent.node
        spriteNode.physicsBody = SKPhysicsBody(texture: spriteNode.texture!, size: spriteNode.frame.size)
        spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.Player
        spriteNode.physicsBody?.collisionBitMask = 0
        spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Ground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
