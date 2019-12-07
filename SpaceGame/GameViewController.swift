//
//  GameViewController.swift
//  SpaceGame
//
//  Created by Ryan on 12/6/19.
//  Copyright © 2019 Ryan Rottmann. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            print("yes")
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! SKScene? {
                
                // Copy gameplay related content over to the scene
                print("yes2")
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    print("yes3")
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
                
            }
        }
    }
    func reloadGame(){
        if let scene = GKScene(fileNamed: "GameScene") {
            
            print("yes")
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! SKScene? {
                
                // Copy gameplay related content over to the scene
                print("yes2")
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    print("yes3")
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
                
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
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
