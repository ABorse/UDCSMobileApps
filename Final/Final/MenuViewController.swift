//
//  MenuViewController.swift
//  Final
//
//  Created by aborse on 12/5/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        ScoreTable.table.get()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
//    @IBAction func playButtonTapped(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let gamevc = storyboard.instantiateViewController(withIdentifier: "Game") as! GameViewController
//        navigationController?.pushViewController(gamevc, animated: true)
//    }
    
    @IBAction func leaderButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let leadervc = storyboard.instantiateViewController(withIdentifier: "Leaderboard") as! LeaderboardViewController
        navigationController?.pushViewController(leadervc, animated: true)
    }
    
    func setBackground() {
        var i = 0
        while(i < 50) {
            let star = CATextLayer()
            star.string = "✨"
            star.fontSize = 8
            star.frame = CGRect(x: 0.0, y: 0.0, width: 12, height: 12)
            star.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(view.frame.width))), y: CGFloat(arc4random_uniform(UInt32(view.frame.height))))
            star.alignmentMode = kCAAlignmentCenter
            
            let fade = CABasicAnimation(keyPath: "opacity")
            fade.beginTime = CACurrentMediaTime() - Double(arc4random())
            fade.fromValue = 0.6
            fade.toValue = 0.4
            fade.repeatCount = HUGE
            fade.autoreverses = true
            fade.duration = 1.5
            star.add(fade, forKey: "opacity")
            
            view.layer.addSublayer(star)
            
            
            i += 1
        }
        
        let earth = CATextLayer()
        earth.string = "🌎"
        earth.fontSize = 75
        earth.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        earth.frame = CGRect(x: 0.0, y: 0.0, width: 100, height: 100)
        earth.position = view.center
        earth.alignmentMode = kCAAlignmentCenter
        view.layer.addSublayer(earth)
    }
    
}


