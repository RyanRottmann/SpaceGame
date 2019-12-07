//
//  MenuScene.swift
//  SpaceGame
//
//  Created by Ryan on 12/6/19.
//  Copyright © 2019 Ryan Rottmann. All rights reserved.
//
import UIKit
import SpriteKit
import GameplayKit
import CoreMotion

class MenuScene: SKScene {
    var starfield:SKEmitterNode!
    var newGameButtonNode:SKSpriteNode!
    var gameOverText:UILabel!
    
    override func didMove(to view: SKView) {
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -1
        starfield.advanceSimulationTime(10)

        let newGameButtonNode = SKSpriteNode(imageNamed: "startButton")
        newGameButtonNode.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        newGameButtonNode.name = "startButton"
        self.addChild(newGameButtonNode)


    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "startButton" {
                print("yes")
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                //let gameScene = GameScene(size: self.size)
                //self.view?.presentScene(GameScene, transition: transition)
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
        }
        
    }
    
}
