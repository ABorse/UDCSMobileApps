//
//  PhotoViewController.swift
//  PhotoBrowser
//
//  Created by aborse on 10/12/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

var photo: Photo?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = photo?.title
        ImageService.shared.imageForURL(url: photo?.url) { (image, url) in
            self.imageView.image = image
        }
        
    }
}
