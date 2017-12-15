//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport

struct board: Codable {
    var list: [String: String]
}

var list: [String: String] = [:]

func postList(list: [String: String]) {
    list["Test"] = "500"
    
    
    var req2 = URLRequest(url: url!)
    req.httpBody = list
    req.httpMethod = "POST"
}

PlaygroundPage.current.needsIndefiniteExecution = true

let url = URL(string: "https://raw.github.com/ABorse/UDCSMobileApps/master/Final/leaderboard.txt")
let temp = URL(string: "https://www.apple.com")

var req = URLRequest(url: url!)
req.httpMethod = "GET"

let task = URLSession(configuration: .ephemeral).dataTask(with: req) { (d, r, e) in
    guard let list1 = try? JSONDecoder().decode(board.self, from: d!) else {
        print("failed")
        return
    }
    print(list1)
    list = list1.list
    postList(list: list)
}
task.resume()


