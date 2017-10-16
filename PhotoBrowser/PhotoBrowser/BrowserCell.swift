//
//  BrowserCell.swift
//  PhotoBrowser
//
//  Created by aborse on 10/12/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class BrowserCell: UICollectionViewCell {
    
    var photo: Photo?

    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(photo: Photo) {
        self.photo = photo
        ImageService.shared.imageForURL(url: photo.url) { (image, url) in
            // Check if the image we have is still the image needed for the cell by checking the url
            if url == self.photo?.url {
                self.imageView.image = image
            }
        }
    }
}
