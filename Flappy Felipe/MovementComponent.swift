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
    
    // MARK: Initialize Methods
    init(entity: GKEntity) {
        
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Movement Methods
    func applyMovement(_ seconds: TimeInterval) {
        
        let spriteNode = spriteComponent.node
        
        // Apply Gravity, seconds is time since last call to this method`
        
        // Gravity Step = how much you want to go down by
        let gravityStep = CGPoint(x: 0, y: gravity) * CGFloat(seconds) // 0, 1500 x milisecond difference
        
        // Velocity is the location where gravity wants you to be
        velocity += gravityStep // Gravity wants you here += how much you want to keep going down by
        
        // Apply Velocity
        let velocityStep = velocity * CGFloat(seconds) // Velocity is Y
        
        spriteNode.position += velocityStep //Move down bit by bit with velocity step
        
        // Temporary Ground Hit
        // if the y position
        if spriteNode.position.y - spriteNode.size.height / 2 < playableStart {
            spriteNode.position = CGPoint(x: spriteNode.position.x, y: playableStart + spriteNode.size.height / 2)
        }
    }
    
    func applyImpulse(_ seconds: TimeInterval) {
        
        velocity = CGPoint(x: 0, y: impulse)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let player = entity as? PlayerEntity {
            if player.movementAllowed {
                applyMovement(seconds)
            }
        }
    }
}
