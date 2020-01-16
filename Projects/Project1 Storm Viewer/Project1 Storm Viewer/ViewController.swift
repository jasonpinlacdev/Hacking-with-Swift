//
//  ViewController.swift
//  Project1 Storm Viewer
//
//  Created by Jason Pinlac on 12/11/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var picturesDict = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Recommend", style: .plain, target: self, action: #selector(recommend))
        performSelector(inBackground: #selector(getPictures), with: nil)
    }
    
    @objc func getPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                picturesDict[item] = 0
            }
        }
        pictures.sort()
        load()
    }
    
    @objc func recommend() {
        let vc = UIActivityViewController(activityItems: ["Hey, you need to check out this new app called Storm Viewer. You can find it on the app store for free!"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        let pictureName = pictures[indexPath.row]
        cell.textLabel?.text = pictureName
        cell.imageView?.image = UIImage(named: pictureName)
        
        if let viewCount = picturesDict[pictureName] {
            cell.detailTextLabel?.text = "Number of views: \(viewCount)"
        } else {
            cell.detailTextLabel?.text = "Number of views: Unavailable"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            
            let pictureName = pictures[indexPath.row]
            if let viewCount = picturesDict[pictureName] {
                picturesDict.updateValue(viewCount + 1, forKey: pictureName)
            }
            save()
            tableView.reloadData()
            
            vc.selectedImage = pictures[indexPath.row]
            vc.title = "Image \(indexPath.row + 1) of \(pictures.count) -  \(vc.selectedImage!)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            let encoder = JSONEncoder()
            if let saveData = try? encoder.encode(self?.picturesDict) {
                let defaults = UserDefaults.standard
                defaults.set(saveData, forKey: "pictureViewCount")
                print("Data saved")
            } else {
                print("Failed to save")
            }
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "pictureViewCount") as? Data {
            let decoder = JSONDecoder()
            do {
                picturesDict = try decoder.decode([String: Int].self, from: savedData)
                print("Data loaded")
            } catch {
                print("Failed to load")
            }
        }
    }
    
    
}

