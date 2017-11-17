//
//  BrowserTextCell.swift
//  Twitbook
//
//  Created by aborse on 11/16/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class BrowserTextCell: UITableViewCell {
    
    var message: Message?
    var dmessage: DirectMessage?
    var messageType: Int = 0
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //If the likeLabel was previously hidden, show it again
        self.likeLabel.isHidden = false
    }
    
    func configure(message: Message) {
        self.userLabel.text = message.user
        self.txtLabel.text = message.text
        let likes = message.likedBy?.count ?? 0
        self.likeLabel.text = "Likes: \(likes)"
    }
    
    func configure(dmessage: DirectMessage) {
        self.messageType = 1
        self.dmessage = dmessage
        self.message = dmessage.message
        self.userLabel.text = dmessage.message.user
        self.txtLabel.text = dmessage.message.text
        //Direct Messages cannot be liked, so hide the like label
        self.likeLabel.isHidden = true
    }
    
}
