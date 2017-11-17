//
//  NewMessageViewController.swift
//  Twitbook
//
//  Created by aborse on 11/16/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class NewMessageViewController: UIViewController {
    
    var reply: String?
    var messageType: Int = 0
    var user: String = ""
    var to: String?
    
    
    @IBOutlet weak var imgField: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func imgFieldFilled(_ sender: Any) {
        guard let url = URL(string: imgField.text!) else {return}
        WebService.shared.getImage(url: url) { (image, url) in
            if(image != nil) {
                self.imgView.image = image
            }
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let text = textView.text else {return}
        let imgURL = URL(string: imgField.text!) ?? nil
        let replyTo = self.reply ?? nil
        
        let message = Message(user: self.user, text: text, date: Date(), imgURL: imgURL, id: nil, replyTo: replyTo, likedBy: nil)
        
        if(messageType != 0) {
            let dm = DirectMessage(to: self.to!, from: self.user, message: message)
            WebService.shared.postDirectMessage(message: dm) { (done) in
                if(done == "success") {
                    // Return to message view
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else {
            WebService.shared.postMessage(message: message) { (done) in
                if(done == "success") {
                    //Return to message view
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = WebService.shared.user
    }
    
}
