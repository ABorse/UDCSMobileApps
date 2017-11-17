//
//  DMCell.swift
//  Twitbook
//
//  Created by aborse on 11/16/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class DMCell: UITableViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    
    func configure(user: String) {
        self.userLabel.text = user
    }
}

