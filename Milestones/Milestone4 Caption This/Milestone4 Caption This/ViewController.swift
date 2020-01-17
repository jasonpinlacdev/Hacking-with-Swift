//
//  ViewController.swift
//  Milestone4 Caption This
//
//  Created by Jason Pinlac on 1/15/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Caption this!"
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraTapped))
        }
        load()
    }
    
    @objc func cameraTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let pictureData = try? encoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(pictureData, forKey: "pictures")
        } else{
            print("Save failed")
        }
    }
    
    func load() {
        // read from user defaults as data
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: "pictures") as? Data {
            let decoder = JSONDecoder()
            do {
                pictures = try decoder.decode([Picture].self, from: data)
            } catch {
                print("Load failed")
            }
        }
    }
    
    func getApplicationDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let picture = pictures[indexPath.row]
        cell.textLabel?.text = picture.quote
        cell.imageView?.image = UIImage(contentsOfFile: getApplicationDocumentsDirectory().appendingPathComponent(picture.imageName).path)
        cell.imageView?.layer.borderWidth = 2
        cell.imageView?.layer.borderColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController else { return }
        vc.selectedPicture = pictures[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getApplicationDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 1.0) {
            try? jpegData.write(to: imagePath)
        }
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Quote your photo", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default) {
            [weak ac, weak self] _ in
            let text = ac?.textFields?[0].text ?? "Unavailable"
            let quote = "\"\(text)\""
            let picture = Picture(imageName: imageName, quote: quote)
            self?.pictures.append(picture)
            self?.save()
            self?.tableView.reloadData()
        })
        present(ac, animated: true)
    }
}

