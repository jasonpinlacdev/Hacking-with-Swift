//
//  ViewController.swift
//  Project10 Storm Viewer UICollectionView
//
//  Created by Jason Pinlac on 1/8/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var photos = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Storm Viewer Collection"
        getPhotoNames()
    }
    
    func getPhotoNames() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            for item in items {
                if item.hasPrefix("nssl") {
                    self?.photos.append(item)
                }
            }
            self?.photos.sort()
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController else { return }
        let photoName = photos[indexPath.item]
        vc.selectedImage = photoName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Storm", for: indexPath) as? StormCell else { fatalError("Unable to dequeue Storm cell") }
        cell.imageView.image = UIImage(named: photos[indexPath.item])
        cell.nameLabel.text = photos[indexPath.item]
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 3
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        cell.imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    


}

