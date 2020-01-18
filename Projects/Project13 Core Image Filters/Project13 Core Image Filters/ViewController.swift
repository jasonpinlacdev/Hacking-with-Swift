//
//  ViewController.swift
//  Project13 Core Image Filters
//
//  Created by Jason Pinlac on 1/17/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scaleSlider: UISlider!
    @IBOutlet var radiusSlider: UISlider!
    @IBOutlet var intensitySlider: UISlider!
    
    @IBOutlet var scaleLabel: UILabel!
    @IBOutlet var radiusLabel: UILabel!
    @IBOutlet var intensityLabel: UILabel!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    var currentImage: UIImage!
    var currentFilter: CIFilter!
    var context: CIContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        disableSliders()
        
        title = "Core Image Filters"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importImage))
        filterButton.layer.borderColor = UIColor.systemBlue.cgColor
        filterButton.layer.borderWidth = 1
        filterButton.layer.cornerRadius = 10
        filterButton.clipsToBounds = true
        
        saveButton.layer.borderColor = UIColor.systemBlue.cgColor
        saveButton.layer.borderWidth = 1
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
        
    }
    
    @objc func importImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else { return }
        currentImage = image
        
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowRadius = 10
        imageView.clipsToBounds = false
        
        // Start with a CIImage
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        disableSliders()
        let keys = currentFilter.inputKeys
        if keys.contains(kCIInputIntensityKey) {
            intensityLabel.isEnabled = true
            intensitySlider.isEnabled = true
            currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey)
        }
        if keys.contains(kCIInputRadiusKey) {
            radiusLabel.isEnabled = true
            radiusSlider.isEnabled = true
            currentFilter.setValue(radiusSlider.value * 400, forKey: kCIInputRadiusKey)
        }
        if keys.contains(kCIInputScaleKey) {
            scaleLabel.isEnabled = true
            scaleSlider.isEnabled = true
            currentFilter.setValue((scaleSlider.value + 0.001) * 10, forKey: kCIInputScaleKey)
        }
        if keys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        // transform CIImage to a CGImage and then to a UIImage
        guard let outputImage = currentFilter.outputImage else { return }
        
        // do processing here
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            imageView.image = uiImage
        }
    }
    
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let popoverController = ac.popoverPresentationController
        popoverController?.sourceView = sender
        popoverController?.sourceRect = sender.bounds
        
        present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        currentFilter = CIFilter(name: action.title!)
        filterButton.setTitle(action.title!, for: .normal)
        
        // Start with a CIImage
        guard currentImage != nil else { return }
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    @IBAction func scaleChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func radiusChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
        
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Select an image", message: "You must select an image before saving to photos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
        }
    }
    
    func disableSliders() {
        scaleSlider.isEnabled = false
        scaleLabel.isEnabled = false
        intensitySlider.isEnabled = false
        intensityLabel.isEnabled = false
        radiusSlider.isEnabled = false
        radiusLabel.isEnabled = false
    }
}

