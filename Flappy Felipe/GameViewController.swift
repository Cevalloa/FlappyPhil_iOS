//
//  GameViewController.swift
//  Flappy Felipe
//
//  Created by Alex Cevallos on 5/2/17.
//  Copyright © 2017 Alex Cevallos. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameSceneDelegate {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // GameViewController has a view, we change it to SKView
        if let skView = self.view as? SKView {
            
            if skView.scene == nil {
                
                // The aspect ratio is set to fit on all screen sizes
                let aspectRatio = skView.bounds.size.height / skView.bounds.size.width
                let scene = GameScene(size: CGSize(width: 320, height: 320 * aspectRatio), stateClass: MainMenuState.self, delegate: self)
                
                skView.showsFPS = false
                skView.showsNodeCount = false
                skView.showsPhysics = false
                skView.ignoresSiblingOrder = true
                
                scene.scaleMode = .aspectFit
                skView.presentScene(scene)
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: GameSceneDelegate Methods
    func screenShot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 1.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func shareString(_ string: String, url: URL, image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [string, image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}
