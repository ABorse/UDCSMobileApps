//
//  MessageViewController.swift
//  Twitbook
//
//  Created by aborse on 11/15/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    var messageType: Int = 0
    var dmessage: DirectMessage?
    var message: Message?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func replyButtonTapped(_ sender: Any) {
        guard let id = message?.id else {return}
        var user: String = ""
        if(messageType != 0) {
            user = dmessage!.from
        }
        //Transition to new message screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newMessageViewController = storyboard.instantiateViewController(withIdentifier: "NewMessageViewController") as! NewMessageViewController
        newMessageViewController.reply = id
        newMessageViewController.to = user
        newMessageViewController.messageType = self.messageType
        navigationController?.pushViewController(newMessageViewController, animated: true)
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        guard let id = message?.id else {return}
        WebService.shared.likeMessage(messageID: id)
        updateLikes()
    }
    
    func updateLikes() {
        let user = WebService.shared.user
        //check if the user has already liked this message
        var liked: Bool = false
        guard let likers = self.message?.likedBy else {return}
        for person in likers {
            if(person == user) {
                liked = true
                break
            }
        }
        if(liked == false) {
            let likes = likers.count + 1
            self.likeLabel.text = "Likes: \(likes)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userLabel.text = message?.user
        self.txtLabel.text = message?.text
        if(messageType == 0) {
            let likes = message?.likedBy?.count ?? 0
            self.likeLabel.text = "Likes: \(likes)"
        }
        else {
            //Direct Messages cannot be liked, so hide the like label and like button
            likeLabel.isHidden = true
            likeButton.isHidden = true
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_us")
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        let date = formatter.string(from: self.message!.date)
        if(date != "") {
            self.dateLabel.text = date
        }
        if(message?.imgURL != nil) {
            WebService.shared.getImage(url: message?.imgURL) { (image, url) in
                self.imgView.image = image
            }
        }
    }
}
