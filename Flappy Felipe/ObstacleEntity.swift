//
//  ObstacleEntity.swift
//  Flappy Phil
//
//  Created by Alex Cevallos on 5/14/17.
//  Copyright © 2017 Alex Cevallos. All rights reserved.
//

import SpriteKit
import GameplayKit


class ObstacleEntity: GKEntity {
    
    var spriteCompnent: SpriteComponent!
    
    //MARK: Initializer Methods
    init(imageName: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        spriteCompnent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteCompnent)
        
        // Add Physics
        let spriteNode = spriteCompnent.node
        spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
        spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        spriteNode.physicsBody?.collisionBitMask = 0
        spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.Player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
