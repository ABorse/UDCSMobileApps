//
//  LeaderBoardCell.swift
//  Final
//
//  Created by aborse on 12/14/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit
import CoreData

class LeaderboardCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func configure(entry: NSManagedObject) {
        nameLabel.text = entry.value(forKey: "name") as? String
        let score = entry.value(forKey: "score") as? Int32
        scoreLabel.text = "\(score!)"
    }
}
