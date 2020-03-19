//
//  ViewController.swift
//  Milestone9 Meme Generator
//
//  Created by Jason Pinlac on 3/18/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImage: UIImage?
    lazy var renderer = UIGraphicsImageRenderer(size: CGSize(width: imageView.frame.size.width, height: imageView.frame.size.height))
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    
    @IBOutlet var topTextSizeSlider: UISlider!
    @IBOutlet var bottomTextSizeSlider: UISlider!
    
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Meme Generator"
        topTextField.isEnabled = false
        bottomTextField.isEnabled = false
        topTextSizeSlider.isEnabled = false
        bottomTextSizeSlider.isEnabled = false
        
        topTextField.delegate = self
        topTextField.returnKeyType = .done
        bottomTextField.delegate = self
        bottomTextField.returnKeyType = .done
        
        saveButton.backgroundColor = UIColor.systemBlue
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.layer.cornerRadius = 5
        saveButton.clipsToBounds = true
        
        // notification center for keyboard adjustment
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil);
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        // targets for components
        topTextField.addTarget(self, action: #selector(topTextFieldValueChanged), for: .editingChanged)
        bottomTextField.addTarget(self, action: #selector(bottomTextFieldValueChanged), for: .editingChanged)
        topTextSizeSlider.addTarget(self, action: #selector(topSliderValueChanged), for: .valueChanged)
        bottomTextSizeSlider.addTarget(self, action: #selector(bottomSliderValueChanged), for: .valueChanged)
        saveButton.addTarget(self, action: #selector(saveToPhotos), for: .touchUpInside)
        
        // bar button items for image picker and sharing
        let addPhotoButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPhoto))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItems = [addPhotoButton, shareButton]
        
    }
    
    
    @objc func saveToPhotos() {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Can't Save", message: "No image has been selected.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Save Successful", message: "Your generated meme has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    @objc func share() {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Can't Share", message: "No image has been selected.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
            return
        }
        let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    
    func renderImage() {
        guard let originalImage = selectedImage else { return }
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: originalImage.size.width, height: originalImage.size.height))
        let renderedImage = renderer.image { ctx in
            
            originalImage.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.center
            
            // top text
            if let topText = topTextField.text?.uppercased() {
                let topAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "AvenirNextCondensed-Heavy", size: CGFloat(topTextSizeSlider!.value))!,
                    .foregroundColor: UIColor.white,
                    .strokeWidth: -5,
                    .strokeColor: UIColor.black,
                    .paragraphStyle: paragraphStyle,
                ]
                let attributedTopText = NSAttributedString(string: topText, attributes: topAttributes)
                attributedTopText.draw(at: CGPoint(x: 20, y: -20))
            }
            
            // bottom text
            if let bottomText = bottomTextField.text?.uppercased() {
                let bottomAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "AvenirNextCondensed-Heavy", size: CGFloat(bottomTextSizeSlider!.value))!,
                    .foregroundColor: UIColor.white,
                    .strokeWidth: -5,
                    .strokeColor: UIColor.black,
                    .paragraphStyle: paragraphStyle,
                ]
                let attributedBottomText = NSAttributedString(string: bottomText, attributes: bottomAttributes)
                let offSetValue = bottomTextSizeSlider.value
                attributedBottomText.draw(at: CGPoint(x: 20, y: originalImage.size.height - 20 - CGFloat(offSetValue)))
            }
            
        }
        imageView.image = renderedImage
    }
    
    @objc func topTextFieldValueChanged(_ sender: UITextField) {
        renderImage()
    }
    
    @objc func bottomTextFieldValueChanged(_ sender: UITextField) {
        renderImage()
    }
    
    @objc func topSliderValueChanged(_ sender: UISlider) {
        renderImage()
    }
    
    @objc func bottomSliderValueChanged(_ sender: UISlider) {
        renderImage()
    }
    
    
    @objc func importPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        selectedImage = image
        picker.dismiss(animated: true)
        renderImage()
        topTextField.isEnabled = true
        bottomTextField.isEnabled = true
        topTextSizeSlider.isEnabled = true
        bottomTextSizeSlider.isEnabled = true
    }
    
    
    @objc func adjustKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            let keyboardHeight = keyboardValue.cgRectValue.height
            self.view.frame.origin.y = -keyboardHeight // move view above keyboard height
        }
        else if notification.name == UIResponder.keyboardWillHideNotification {
            self.view.frame.origin.y = 0 // move view to original position
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

