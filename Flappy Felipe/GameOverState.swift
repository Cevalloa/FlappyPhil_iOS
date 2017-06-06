//
//  GameOverState.swift
//  Flappy Phil
//
//  Created by Alex Cevallos on 5/26/17.
//  Copyright © 2017 Alex Cevallos. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverState: GKState {
    
    // Gives access to game scene to call methods from this class
    unowned let scene: GameScene
    
    let hitGroundAction = SKAction.playSoundFileNamed("hitGround.wav", waitForCompletion: false)
    
    init(scene: SKScene) {
        
        self.scene = scene as! GameScene
        super.init()
    }
    
    // What happens when state machine transitions into this state
    override func didEnter(from previousState: GKState?) {
        
        scene.run(hitGroundAction)
        scene.stopSpawning()
    }
    
    // Is a state machine in this state allowed to transition into specific states
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        return stateClass is PlayingState.Type
    }
    
    // Called when a state machine calls its own update method
    override func update(deltaTime seconds: TimeInterval) {
        
    }
}
