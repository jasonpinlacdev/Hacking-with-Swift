//
//  ViewController.swift
//  Project28 Secret Swift
//
//  Created by Jason Pinlac on 3/27/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var secret: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Nothing to see here..."
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        secret.addDoneButton(title: "Done", target: self, selector: #selector(keyboardDoneTapped(_:)))
        secret.isHidden = true
    }
    
    
   
    @IBAction func authenticateTapped(_ sender: UIButton) {
        unlockSecretMessage()
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        self.title = "Secret stuff!"
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard !secret.isHidden else { return }
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        self.title = "Nothing to see here..."
    }
    
    @objc func adjustForKeyboard(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue // size of keyboard relative to screen not view. It doesn't take into account rotation. Convert this to the viewEndFrame below
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        }
        if notification.name == UIResponder.keyboardWillChangeFrameNotification {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        secret.scrollIndicatorInsets = secret.contentInset
        secret.scrollRangeToVisible(secret.selectedRange)
    }
    
    @objc func keyboardDoneTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}


// MARK: - EXTENSIONS

extension UITextView {
    func addDoneButton(title: String, target: Any, selector: Selector) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolbar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolbar
    }
}

//extension ViewController { // This extension contains the code for managing adjustments for UITextView content insets when UITextView first reposonder keyboard appears. I eventutally want to add this UITextView functionality to my own framework JPCoreUtilities.
//    func addNotificationsForKeyboard() {
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }
//
//    @objc func adjustForKeyboard(_ notification: Notification) {
//        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//        let keyboardScreenEndFrame = keyboardValue.cgRectValue // size of keyboard relative to screen not view. It doesn't take into account rotation. Convert this to the viewEndFrame below
//        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
//        if notification.name == UIResponder.keyboardWillHideNotification {
//            secret.contentInset = .zero
//        }
//        if notification.name == UIResponder.keyboardWillChangeFrameNotification {
//            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
//        }
//        secret.scrollIndicatorInsets = secret.contentInset
//        secret.scrollRangeToVisible(secret.selectedRange)
//    }
//}



