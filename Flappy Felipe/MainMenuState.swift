//
//  MainMenuState.swift
//  Flappy Phil
//
//  Created by Alex Cevallos on 6/8/17.
//  Copyright © 2017 Alex Cevallos. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenuState: GKState {
    
    // Gives access to game scene to call methods from this class
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.setUpBackground()
        scene.setUpForeground()
        scene.setupPlayer()
        setUpMainMenu()
        
        scene.player.movementAllowed = false
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        return stateClass is TutorialState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
    func setUpMainMenu() {
        
        // Logo
        let logo = SKSpriteNode(imageNamed: "Logo")
        logo.position = CGPoint(x: scene.size.width / 2, y: scene.size.height * 0.8)
        logo.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(logo)
        
        // Play Button
        let playButton = SKSpriteNode(imageNamed: "Button")
        playButton.position = CGPoint(x: scene.size.width * 0.25, y: scene.size.height * 0.25)
        playButton.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(playButton)
        
        let playButtonText = SKSpriteNode(imageNamed: "Play")
        playButtonText.position = CGPoint.zero
        playButton.addChild(playButtonText)
        
        // Rate Button
        let rateButton = SKSpriteNode(imageNamed: "Button")
        rateButton.position = CGPoint(x: scene.size.width * 0.75, y: scene.size.height * 0.25)
        rateButton.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(rateButton)
        
        let rateButtonText = SKSpriteNode(imageNamed: "Rate")
        rateButtonText.position = CGPoint.zero
        rateButton.addChild(rateButtonText)
        
        // Learn Button
        let learnButton = SKSpriteNode(imageNamed: "button_learn")
        learnButton.position = CGPoint(x: scene.size.width * 0.5, y: learnButton.size.height / 2 + scene.margin)
        learnButton.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(learnButton)
        
        // Bounce
        let scaleUp = SKAction.scale(to: 1.02, duration: 0.75)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(to: 0.98, duration: 0.75)
        scaleDown.timingMode = .easeInEaseOut
        learnButton.run(SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown])))
        
        #if os(tvOS)
            playButton.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
            rateButton.isHidden = true
            learnButton.isHidden = true
            
            playButton.run(SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown])))
        #endif
    }
}





