//
//  GameScene.swift
//  Final
//
//  Created by aborse on 12/13/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct Category {
        static let N: UInt32 = 0b00
        static let E: UInt32 = 0b01
        static let A: UInt32 = 0b10
        static let M: UInt32 = 0b11
    }

    
    private var earth = SKLabelNode()
    private var healthBar = SKShapeNode()
    private var scoreLabel = SKLabelNode()
    private var nameField = UITextField()
    
    var score: Int32 = 0
    var health: Float = 100
    var rotation = 0
    
    override func didMove(to view: SKView) {
        //Initialize physics world
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        //Create and postion Health bar and node
        let rect = CGRect(x: 0, y: 0, width: (0.75*view.frame.width), height: view.frame.height/20)
        self.healthBar = SKShapeNode(rect: rect)
        self.healthBar.fillColor = SKColor.green
        self.healthBar.position = CGPoint(x: view.frame.width/8, y: view.frame.height - 10)
        
        //Add healthBar node to scene
        self.addChild(self.healthBar)

        //Create and position Earth Node
        self.earth.text = "🌎"
        self.earth.fontSize = 75
        self.earth.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.earth.color = SKColor.white
        self.earth.position = view.center
        
        //Add physics body to earth
        self.earth.physicsBody = SKPhysicsBody(circleOfRadius: (0.45*self.earth.fontSize))
        self.earth.physicsBody?.isDynamic = false
        self.earth.physicsBody?.categoryBitMask = Category.E
        
        //Add earth node to scene
        self.addChild(self.earth)
        
        //Rotate the earth every second
        let rotate = SKAction.run(rotateEarth)
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                                           rotate])))
        
        //Endlessly spawn in new asteroids, with a delay
        let spawn1 = SKAction.repeat(SKAction.sequence([SKAction.run(addAsteroid),
                                                       SKAction.wait(forDuration: 2.0)]),
                                    count: 15)
        let spawn2 = SKAction.repeat(SKAction.sequence([SKAction.run(addAsteroid),
                                                        SKAction.wait(forDuration: 1.0)]),
                                     count: 30)
        let spawn3 = SKAction.repeatForever(SKAction.sequence([SKAction.run(addAsteroid),
                                                               SKAction.wait(forDuration: 0.75)]))
        
        //Every so often, increase spawn rates
        self.run(SKAction.sequence([spawn1, spawn2, spawn3]))
        }
    
    func rotateEarth() {
        if(self.rotation == 0) {
            self.earth.text = "🌍"
        }
        else if(self.rotation == 1) {
            self.earth.text = "🌏"
        }
        else {
            self.earth.text = "🌎"
        }
        
        self.rotation = (self.rotation + 1) % 3
        
    }
    
    func addAsteroid() {
        //Create asteroid node
        let ast = rules.game.createAsteroid(w: self.size.width, h: self.size.height)

        //Add physics body to asteroid
        ast.sprite.physicsBody = SKPhysicsBody(circleOfRadius: (0.45*ast.size))
        ast.sprite.physicsBody?.isDynamic = true
        ast.sprite.physicsBody?.categoryBitMask = Category.A
        ast.sprite.physicsBody?.contactTestBitMask = Category.E
        ast.sprite.physicsBody?.collisionBitMask = Category.N
        ast.sprite.physicsBody?.usesPreciseCollisionDetection = true
        
        //Add asteroid to the scene
        self.addChild(ast.sprite)
    }
    
    func launchMissle(pos: CGPoint) {
        //Calculate the duration for the missle
        let duration = rules.game.calculateDuration(origin: view!.center, dest: pos)
        
        //Create trail instance
        let emitter = SKEmitterNode(fileNamed: "MissleTrail.sks")
        emitter?.targetNode = scene
        
        // Create missle node
        let missle = SKShapeNode(circleOfRadius: 5)
        missle.strokeColor = SKColor.red
        missle.position = self.earth.position
        
        //Add physics body to missle
        missle.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        missle.physicsBody?.isDynamic = true
        missle.physicsBody?.categoryBitMask = Category.M
        missle.physicsBody?.contactTestBitMask = Category.A
        missle.physicsBody?.collisionBitMask = Category.N
        missle.physicsBody?.usesPreciseCollisionDetection = true
        
        // Attach trail to missle node
        if let emit = emitter {
            missle.addChild(emit)
        }
        // Add missle to the scene
        self.addChild(missle)
        
        // Add path and explosion to missle
        let move = SKAction.move(to: pos, duration: duration)
        let explode = addExplosion()
        missle.run(SKAction.sequence([move, explode]))
    }
    
    func addExplosion() -> SKAction {
        let remove = SKAction.removeFromParent()
        let fade = SKAction.fadeOut(withDuration: 0.25)
        let expand = SKAction.scale(to: 5, duration: 0.25)
        fade.timingMode = .easeOut
        expand.timingMode = .easeOut
        let explode = SKAction.group([expand, fade])
        let seq = SKAction.sequence([explode, remove])
        
        return seq
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            let loc = t.location(in: self)
            let nodes = self.nodes(at: loc)
            if(self.isPaused == false) {
                self.launchMissle(pos: loc)
            }
            else {
                for node in nodes {
                    if(node.name == "menuButton") {
                        menuButtonTapped()
                    }
                }
            }
        }
    }
    
    func earthHit(ast: SKLabelNode) {
        ast.removeFromParent()
        self.health = rules.game.earthHit(health: self.health, ast: ast)
        if(self.health > 0) {
            let ratio = CGFloat(self.health / 100)
            let pos = self.healthBar.position
            let rect = CGRect(x: 0, y: 0, width: ratio * self.healthBar.frame.width, height: self.healthBar.frame.height)
            self.healthBar.removeFromParent()
            self.healthBar = SKShapeNode(rect: rect)
            self.healthBar.fillColor = SKColor.green
            self.healthBar.position = pos
            self.addChild(self.healthBar)
        }
        else {
            self.isPaused = true
            self.removeAllChildren()
            displayGameOver()
        }
    }
    
    func displayGameOver() {
        
        //Testing UI menu button
        let button = UIButton()
        button.frame = CGRect(x: self.size.width/4, y: self.size.height - 60, width: self.size.width/2, height: self.size.height/10)
        button.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        button.setTitle("Submit Score", for: .normal)
        button.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.titleLabel?.font = UIFont(name: "Copperplate", size: 42)
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        self.view?.addSubview(button)
        
        // Score Label
        self.scoreLabel.text = String(self.score)
        self.scoreLabel.fontSize = 42
        self.scoreLabel.fontColor = SKColor.white
        let posx = view!.center.x
        let posy = view!.frame.height - 40
        self.scoreLabel.position = CGPoint(x: posx, y: posy)
        self.addChild(self.scoreLabel)
        
        //Name entry field
        self.nameField.frame = CGRect(x: self.size.width/4, y: CGFloat(60), width: self.size.width/2, height: self.size.height/10)
        self.nameField.placeholder = "Enter your name"
        self.nameField.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.nameField.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        self.nameField.font = UIFont(name: "Copperplate", size: 42)
        self.nameField.delegate = self
        self.view?.addSubview(self.nameField)
    }
    
    @objc func menuButtonTapped() {
        if let name = self.nameField.text  {
            let score = self.score
            ScoreTable.table.save(name: name, score: score)
            self.removeFromParent()
            let nav = self.view?.window?.rootViewController as! UINavigationController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let menu = storyboard.instantiateViewController(withIdentifier: "Menu") as! MenuViewController
            nav.viewControllers.removeAll()
            nav.addChildViewController(menu)
    
        }
    }
    
    func missleHit(missle: SKShapeNode, ast: SKLabelNode) {
        ast.removeFromParent()
        missle.removeAllActions()
        let explode = addExplosion()
        missle.run(explode)
        DispatchQueue.main.async {
            self.score = rules.game.asteroidDestroyed(score: self.score, ast: ast)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1: SKPhysicsBody
        var body2: SKPhysicsBody
        
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        //Detect if a missle has hit an asteroid
        if(body2.categoryBitMask & Category.M != 0) {
            if let missle = body2.node as? SKShapeNode,
                let ast = body1.node as? SKLabelNode {
                missleHit(missle: missle, ast: ast)
            }
        }
        
        //Detect if an asteroid has hit the earth
        if(body2.categoryBitMask & Category.A != 0) {
            if let ast = body2.node as? SKLabelNode {
                earthHit(ast: ast)
            }
        }
    }
    
    
}

extension GameScene: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
