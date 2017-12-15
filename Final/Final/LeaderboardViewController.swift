//
//  LeaderboardViewController.swift
//  Final
//
//  Created by aborse on 12/5/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}

extension LeaderboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = ScoreTable.table.scores.count
        print(num)
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let score = ScoreTable.table.scores[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
        cell.configure(entry: score)
        return cell
    }
    
    
}
