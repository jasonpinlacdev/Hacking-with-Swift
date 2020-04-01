//
//  ViewController.swift
//  Project10 Names to Faces
//
//  Created by Jason Pinlac on 1/14/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UICollectionViewController {
    
    var people = [Person]()
    
    lazy var authenticateButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Authenticate", style: .plain, target: self, action: #selector(authenticateTapped))
        button.isEnabled = true
        return button
    }()
    
    lazy var addFromPhotosButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        button.isEnabled = false
        return button
    }()
    
    lazy var addFromCameraButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addNewPersonByCamera))
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Locked"
        
        NotificationCenter.default.addObserver(self, selector: #selector(lockApp), name: UIApplication.willResignActiveNotification, object: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            navigationItem.rightBarButtonItems = [addFromPhotosButton, addFromCameraButton]
        } else {
            navigationItem.rightBarButtonItem = addFromPhotosButton
        }
        
        navigationItem.leftBarButtonItem = authenticateButton
    }
    
    @objc func lockApp() {
        title = "Locked"
        authenticateButton.isEnabled = true
        addFromCameraButton.isEnabled = false
        addFromPhotosButton.isEnabled = false
        people = []
        self.collectionView.reloadData()
    }
    
    @objc func authenticateTapped() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Identify yourself with touchID"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] (success, error) in
                // biometric identification repsonse is might not be on the main thread and we are doing UI work here so use GCD
                DispatchQueue.main.async {
                    if success {
                        // authentication might not happen on the main thread so use GCD
                        self?.loadPeople()
                        self?.authenticateButton.isEnabled = false
                        self?.addFromCameraButton.isEnabled = true
                        self?.addFromPhotosButton.isEnabled = true
                        self?.title = "Unlocked"
                    } else {
                        // alert failed to authenticate using biometrics
                        let alertController = UIAlertController(title: "Failed to Authenticate", message: error?.localizedDescription, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                        self?.present(alertController, animated: true)
                    }
                }
            }
        } else {
            // alert device does not have biometry authenticating capabilities
            let alertController = UIAlertController(title: "Biometry Scanning Unavailble", message: "You're device is not configured for biometric authentication.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(alertController, animated: true)
        }
    }
    
    func renamePerson(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] _ in
            guard let newName = alertController?.textFields?[0].text else { return }
            self?.people[indexPath.item].name = newName
            self?.savePeople()
            self?.collectionView.reloadData()
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    func deletePerson(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Are you sure?", message: "Once deleted it will be gone forever.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.savePeople()
            self?.collectionView.reloadData()
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    
    func savePeople() {
        if let data = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(data, forKey: "people")
        } else {
            print("Failed to save people data.")
        }
    }
    
    
    func loadPeople() {
        guard let data = UserDefaults.standard.data(forKey: "people") else { return }
        do {
            people = try JSONDecoder().decode([Person].self, from: data)
            self.collectionView.reloadData()
        } catch {
            print("Failed to load people data.")
        }
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
        let alertController = UIAlertController(title: "What would you like to do?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            self?.renamePerson(at: indexPath)
        })
        alertController.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            self?.deletePerson(at: indexPath)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
}


// MARK: - EXTENSIONS

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            do {
                try jpegData.write(to: imagePath)
            } catch {
                print("Failed to write data contents of the picked image: \(imageName) to documentDirectory path: \(imagePath).")
            }
        }
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        savePeople()
        collectionView.reloadData()
        dismiss(animated: true)
    }
}
