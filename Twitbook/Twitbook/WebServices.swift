//
//  WebServices.swift
//  Twitbook
//
//  Created by aborse on 11/14/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class WebService {
    
    static var shared = WebService()
    let logURL = URL(string: "https://obscure-crag-65480.herokuapp.com/login")
    let userURL = URL(string: "https://obscure-crag-65480.herokuapp.com/users")
    let messageURL = URL(string: "https://obscure-crag-65480.herokuapp.com/messages")
    let directURL = URL(string: "https://obscure-crag-65480.herokuapp.com/direct")
    let likeURL = URL(string: "https://obscure-crag-65480.herokuapp.com/like")
    
    var token: String = ""
    var user: String = ""
    var cache:[URL:UIImage] = [:]
    
    struct User: Codable {
        var name: String?
        var password: String?
    }
    
    struct TokenList: Codable {
        var token: String
    }
    
    struct Like: Codable {
        var likedMessageID: String
    }
    
    
    func Login(user: String, password: String, completion: @escaping (String) -> ()) {
        let log = User(name: user, password: password)
        guard let JSONlog = try? JSONEncoder().encode(log) else {return}
        
        var Lreq = URLRequest(url: logURL!)
        Lreq.httpBody = JSONlog
        Lreq.httpMethod = "POST"
        
        let Ltask = URLSession(configuration: .ephemeral).dataTask(with: Lreq) { (data, resp, err) in
            guard let toke = try? JSONDecoder().decode(TokenList.self, from: data!) else {return}
            self.token = toke.token
            self.user = user
            DispatchQueue.main.async {
                completion(self.token)
            }
        }
        Ltask.resume()
    }
    
    
    func getUsers(completion: @escaping ([String]) -> ()) {
        var Ureq = URLRequest(url: userURL!)
        Ureq.addValue(self.token, forHTTPHeaderField: "token")
        Ureq.httpMethod = "GET"
        
        let Utask = URLSession(configuration: .ephemeral).dataTask(with: Ureq) { (data, resp, err) in
            guard let list = try? JSONDecoder().decode(Array<String>.self, from: data!) else {return}
            DispatchQueue.main.async {
            completion(list)
            }
        }
        Utask.resume()
    }
    
    
    func getMessages(completion: @escaping ([Message]) -> ()) {
        var GMreq = URLRequest(url: messageURL!)
        GMreq.addValue(self.token, forHTTPHeaderField: "token")
        GMreq.httpMethod = "GET"
        
        let GMtask = URLSession(configuration: .ephemeral).dataTask(with: GMreq) { (data, resp, err) in
            guard let messageList = try? JSONDecoder().decode([Message].self, from: data!) else {return}
            DispatchQueue.main.async {
            completion(messageList)
            }
        }
        GMtask.resume()
    }
    
    func postMessage(message: Message, completion: @escaping (String) -> ()) {
        guard let encoded = try? JSONEncoder().encode(message) else {return}
        
        var PMreq = URLRequest(url: messageURL!)
        PMreq.addValue(self.token, forHTTPHeaderField: "token")
        PMreq.httpMethod = "POST"
        PMreq.httpBody = encoded
        
        let PMtask = URLSession(configuration: .ephemeral).dataTask(with: PMreq) { (data, resp, err) in
            guard let response = try? JSONDecoder().decode(Array<String>.self, from: data!) else {return}
            if(response[0] != "success") {
                print("Posting Failed")
            }
            DispatchQueue.main.async {
                completion(response[0])
            }
        }
        PMtask.resume()
    }
    
    func getDirectMessages(completion: @escaping ([DirectMessage]) -> ()) {
        var GDMreq = URLRequest(url: directURL!)
        GDMreq.addValue(self.token, forHTTPHeaderField: "token")
        GDMreq.httpMethod = "GET"
        
        let GDMtask = URLSession(configuration: .ephemeral).dataTask(with: GDMreq) { (data, resp, err) in
            guard let DMlist = try? JSONDecoder().decode([DirectMessage].self, from: data!) else {return}
            DispatchQueue.main.async {
            completion(DMlist)
            }
        }
        GDMtask.resume()
    }
    
    func postDirectMessage(message: DirectMessage, completion: @escaping (String) -> ()) {
        guard let encoded = try? JSONEncoder().encode(message) else {return}
        
        var PDMreq = URLRequest(url: directURL!)
        PDMreq.addValue(self.token, forHTTPHeaderField: "token")
        PDMreq.httpMethod = "POST"
        PDMreq.httpBody = encoded
        
        let PDMtask = URLSession(configuration: .ephemeral).dataTask(with: PDMreq) { (data, resp, err) in
            guard let response = try? JSONDecoder().decode(Array<String>.self, from: data!) else {return}
            if(response[0] != "success") {
                print("Posting DM failed")
            }
            DispatchQueue.main.async {
                completion(response[0])
            }
        }
        PDMtask.resume()
    }
    
    func likeMessage(messageID: String) {
        let message = Like(likedMessageID: messageID)
        guard let encoded = try? JSONEncoder().encode(message) else {return}
        
        var Lreq = URLRequest(url: likeURL!)
        Lreq.addValue(self.token, forHTTPHeaderField: "token")
        Lreq.httpMethod = "POST"
        Lreq.httpBody = encoded
        
        let Ltask = URLSession(configuration: .ephemeral).dataTask(with: Lreq) { (data, resp, err) in
            guard let response = try? JSONDecoder().decode(Array<String>.self, from: data!) else {return}
            if(response[0] != "success") {
                print("Posting Like failed")
            }
        }
        Ltask.resume()
    }
    
    func getImage(url: URL?, completion: @escaping (UIImage?, URL?) -> ()) {
        guard let url = url else {completion(nil, nil); print("fail: url fail"); return }
        // Check if we have downloaded this image before
        if let image = cache[url] {
            completion(image, url)
            return
        }
        // Download the image
        let task = URLSession(configuration: .ephemeral).dataTask(with: url) { (data, response, error) in
            guard data != nil else { completion(nil, nil); print("fail: data = nil"); return}
            if error != nil {completion(nil, nil); print("fail: error != nil"); return}
            let image = UIImage(data: data!)
            // Ensure that the data we received is not nil
            if let img = image {
                // Store the image in our cache
                self.cache[url] = img
            }
            // Update the UI on the main thread
            DispatchQueue.main.async{
                completion(image, url)
            }
        }
        task.resume()
    }
}
