//
//  Photo.swift
//  PhotoBrowser
//
//  Created by aborse on 10/12/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import Foundation

struct Photo {
    let title: String
    let url: URL!
    
    init(id: String, secret: String, server: String, farm: Int, title: String) {
        self.title = title
        // Build the url based on the parameters passed
        let urlString = "https://farm\(String(farm)).static.flickr.com/\(server)/\(id)_\(secret).jpg"
        self.url = URL(string: urlString)
    }
    
    init(dictionary: [String: Any]) {
        self.init(id: dictionary["id"]! as! String,
                  secret: dictionary["secret"] as! String,
                  server: dictionary["server"] as! String,
                  farm: dictionary["farm"] as! Int,
                  title: dictionary["title"] as! String)        
    }
}
