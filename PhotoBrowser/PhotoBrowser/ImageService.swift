//
//  ImageService.swift
//  PhotoBrowser
//
//  Created by aborse on 10/13/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class ImageService  {
    
    static var shared = ImageService()
    
    var cache:[URL:UIImage] = [:]
    
    func imageForURL(url: URL?, completion: @escaping (UIImage?, URL?) -> ()) {
        guard let url = url else {completion(nil, nil); print("fail: url fail"); return }
        // Check if we have downloaded this image before
        if let image = cache[url] {
            completion(image, url)
            return
        }
        // Download the image
        let task = URLSession(configuration: .ephemeral).dataTask(with: url)
        { (data, response, error) in
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
