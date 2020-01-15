//
//  ViewController.swift
//  Project10 Names to Faces
//
//  Created by Jason Pinlac on 1/14/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addNewPersonByCamera))
            navigationItem.leftBarButtonItems = [addButton, cameraButton]
        } else {
            navigationItem.leftBarButtonItem = addButton
        }
        
        let defaults = UserDefaults.standard
        if let savedPeopleData = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeopleData) as? [Person] {
                people = decodedPeople
            }
        }
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func addNewPersonByCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         guard let image = info[.editedImage] as? UIImage else { return }
         let imageName = UUID().uuidString
         let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
         if let jpegData = image.jpegData(compressionQuality: 0.8)  {
             try? jpegData.write(to: imagePath)
         }
         let person = Person(name: "Unknown", image: imageName)
         people.append(person)
         save()
         collectionView.reloadData()
         dismiss(animated: true)
     }
     
     // function to get applications document directory
     func getDocumentsDirectory() -> URL {
         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         return paths[0]
     }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue a PersonCell")
        }
        let person = people[indexPath.item]
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.layer.cornerRadius = 3
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.nameLabel.text = person.name
        cell.layer.cornerRadius = 7
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return people.count
       }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "What would you like to do?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Rename", style: .default) {
            [weak self] _ in
            self?.renamePerson(at: indexPath)
        })
        ac.addAction(UIAlertAction(title: "Delete", style: .default) {
            [weak self] _ in
            self?.deletePerson(at: indexPath)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func renamePerson(at indexPath: IndexPath) {
        let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            self?.people[indexPath.item].name = newName
            self?.save()
            self?.collectionView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func deletePerson(at indexPath: IndexPath) {
        let ac = UIAlertController(title: "Are you sure?", message: "Once deleted it will be gone forever.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default) {
            [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.save()
            self?.collectionView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func save() {
        // take the object graph and turn it into a data object. then set the data object to UserDefaults
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }
}
