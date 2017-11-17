//
//  BrowserCell.swift
//  Twitbook
//
//  Created by aborse on 11/16/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class BrowserCell: UITableViewCell {
    
    var message: Message?
    var dmessage: DirectMessage?
    var messageType: Int = 0
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = nil
        //If the likeLabel was previously hidden, show it again
        self.likeLabel.isHidden = false
    }
    
    func loadImage(message: Message) {
        WebService.shared.getImage(url: message.imgURL) { (image, url) in
            // Check if the image we have is still the image needed for the cell by checking the url
            if url == self.message?.imgURL {
                self.imgView.image = image
            }
        }
    }
    
    func configure(message: Message) {
        self.message = message
        self.userLabel.text = message.user
        self.txtLabel.text = message.text
        let likes = message.likedBy?.count ?? 0
        self.likeLabel.text = "Likes: \(likes)"
        loadImage(message: message)
    }
    
    func configure(dmessage: DirectMessage) {
        self.messageType = 1
        self.dmessage = dmessage
        self.message = dmessage.message
        self.userLabel.text = dmessage.message.user
        self.txtLabel.text = dmessage.message.text
        //Direct Messages cannot be liked, so hide the like label
        self.likeLabel.isHidden = true
        loadImage(message: dmessage.message)
        
    }
}
