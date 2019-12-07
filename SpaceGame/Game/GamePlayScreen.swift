//
//  GamePlayScreen.swift
//  SpaceGame
//
//  Created by Ryan on 12/6/19.
//  Copyright © 2019 Ryan Rottmann. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GamePlayScreen: SKScene {
    var starfield:SKEmitterNode!
    var player:SKSpriteNode!
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var gameTimer: Timer!
    var gameTimerLabel: SKLabelNode!
    
    var possibleAliens = ["alien", "alien2", "alien3"]
    
    let alienCategory:UInt32 = 0x1 << 1
    let photonTorpedoCategory:UInt32 = 0x1 << 0
    
    let motionManager = CMMotionManager()

    var xAcceleration:CGFloat = 0
    
    var livesArray:[SKSpriteNode]!
    
    var levelLabel:SKLabelNode!
    var level:Int = 1{
        didSet{
            levelLabel.text = "Level: \(level)"
        }
    }
    
    override func didMove(to view: SKView) {
        print("loadedScene")
    //doverride func sceneDidLoad(){
        
        addLives()
        
        let screenSize = UIScreen.main.bounds

        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: UIScreen.main.bounds.height + 200)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -1
        
        
        player = SKSpriteNode(imageNamed: "shuttle")
        
        player.position = CGPoint(x: 0, y: -screenSize.height + 100)
        print(screenSize.height)
        self.addChild(player)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self as! SKPhysicsContactDelegate
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: -screenSize.width + 100, y: screenSize.height - 50)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        self.addChild(scoreLabel)
        
        levelLabel = SKLabelNode(text: "Level: 0")
        levelLabel.position = CGPoint(x: -screenSize.width + 300, y: screenSize.height - 50)
        levelLabel.fontName = "AmericanTypewriter-Bold"
        levelLabel.fontSize = 36
        levelLabel.fontColor = UIColor.white
        level = 1
        
        self.addChild(levelLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {(data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data{
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
        }
        
    }
    
    func addLives(){
        livesArray = [SKSpriteNode]()
        for live in 1 ... 5 {
            let liveNode = SKSpriteNode(imageNamed: "shuttle")
            liveNode.position = CGPoint(x: UIScreen.main.bounds.width - CGFloat(50 * live), y: UIScreen.main.bounds.height - 50)
            self.addChild(liveNode)
            livesArray.append(liveNode)
        }
    }
    
    @objc func addAlien(){
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        let randomAlienPosition = GKRandomDistribution(lowestValue: Int(-UIScreen.main.bounds.width), highestValue: Int(UIScreen.main.bounds.width))
        let position = CGFloat(randomAlienPosition.nextInt())
        
        alien.position = CGPoint(x: position, y: UIScreen.main.bounds.height)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        
        let animationDuration: TimeInterval = 6
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -UIScreen.main.bounds.height), duration: animationDuration))
        actionArray.append(SKAction.run {
            
            //self.run(SKAction.playSoundFileNamed("", waitForCompletion:false))
            if self.livesArray.count > 0{
                let liveNode = self.livesArray.first
                liveNode!.removeFromParent()
                self.livesArray.removeFirst()
                if self.livesArray.count == 0{
                    print("GameOver")
                }
            }
            print(self.livesArray.count)
        })
        actionArray.append(SKAction.removeFromParent())
    
        alien.run(SKAction.sequence(actionArray))
        
    }
    

    
    func fireTorepedo(){
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        
        torpedoNode.position = player.position
        torpedoNode.position.y += 5
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width/2)
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = alienCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(torpedoNode)
        
        let animationDuration:TimeInterval = 0.3
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: UIScreen.main.bounds.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        torpedoNode.run(SKAction.sequence(actionArray))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0 && firstBody.node != nil && secondBody.node != nil{
            torpedoCollision(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTorepedo()
        if let scene1 = SKScene(fileNamed: "MenuScene") {
            
           print("yes")
                   self.view?.presentScene(scene1)
        }
    }
    
    func torpedoCollision(torpedoNode:SKSpriteNode, alienNode:SKSpriteNode){
        let explosion = SKEmitterNode(fileNamed: "Explosion")
        explosion!.position = alienNode.position
        self.addChild(explosion!)
        
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2), completion: {
            explosion?.removeFromParent()
            
        })
            
            
        score += 1
        if (score%10 == 0){
            level += 1
            addLives()
            gameTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        }
    }
    
    override func didSimulatePhysics() {
        player.position.x += xAcceleration * 50
        
        if(player.position.x > UIScreen.main.bounds.width){
            player.position = CGPoint(x: -UIScreen.main.bounds.width, y: player.position.y)
        } else if player.position.x < -UIScreen.main.bounds.width {
            player.position = CGPoint(x: UIScreen.main.bounds.width, y: player.position.y)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {


    }
    
}
