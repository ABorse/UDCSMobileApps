//
//  NewDMViewController.swift
//  Twitbook
//
//  Created by aborse on 11/16/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class NewDMViewController: UIViewController {
    
    var user: String = ""
    var to: String = ""
    
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var imgField: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = WebService.shared.user
        if(self.to != "") {
            self.toField.text = self.to
        }
    }
    
    @IBAction func imgFieldFilled(_ sender: Any) {
        //Once the imgField is filled, load the image to the imgView
        guard let url = URL(string: imgField.text!) else {return}
        WebService.shared.getImage(url: url) { (image, url) in
            if(image != nil) {
                self.imgView.image = image
            }
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let to = toField.text else {return}
        guard let text = textView.text else {return}
        let imgURL = URL(string: imgField.text!) ?? nil
        
        let message = Message(user: self.user, text: text, date: Date(), imgURL: imgURL, id: nil, replyTo: nil, likedBy: nil)
        let dm = DirectMessage(to: to, from: self.user, message: message)
        
        WebService.shared.postDirectMessage(message: dm) { (done) in
            if(done == "success") {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
