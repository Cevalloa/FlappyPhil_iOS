//
//  TutorialState.swift
//  Flappy Phil
//
//  Created by Alex Cevallos on 6/8/17.
//  Copyright © 2017 Alex Cevallos. All rights reserved.
//

import SpriteKit
import GameplayKit

class TutorialState: GKState {
    
    // Gives access to game scene to call methods from this class
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
        setUpTutorial()
    }
    
    // Runs when leaving this state
    override func willExit(to nextState: GKState) {
        
        // Remove tutorial sprites
        scene.worldNode.enumerateChildNodes(withName: "Tutorial") { (node, stop) in
            node.run(SKAction.sequence([
                
                SKAction.fadeOut(withDuration: 0.5),
                SKAction.removeFromParent()
                ]))
        }
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        return stateClass is PlayingState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
    func setUpTutorial() {
        
        scene.setUpBackground()
        scene.setUpForeground()
        scene.setupPlayer()
        scene.setupScoreLabel()
        
        let tutorial = SKSpriteNode(imageNamed: "Tutorial")
        tutorial.position = CGPoint(x: scene.size.width * 0.5, y: scene.playableHeight * 0.4 + scene.playableStart)
        tutorial.name = "Tutorial"
        tutorial.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(tutorial)
        
        let ready = SKSpriteNode(imageNamed: "Ready")
        ready.position = CGPoint(x: scene.size.width * 0.5, y: scene.playableHeight * 0.7 + scene.playableStart)
        ready.name = "Tutorial"
        tutorial.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(ready)
    }
}
