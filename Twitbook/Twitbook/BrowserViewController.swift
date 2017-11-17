//
//  BrowserViewController.swift
//  Twitbook
//
//  Created by aborse on 11/15/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {
    
    var dmessages: [DirectMessage] = []
    var messages: [Message] = []
    var user: String = ""
    var browsetype: Int = 0
    var index: IndexPath?
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func newButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //Check whether we are browsing general messages or direct messages
        if(self.browsetype == 0) {
            let newMessageViewController = storyboard.instantiateViewController(withIdentifier: "NewMessageViewController") as! NewMessageViewController
            navigationController?.pushViewController(newMessageViewController, animated: true)
        }
        else {
            let dmMessageViewController = storyboard.instantiateViewController(withIdentifier: "NewDMViewController") as! NewDMViewController
            if(self.user != "") {
                dmMessageViewController.to = self.user
            }
            navigationController?.pushViewController(dmMessageViewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadMessages()
    }
    
    func loadMessages() {
        if(self.browsetype == 0) {
            WebService.shared.getMessages() { (messages) in
                self.messages = messages.sorted {$0.date > $1.date}
                self.tableview.reloadData()
            }
        }
        else {
            //Reset lists so we don't append the same messages every reload
            self.dmessages = []
            self.messages = []
            WebService.shared.getDirectMessages() { (messages) in
                for message in messages {
                    if(message.from == self.user) {
                        self.dmessages.append(message)
                        self.messages.append(message.message)
                    }
                }
                self.dmessages.sort {$0.message.date > $1.message.date}
                self.messages.sort {$0.date > $1.date}
                self.tableview.reloadData()
            }
        }
        
    }
}

extension BrowserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Check message type
        if(browsetype == 0) {
            //Check cell type
            if(messages[indexPath.item].imgURL == nil) {
                //let the cell configure itself
                let cell = tableView.dequeueReusableCell(withIdentifier: "BrowserTextCell", for: indexPath) as! BrowserTextCell
                cell.configure(message: messages[indexPath.item])
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BrowserCell", for: indexPath) as! BrowserCell
                cell.configure(message: messages[indexPath.item])
                return cell
            }
        }
            
        
        else {
            //Check cell type
            if(dmessages[indexPath.item].message.imgURL == nil) {
                //let the cell configure itself
                let cell = tableView.dequeueReusableCell(withIdentifier: "BrowserTextCell", for: indexPath) as! BrowserTextCell
                cell.configure(dmessage: dmessages[indexPath.item])
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BrowserCell", for: indexPath) as! BrowserCell
                cell.configure(dmessage: dmessages[indexPath.item])
                return cell
            }
        }
            
    }
}

extension BrowserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Once a row is selected, pass the data in that cell to the message view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let messageViewController = storyboard.instantiateViewController(withIdentifier: "MessageViewController") as? MessageViewController else {return}
        messageViewController.message = self.messages[indexPath.item]
        messageViewController.messageType = self.browsetype
        if(self.browsetype != 0) {
            messageViewController.dmessage = self.dmessages[indexPath.item]
        }
        navigationController?.pushViewController(messageViewController, animated: true)
    }
}
