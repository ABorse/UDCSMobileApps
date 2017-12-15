//
//  Asteroid.swift
//  Final
//
//  Created by aborse on 12/12/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit
import SpriteKit

struct asteroid {
    var size: CGFloat
    var sprite = SKLabelNode()
    
    init(size: CGFloat, start: CGPoint, dest: CGPoint, speed: Double) {
        self.size = size
        // Create the asteroid sprite 
        self.sprite.text = "🌕"
        self.sprite.fontSize = size
        self.sprite.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.sprite.position = start
        
        //Add path to asteroid
        let move = SKAction.move(to: dest, duration: speed)
        let moveDone = SKAction.removeFromParent()
        self.sprite.run(SKAction.sequence([move,
                                        moveDone]))
    }
}
