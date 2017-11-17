//
//  DMViewController.swift
//  Twitbook
//
//  Created by aborse on 11/15/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class DMViewController: UIViewController {
    
    var users: [String] = []
    
    @IBOutlet weak var tableview: UITableView!

    @IBAction func newButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dmViewController = storyboard.instantiateViewController(withIdentifier: "NewDMViewController") as! NewDMViewController
        navigationController?.pushViewController(dmViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        loadUsers()
    }
    
    func loadUsers() {
        WebService.shared.getUsers() { (users) in
            self.users = users
            self.tableview.reloadData()
        }
    }
}

extension DMViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let the cell configure itself
        let cell = tableView.dequeueReusableCell(withIdentifier: "DMCell", for: indexPath) as! DMCell
        cell.configure(user: users[indexPath.item])
        return cell
    }
}

extension DMViewController: UITableViewDelegate {
    //When a user is selected from the list, launch a new browser view with only messages from that user
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let browserViewController = storyboard.instantiateViewController(withIdentifier: "BrowserViewController") as? BrowserViewController else {
            print("browser view failed")
            return
        }
        browserViewController.browsetype = 1
        browserViewController.user = users[indexPath.item]
        navigationController?.pushViewController(browserViewController, animated: true)
    }
}
