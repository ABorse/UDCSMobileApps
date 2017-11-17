//
//  LaunchViewController.swift
//  Twitbook
//
//  Created by aborse on 11/17/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the background
        setBackground()
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
    }
}
