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
    
    var spriteComponent: SpriteComponent!
    var movementComponent: MovementComponent!
    
    init(imageName: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        
        // Sprite component (image!)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        movementComponent = MovementComponent(entity: self)
        addComponent(movementComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
