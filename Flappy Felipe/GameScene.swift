//
//  GameScene.swift
//  Flappy Felipe
//
//  Created by Alex Cevallos on 5/2/17.
//  Copyright © 2017 Alex Cevallos. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Layer: CGFloat {
    case background
    case foreground
    case player
}

class GameScene: SKScene {
    
    // Class Properties
        let worldNode = SKNode()
        var playableStart: CGFloat = 0
        var playableHeight: CGFloat = 0
        
        // Creates infinite ground movement
        let numberOfForegrounds = 2
        let groundSpeed: CGFloat = 150
        var deltaTime: TimeInterval = 0
        var lastUpdateTimeInterval: TimeInterval = 0
        
        // Players
        let player = PlayerEntity(imageName: "Bird0")
    
    // MARK: SKScene Methods
    override func didMove(to view: SKView) {
        
        addChild(worldNode)
        setUpBackground()
        setUpForeground()
        setupPlayer()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // Called once, saves the current time as last updated
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        
        // Minuses the last updated time from the current time
        deltaTime = currentTime - lastUpdateTimeInterval
        
        // Assigns the current time to the last updated
        lastUpdateTimeInterval = currentTime
        
        updateForeground()
        
        // Notice we use the delta to avoid "holes" in movement
        player.update(deltaTime: deltaTime)
    }
    
    // MARK: Set Up Node Methods
    func setUpBackground() {
        
        let backgroundNode = SKSpriteNode(imageNamed: "Background")
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height)
        backgroundNode.zPosition = Layer.background.rawValue
        
        worldNode.addChild(backgroundNode)
        
        // Playable Start = height of the ground
        playableStart = size.height - backgroundNode.size.height
        // Playable height = height of the sky
        playableHeight = backgroundNode.size.height
    }
    
    func setUpForeground() {
        
        for i in 0..<numberOfForegrounds {
            
            let foreground = SKSpriteNode(imageNamed: "Ground")
            foreground.anchorPoint = CGPoint(x: 0, y: 1.0)
            foreground.position = CGPoint(x: CGFloat(i) * foreground.size.width, y: playableStart)
            foreground.zPosition = Layer.foreground.rawValue
            foreground.name = "foreground"
            
            worldNode.addChild(foreground)
        }
    }
    
    // Makes floor appear to be moving
    func updateForeground() {
        
        worldNode.enumerateChildNodes(withName: "foreground") { (node, stop) in
            
            if let foreground = node as? SKSpriteNode {
                
                // Move to the left times the change in time
                // Delta time ensures smooth animation (percentage completed)
                let moveAmount = CGPoint(x: -self.groundSpeed * CGFloat(self.deltaTime), y:0)
                
                // Accelerate the bottom node to the right by moveAmount
                foreground.position += moveAmount
                
                // If each individual node in the foreground is less than screen width
                // -320 means TWO of the nodes are to the left
                // So move the nodes back to the left !
                if foreground.position.x < -foreground.size.width {
                    
                    foreground.position += CGPoint(x: foreground.size.width * CGFloat(self.numberOfForegrounds), y:0)
                }
            }
        }
    }

    // MARK: Entity Methods
    func setupPlayer() {
        
        let playerNode = player.spriteComponent.node
        playerNode.position = CGPoint(x: size.width * 0.2, y: playableHeight * 0.4 + playableStart)
        playerNode.zPosition = Layer.player.rawValue
        
        worldNode.addChild(playerNode)
        
        player.movementComponent.playableStart = playableStart
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.movementComponent.applyImpulse(lastUpdateTimeInterval)
    }
}






