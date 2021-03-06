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
    case obstacle
    case foreground
    case player
    case sombrero
    case ui
    case flash
}

// Which category the sprite belongs
struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Player: UInt32 = 0b1
    static let Obstacle: UInt32 = 0b10
    static let Ground: UInt32 = 0b100
}

// MARK - Protocols
protocol GameSceneDelegate {
    
    func screenShot() -> UIImage
    func shareString(_ string: String, url: URL, image: UIImage)
 }
 
protocol TVControlScene {
    func setupTvControls()
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Delegate
    var gameSceneDelegate: GameSceneDelegate
    let appStoreLink = ""
    
    // Class Properties
        let worldNode = SKNode()
        var playableStart: CGFloat = 0
        var playableHeight: CGFloat = 0
    
        // Obstacle
        let bottomObstacleMinFraction: CGFloat = 0.1
        let bottomObstacleMaxFraction: CGFloat = 0.6
        let gapMultiplier: CGFloat = 4.5 // the higher the number, the easier the game
    
        // Delays for obstacles
        let firstSpawnDelay: TimeInterval = 1.75
        let everySpawnDelay: TimeInterval = 1.5
    
        // Creates infinite ground movement
        var numberOfForegrounds = 2
        let groundSpeed: CGFloat = 150
        var deltaTime: TimeInterval = 0
        var lastUpdateTimeInterval: TimeInterval = 0
        
        // Players
        let player = PlayerEntity(imageName: "Bird0")
    
        // Sounds
        let popAction = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
    
        // Initial State
        var initialState: AnyClass
    
