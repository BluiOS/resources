//
//  GameViewController.swift
//  Bodyguard
//
//  Created by HEssam on 4/9/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as? SKView {
          
          // Create the scene
           let scene = GameScene(size:view.bounds.size)
//          let scene = GameScene(size: CGSize(width: 1336, height: 1024))
          
          // Set the scale mode to scale to fill the view window
          scene.scaleMode = .aspectFill
          
          // Set the background color
          scene.backgroundColor =  UIColor(red: 105/255,
                                           green: 157/255,
                                           blue: 181/255,
                                           alpha: 1.0)
          
          // Present the scene
          view.presentScene(scene)
          
          // Set the view options
          view.ignoresSiblingOrder = false
          view.showsPhysics = true
          view.showsFPS = true
          view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
