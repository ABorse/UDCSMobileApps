//
//  CollectionViewController.swift
//  PhotoBrowser
//
//  Created by aborse on 10/12/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    var photos: [Photo] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let photoViewController = segue.destination as! PhotoViewController
            let browserCell = sender as! BrowserCell
            photoViewController.photo = browserCell.photo
        }
    }
    
    func fetchData() {
        let url = URL(string: "https://api.flickr.com/services/rest/?format=json&sort=random&method=flickr.photos.search&tags=daffodil&tag_mode=all&api_key=0e2b6aaf8a6901c264acb91f151a3350&nojsoncallback=1")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, err) in
            let data = data!
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            // To get to the array of photo dictionaries that we need to build our Photo array, we must go to the photo array in the photos dictionary in the json dictionary
            let dict = json as! [String: Any]
            let page = dict["photos"] as! [String: Any]
            let array = page["photo"] as! [[String: Any]]
            self.photos = array.map { Photo(dictionary: $0) }
            // Once the fetch is done, update the collectionView data source on the main thread
            DispatchQueue.main.async{
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a cell and let it configure itself
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowserCell", for: indexPath) as! BrowserCell
        cell.configure(photo: photos[indexPath.item])
        return cell
    }
    
    
}
extension CollectionViewController: UICollectionViewDelegate {
    // Once a cell is selected, show the detailed photo viewer page
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let photoViewController = storyboard.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        photoViewController.photo = photos[indexPath.item]
        present(photoViewController, animated: true, completion: nil)
    }
}
