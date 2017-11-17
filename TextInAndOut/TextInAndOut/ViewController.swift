//
//  ViewController.swift
//  TextInAndOut
//
//  Created by aborse on 10/24/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loremIpsumView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loremIpsumView.delegate = self
        if let font = UIFont(name: "Chalkduster", size: 20.0) {
            loremIpsumView.font = UIFontMetrics.default.scaledFont(for: font)
            
            }
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

