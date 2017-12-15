//
//  GameViewController.swift
//  Final
//
//  Created by aborse on 12/5/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        if let view = self.view as! SKView? {
            // Create the GameScene'
            let scene = GameScene(size: view.bounds.size)
            // Set the scale mode for the window
            scene.scaleMode = .resizeFill
                
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            setBackground()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setBackground() {
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        // Place stars in the backdrop in random locations
        var i = 0
        while(i < 50) {
            let star = CATextLayer()
            star.string = "✨"
            star.fontSize = 8
            star.frame = CGRect(x: 0.0, y: 0.0, width: 12, height: 12)
            star.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(view.frame.width))), y: CGFloat(arc4random_uniform(UInt32(view.frame.height))))
            star.alignmentMode = kCAAlignmentCenter
            
            // Make the background stars "twinkle"
            let fade = CABasicAnimation(keyPath: "opacity")
            fade.beginTime = CACurrentMediaTime() - Double(arc4random())
            fade.fromValue = 0.6
            fade.toValue = 0.4
            fade.repeatCount = HUGE
            fade.autoreverses = true
            fade.duration = 1.5
            star.add(fade, forKey: "opacity")
            
            self.view.layer.addSublayer(star)

            i += 1
        }
    }
}

extension GameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
