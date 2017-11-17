//
//  LoginViewController.swift
//  Twitbook
//
//  Created by aborse on 11/14/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    


    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let user = username.text else {return}
        guard let pass = password.text else {return}
        WebService.shared.Login(user: user, password: pass) { (token) in
            if(token != "") {
                //A valid token was received so save username and password
                let defaults = UserDefaults.standard
                defaults.set(user, forKey: "user")
                defaults.set(pass, forKey: "password")
                //Proceed to app
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the background
        setBackground()
        //Load user defaults
        let defaults = UserDefaults.standard
        guard let user = defaults.string(forKey: "user") else {return}
        guard let pass = defaults.string(forKey: "password") else {return}
        self.username.text = user
        self.password.text = pass
        
    }
    func setBackground() {
        //set the view color and animate the logo
        self.backgroundView.backgroundColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        
        let layer = CATextLayer()
        layer.string = "🐤📔"
        layer.fontSize = 75
        layer.frame = CGRect(x: 100, y: self.backgroundView.frame.height - 200, width: 200, height: 100)
        layer.alignmentMode = kCAAlignmentCenter
        self.backgroundView.layer.addSublayer(layer)
        
        let layer2 = CATextLayer()
        layer2.string = "🐤📔"
        layer2.fontSize = 75
        layer2.frame = CGRect(x: 100, y: 100, width: 200, height: 100)
        layer2.alignmentMode = kCAAlignmentCenter
        self.backgroundView.layer.addSublayer(layer2)
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.duration = 3.0
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        animation.fromValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat.pi/8, 0, 0, 1))
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(-CGFloat.pi/8, 0, 0, 1))
        layer.add(animation, forKey: nil)
        animation.beginTime = CACurrentMediaTime() - 5.0
        layer2.add(animation, forKey: nil)
        
        let pos = CABasicAnimation(keyPath: "position.x")
        pos.fromValue = self.backgroundView.frame.width + 100
        pos.toValue = -100
        pos.duration = 10.0
        pos.repeatCount = Float.infinity
        layer.add(pos, forKey: nil)
        pos.beginTime = CACurrentMediaTime() - 5.0
        layer2.add(pos, forKey: nil)
        
    }
    
    
}
