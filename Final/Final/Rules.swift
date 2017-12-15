//
//  Rules.swift
//  Final
//
//  Created by aborse on 12/12/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit
import SpriteKit

class rules {

    static var game = rules()
    // Define gameplay constants
    let maxSize: UInt32 = 30
    let sizeOffset: UInt32 = 20
    let minSpeed: UInt32 = 7
    let speedOffset: UInt32 = 4
    let offset: CGFloat = 50
    let missleSpeed: CGFloat = 500
    
    func createAsteroid(w: CGFloat, h: CGFloat) -> asteroid {
        // Create a random size and speed for the asteroid
        // within the bounds set above
        let size = CGFloat(maxSize - arc4random_uniform(sizeOffset))
        let speed = Double(minSpeed - arc4random_uniform(speedOffset))
        
        // Create a random position off the screen
        // Determine which side the asteroid will come from
        let side = arc4random_uniform(4)
        
        // Create random offsets
        let xoff = CGFloat(arc4random_uniform(UInt32(w)))
        let yoff = CGFloat(arc4random_uniform(UInt32(h)))
        
        // Define default values 
        var xstart: CGFloat = 0
        var ystart: CGFloat = 0
        var xend: CGFloat = w
        var yend: CGFloat = h
        
        // Set position and destination values based on side
        switch side {
        case 0:
            xstart = 0 - self.offset
            ystart = yoff
            xend = w + self.offset
            yend = h - yoff

        case 1:
            xstart = xoff
            ystart = 0 - self.offset
            xend = w - xoff
            yend = h + self.offset

        case 2:
            xstart = w + self.offset
            ystart = yoff
            xend = 0 - self.offset
            yend = h - yoff

        case 3:
            xstart = xoff
            ystart = h + offset
            xend = w - xoff
            yend = 0 - offset

        default:
            xstart = w/2.0
            ystart = h/2.0
            xend = xstart
            yend = ystart
        }

        let pos = CGPoint(x: xstart, y: ystart)
        let dest = CGPoint(x: xend, y: yend)
        
        //Create and return the asteroid
        let ast = asteroid(size: size, start: pos, dest: dest, speed: speed )
        return ast
    }
    
    func calculateDuration(origin: CGPoint, dest: CGPoint) -> Double {
        // Calculate how long the missle's flight animation should last based on missle speed
        let dist = sqrt(pow((origin.y - dest.y),2) + pow((origin.x - dest.x),2))
        let dur = Double(dist / self.missleSpeed)
        return dur
    }
    
    func earthHit(health: Float, ast: SKLabelNode) -> Float {
        // Calculate remaining health
        let damage = Float(ast.fontSize)
        let remaining = health - damage
        
        return remaining
    }
    
    func asteroidDestroyed(score: Int32, ast: SKLabelNode) -> Int32 {
        // Calculate and update score
        let add = maxSize - UInt32(ast.fontSize)
        let updated = score + Int32(add)
        return updated
    }
    
    
    
}