        // State Machine
        lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
            MainMenuState(scene: self),
            TutorialState(scene: self),
            PlayingState(scene: self),
            FallingState(scene: self),
            GameOverState(scene: self)
            
            ])
    
        // Score keeping
        var score = 0
        var scoreLabel: SKLabelNode!
        var fontName = "AmericanTypewriter-Bold"
        var margin: CGFloat = 20.0
        let coinAction = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false) // Song played when point added
    
    //MARK: Initializer Methods
    init(size: CGSize, stateClass: AnyClass, delegate: GameSceneDelegate) {
        gameSceneDelegate = delegate
        initialState = stateClass
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SKScene Methods
    override func didMove(to view: SKView) { // Like view did load
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        addChild(worldNode)
        //setUpBackground()
        //setUpForeground()
        //setupPlayer()
        //setupScoreLabel()
        //startSpawning()
        
        stateMachine.enter(initialState)
        
        // If this is the scene loaded from TV OS.. setup the TV controls!
        let scene = self as SKScene
        if let scene = scene as? TVControlScene {
            scene.setupTvControls()
        }
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
        
//        updateForeground()
        // You can call it individually !
        stateMachine.update(deltaTime: deltaTime)
        
        // Notice we use the delta to avoid "holes" in movement
        player.update(deltaTime: deltaTime)
    }
    
    // MARK: Set Up Node Methods
    func setUpBackground() {
        
        let backgroundNode = SKSpriteNode(imageNamed: "Background")
        // Used to work only for iPhone
//        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 1.0)
//        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height)
//        backgroundNode.zPosition = Layer.background.rawValue
        //        worldNode.addChild(backgroundNode)

        
        // Needed for Apple TV
        let numberOfSprites = Int(size.width / backgroundNode.size.width) + 1
        for i in 0..<numberOfSprites {
            
            let background = SKSpriteNode(imageNamed: "Background")
            background.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            background.position = CGPoint(x: CGFloat(i) * background.size.width + 1, y: size.height)
            background.zPosition = Layer.background.rawValue
            background.name = "background"
            worldNode.addChild(background)
        }
        
        // Playable Start = height of the ground
        playableStart = size.height - backgroundNode.size.height
        // Playable height = height of the sky
        playableHeight = backgroundNode.size.height
        
        // Add Physics
        let lowerLeft = CGPoint(x: 0, y: playableStart)
        let lowerRight = CGPoint(x: size.width, y: playableStart)
        physicsBody = SKPhysicsBody(edgeFrom: lowerLeft, to: lowerRight)
        physicsBody?.categoryBitMask = PhysicsCategory.Ground
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.Player
    }
    
    func setUpForeground() {
        
        // Added for Apple TV
        let foreground = SKSpriteNode(imageNamed: "Ground")
        let numberOfSprites = Int(size.width / foreground.size.width) + numberOfForegrounds
        numberOfForegrounds = numberOfSprites
        
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
        player.movementComponent.playableHeight = playableHeight + playableStart
        player.animationComponent.startWobble()
        
    }
    
    // MARK: Point Tracking Methods
    func setupScoreLabel() {
        
        scoreLabel = SKLabelNode(fontNamed: fontName)
        scoreLabel.fontColor = SKColor(red: 101.0/255.0, green: 71.0/255.0, blue: 73.0/255, alpha: 1.0)
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - margin)
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.zPosition = Layer.ui.rawValue
        scoreLabel.text = "\(score)"
        worldNode.addChild(scoreLabel)
    }
    
    // MARK: Obstacle Methods
    func createObstacle() -> SKSpriteNode {
        
        let obstacle = ObstacleEntity(imageName: "Cactus")
        let obstacleNode = obstacle.spriteCompnent.node
        obstacleNode.zPosition = Layer.obstacle.rawValue
        obstacleNode.name = "obstacle"
        obstacleNode.userData = NSMutableDictionary()
        
        return obstacle.spriteCompnent.node
    }
    
    func stopSpawning() {
        removeAction(forKey: "spawn")
        worldNode.enumerateChildNodes(withName: "obstacle") { (node, stop) in
            node.removeAllActions()
        }
    }
    
    func spawnObstacle() {
        
        let bottomObstacle = createObstacle()
        let startX = size.width + bottomObstacle.size.width / 2
        
        let bottomObstacleMin = (playableStart - bottomObstacle.size.height / 2) + playableHeight * bottomObstacleMinFraction
        let bottomObstacleMax = (playableStart - bottomObstacle.size.height / 2) + playableHeight * bottomObstacleMaxFraction

        // Using gameplaykit's randomization
        let randomSource = GKARC4RandomSource()
        let randomDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: Int(round(bottomObstacleMin)), highestValue: Int(round(bottomObstacleMax)))
        
        let randomValue = randomDistribution.nextInt()
        
        bottomObstacle.position = CGPoint(x: startX, y: CGFloat(randomValue))
        worldNode.addChild(bottomObstacle)
        
        // Top Obstacle
        let topObstacle = createObstacle()
        topObstacle.zRotation = CGFloat(180).degreesToRadians()
        topObstacle.position = CGPoint(x: startX,
                                       y: bottomObstacle.position.y + bottomObstacle.size.height / 2 + topObstacle.size.height / 2 + player.spriteComponent.node.size.height * gapMultiplier )
        
        worldNode.addChild(topObstacle)
        
        // Move obstacles
        let moveX = size.width + topObstacle.size.width // Ending location (we will reverse it)
        let moveDuration = moveX / groundSpeed // Ending location / speed ground is going
        
        let sequence = SKAction.sequence([
            SKAction.moveBy(x: -moveX, y: 0, duration: TimeInterval(moveDuration)),
            SKAction.removeFromParent()
            ])
        
        topObstacle.run(sequence)
        bottomObstacle.run(sequence)
    }
    
    func startSpawning() {
        
        let firstDelay = SKAction.wait(forDuration: firstSpawnDelay)
        let spawn = SKAction.run(spawnObstacle)
        let everyDelay = SKAction.wait(forDuration: everySpawnDelay)
        
        let spawnSequence = SKAction.sequence([spawn, everyDelay])
        let foreverSpawn = SKAction.repeatForever(spawnSequence)
        let overallSequence = SKAction.sequence([firstDelay, foreverSpawn])
        
        //run(overallSequence)
        run(overallSequence, withKey: "spawn")
    }
    
    func updateScore() {
        
        worldNode.enumerateChildNodes(withName: "obstacle") { (node, stop) in
            if let obstacle = node as? SKSpriteNode {
                
                if let passed = obstacle.userData?["Passed"] as? NSNumber {
                    
                    if passed.boolValue {
                        return
                    }
                }
                
                if self.player.spriteComponent.node.position.x > obstacle.position.x + obstacle.size.width / 2 {
                    
                    self.score += 1
                    self.scoreLabel.text = "\(self.score/2)"
                    obstacle.userData?["Passed"] = NSNumber(value: true as Bool)
                    self.run(self.coinAction)
                }
            }
        }
    }
    
    // MARK - Restart
    func restartGame(_ stateClass: AnyClass) {
        
        run(popAction)
        let newScene = GameScene(size: size, stateClass: stateClass, delegate: gameSceneDelegate)
        let transition = SKTransition.fade(with: SKColor.black, duration: 0.02)
        view?.presentScene(newScene, transition: transition)
    }
    
    // MARK - External App Methods
    func shareScore() {
        
        let urlString = appStoreLink
        let url = URL(string: urlString)
        
        let screenShot = gameSceneDelegate.screenShot()
        let initialTextString = "OMG! I scored \(score / 2) points in Flappy Felipe!"
        gameSceneDelegate.shareString(initialTextString, url: url!, image: screenShot)
    }
    
    func rateApp() {
        
        let urlString = appStoreLink
        let url = URL(string: urlString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func learn() {
        let urlString = ""
        let url = URL(string: urlString)
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // if BodyA == player { other = bodyB} else { other = bodyA}
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        
        if other.categoryBitMask == PhysicsCategory.Ground {
            
//            print("hit ground")
            stateMachine.enter(GameOverState.self)
        }
        
        if other.categoryBitMask == PhysicsCategory.Obstacle {
//            print("hit obstacle")
            stateMachine.enter(FallingState.self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        player.movementComponent.applyImpulse(lastUpdateTimeInterval)
        
        #if os(iOS)
        if let touch = touches.first {
            
            let touchLocation = touch.location(in:self)
            
            switch stateMachine.currentState {
                
            case is MainMenuState:
                
                if touchLocation.y < size.height * 0.15 {
                    
                    learn()
                } else if touchLocation.x < size.width * 0.6 {
                    restartGame(TutorialState.self)
                } else {
                    
                    rateApp()
                }
            case is TutorialState:
                stateMachine.enter(PlayingState.self)
                
            case is PlayingState:
                player.movementComponent.applyImpulse(lastUpdateTimeInterval)
                
            case is GameOverState:
                
                if touchLocation.x < size.width * 0.6 {
                    
                    restartGame(TutorialState.self)
                } else {
                    
                    shareScore()
                }
                
            default:
                break
            }
        }
        #endif
    }
}






