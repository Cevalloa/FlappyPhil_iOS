//
//  MovementComponent.swift
//  Flappy Phil
//
//  Created by Alex Cevallos on 5/12/17.
//  Copyright © 2017 Alex Cevallos. All rights reserved.
//

import Foundation
import GameplayKit

class MovementComponent: GKComponent {
    let spriteComponent: SpriteComponent
    
    let impulse: CGFloat = 400
    var velocity = CGPoint.zero
    let gravity: CGFloat = -1500
    
    // Where should it drop to
    var playableStart: CGFloat = 0
    
    // Physics variables to tilt
    var velocityModifier: CGFloat = 1000.0 // What angle do you want to go
    var angularVelocity: CGFloat = 0.0 // Angle of phil
    var minDegrees: CGFloat = -90
    let maxDegrees: CGFloat = 25
    
    // Physics time variables
    var lastTouchTime: TimeInterval = 0
    var lastTouchY: CGFloat = 0.0
    
    // MARK: Initialize Methods
    init(entity: GKEntity) {
        
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Movement Methods
    func applyInitialImpulse() {
        velocity = CGPoint(x: 0, y: impulse * 2)
    }
    
    func applyMovement(_ seconds: TimeInterval) {
        
        let spriteNode = spriteComponent.node
        
        // Apply Gravity, seconds is time since last call to this method`
        
        // Gravity Step = how much you want to go down by
        let gravityStep = CGPoint(x: 0, y: gravity) * CGFloat(seconds) // 0, 1500 x milisecond difference
        
        // Velocity is the location where gravity wants you to be
        velocity += gravityStep // Gravity wants you here += how much you want to keep going down by
        
        // Apply Velocity
        let velocityStep = velocity * CGFloat(seconds) // Velocity is Y
        
        // If phil is lower than last , angularVelocity should point south
        if spriteNode.position.y < lastTouchY {
           angularVelocity = -velocityModifier.degreesToRadians()
        }
        
        // Rotation
        let angularStep = angularVelocity * CGFloat(seconds) // similar to velocity
        spriteNode.zRotation += angularStep // Tilt in that direction
        // min (max(SpriteNodeAngle, minimumAngle ) , maximumAngle
        spriteNode.zRotation = min(max(spriteNode.zRotation,
                                       minDegrees.degreesToRadians()), maxDegrees.degreesToRadians())
        
        
        spriteNode.position += velocityStep //Move down bit by bit with velocity step
        
        // Temporary Ground Hit
        // if the y position
        if spriteNode.position.y - spriteNode.size.height / 2 < playableStart {
            spriteNode.position = CGPoint(x: spriteNode.position.x, y: playableStart + spriteNode.size.height / 2)
        }
    }
    
    func applyImpulse(_ lastUpdateTime: TimeInterval) {
        
        velocity = CGPoint(x: 0, y: impulse)
        angularVelocity = velocityModifier.degreesToRadians()
        lastTouchTime = lastUpdateTime
        lastTouchY = spriteComponent.node.position.y
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let player = entity as? PlayerEntity {
            if player.movementAllowed {
                applyMovement(seconds)
            }
        }
    }
}
