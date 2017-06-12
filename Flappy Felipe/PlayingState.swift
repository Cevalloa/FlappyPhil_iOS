//
//  PlayableState.swift
//  Flappy Phil
//
//  Created by Alex Cevallos on 5/26/17.
//  Copyright © 2017 Alex Cevallos. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayingState: GKState {
    
    // Gives access to game scene to call methods from this class
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        
        self.scene = scene as! GameScene
        super.init()
    }
    
    // What happens when state machine transitions into this state
    override func didEnter(from previousState: GKState?) {
        
        scene.startSpawning()
        scene.player.movementAllowed = true
        scene.player.animationComponent.startAnimation() // Access components through scene!
    }
    
    // Is a state machine in this state allowed to transition into specific states
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        // Falling state and game over states are okay!
        return (stateClass == FallingState.self) || (stateClass == GameOverState.self)
    }
    
    // Called when a state machine calls its own update method
    override func update(deltaTime seconds: TimeInterval) {
        
        scene.updateForeground()
        scene.updateScore()
    }
}
