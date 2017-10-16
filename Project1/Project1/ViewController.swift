//
//  ViewController.swift
//  Project1
//
//  Created by aborse on 9/21/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var buttonDecrease: UIButton!
    @IBOutlet weak var buttonIncrease: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var colorBox: UIView!
    var currentValue = 180  // default value
    
    @IBAction func incrementPressed(_ sender: Any) {
        //currentValue's max is 360 because it is used as the value for the hue
        if(currentValue < 360) {
            
            currentValue = currentValue + 1
        }
            
        else {
            /* 
            Once currentValue reaches the max and the user tries to increment 
            again currentValue is wrapped around to the minimum value
            */
            currentValue = 0
        }
        
        updateScreen()
    }
    
    @IBAction func decrementPressed(_ sender: Any) {
        // currentValue's minimum is 0 because it is used as the value for hue
        if(currentValue > 0) {
            currentValue = currentValue - 1
        }
            
        else {
            /*
             Once the currentValue reaches the minimum and the user tries to
             decrement again currentValue is wrapped around to the max value
             */
            currentValue = 360
        }
        
        updateScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateScreen()
    }
    
    func updateScreen() {
        label.text = "\(currentValue)"
        /*
        The hue h must be of type CGFloat and be in the range 0.0 to 1.0
        so it is cast as the appropriate type and then divided by the max
        value
        */
        let h = CGFloat(currentValue)/360
        let newColor = UIColor(hue: h, saturation: 1, brightness: 0.5, alpha: 1)
        colorBox.backgroundColor = newColor
    }
}

