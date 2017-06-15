//
//  GameScene+TV.swift
//  Flappy Phil
//
//  Created by Alex Cevallos on 6/15/17.
//  Copyright © 2017 Alex Cevallos. All rights reserved.
//

import SpriteKit

extension GameScene: TVControlScene {
    
    func setupTVControls() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(GameScene.didTapOnRemote(_:)))
    }
    
    func didTapOnRemote(_ tap: UITapGestureRecognizer) {
        
        switch stateMachine.currentState {
            
        case is MainMenuState:

            restartGame(TutorialState.self)
        case is TutorialState:
            stateMachine.enter(PlayingState.self)
        case is PlayingState:
            player.movementComponent.applyImpulse(lastUpdateTimeInterval)
        case is GameOverState:
            
            restartGame(TutorialState.self)
        default:
            break
        }
    }
}
