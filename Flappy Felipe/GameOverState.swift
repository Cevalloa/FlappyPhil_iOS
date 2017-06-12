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
    let animationDelay = 0.3
    
    init(scene: SKScene) {
        
        self.scene = scene as! GameScene
        super.init()
    }
    
    // What happens when state machine transitions into this state
    override func didEnter(from previousState: GKState?) {
        
        scene.run(hitGroundAction)
        scene.stopSpawning()
        
        scene.player.movementAllowed = false
        showScoreCard()
    }
    
    // Is a state machine in this state allowed to transition into specific states
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        return stateClass is PlayingState.Type
    }
    
    // Called when a state machine calls its own update method
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
    // MARK: Score methods
    func setBestScore(_ bestScore: Int) {
        
        UserDefaults.standard.set(bestScore, forKey: "BestScore")
        UserDefaults.standard.synchronize()
    }
    
    func bestScore() -> Int {
        return UserDefaults.standard.integer(forKey: "BestScore")
    }
    
    func showScoreCard() {
        
        if scene.score > self.bestScore() {
            setBestScore(scene.score)
        }
        
        let scoreCard = SKSpriteNode(imageNamed: "ScoreCard")
        scoreCard.position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height * 0.5)
        scoreCard.name = "Tutorial"
        scoreCard.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(scoreCard)
        
        let lastScore = SKLabelNode(fontNamed: scene.fontName)
        lastScore.fontColor = SKColor(red: 101.0/255.0, green: 71.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        lastScore.position = CGPoint(x: -scoreCard.size.width * 0.25, y: -scoreCard.size.height * 0.2)
        lastScore.zPosition = Layer.ui.rawValue
        lastScore.text = "\(scene.score / 2)"
        scoreCard.addChild(lastScore)
        
        let bestScore = SKLabelNode(fontNamed: scene.fontName)
        bestScore.fontColor = SKColor(red: 101.0/255.0, green: 71.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        bestScore.position = CGPoint(x: scoreCard.size.width * 0.25, y: -scoreCard.size.height * 0.2)
        bestScore.zPosition = Layer.ui.rawValue
        bestScore.text = "\(self.bestScore() / 2)"
        scoreCard.addChild(bestScore)
        
        let gameOver = SKSpriteNode(imageNamed: "GameOver")
        gameOver.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2 + scoreCard.size.height / 2 + scene.margin + gameOver.size.height / 2)
        gameOver.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(gameOver)
        
        let okButton  = SKSpriteNode(imageNamed: "Button")
        okButton.position = CGPoint(x: scene.size.width * 0.25, y: scene.size.height / 2 - scoreCard.size.height / 2 - scene.margin - okButton.size.height / 2)
        okButton.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(okButton)
        
        let okText = SKSpriteNode(imageNamed: "OK")
        okText.position = CGPoint.zero
        okText.zPosition = Layer.ui.rawValue
        okButton.addChild(okText)
        
        let shareButton  = SKSpriteNode(imageNamed: "Button")
        shareButton.position = CGPoint(x: scene.size.width * 0.75, y: scene.size.height / 2 - scoreCard.size.height / 2 - scene.margin - shareButton.size.height / 2)
        shareButton.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(shareButton)
        
        let shareText = SKSpriteNode(imageNamed: "Share")
        shareText.position = CGPoint.zero
        shareText.zPosition = Layer.ui.rawValue
        shareButton.addChild(shareText)
        
        // Juice
        
        // Game over scales to bigger
        gameOver.setScale(0)
        gameOver.alpha = 0
        let group = SKAction.group([
            SKAction.fadeIn(withDuration: animationDelay),
            SKAction.scale(to: 1.0, duration: animationDelay)
            ])
        group.timingMode = .easeInEaseOut
        gameOver.run(SKAction.sequence([
            SKAction.wait(forDuration: animationDelay),
            group
            ]))
        
        // Scorecard moves up
        scoreCard.position = CGPoint(x: scene.size.width * 0.5, y: -scoreCard.size.height / 2)
        let moveTo = SKAction.move(to: CGPoint(x: scene.size.width / 2, y: scene.size.height / 2), duration: animationDelay)
        moveTo.timingMode = .easeInEaseOut
        scoreCard.run(SKAction.sequence([
            SKAction.wait(forDuration: animationDelay * 2),
            moveTo
            ]))
        
        // Okay And Share Button appear from nothing 
        okButton.alpha = 0
        shareButton.alpha = 0
        let fadeIn = SKAction.sequence([
            SKAction.wait(forDuration: animationDelay * 3),
            SKAction.fadeIn(withDuration: animationDelay)
            ])
        okButton.run(fadeIn)
        shareButton.run(fadeIn)
        
        // Popping Sound
        let pops = SKAction.sequence([
            SKAction.wait(forDuration: animationDelay),
            scene.popAction,
            SKAction.wait(forDuration: animationDelay),
            scene.popAction,
            SKAction.wait(forDuration: animationDelay),
            scene.popAction,
            ])
        scene.run(pops)

    }
}
