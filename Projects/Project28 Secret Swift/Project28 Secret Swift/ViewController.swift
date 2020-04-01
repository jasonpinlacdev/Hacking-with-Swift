//
//  ViewController.swift
//  Project28 Secret Swift
//
//  Created by Jason Pinlac on 3/27/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet var secret: UITextView!
    
    // challenge 1 add the done button on nav controller for view controller that saves and locks the secrets text view
    lazy var lockButton: UIBarButtonItem = { () -> UIBarButtonItem in
        let button = UIBarButtonItem(title: "Lock", style: .plain, target: self, action: #selector(lockSecretMessage))
        button.isEnabled = false
        return button
    }()
    
    // challenge 2 add a password system. When authenticated user can set a password that can be used when locked out.
    // check if there is already a saved password from KeyChainWrapper. if not unlock button is disabled on start.
    lazy var unlockButton: UIBarButtonItem = { () -> UIBarButtonItem in
        let button = UIBarButtonItem(title: "Unlock", style: .plain, target: self, action: #selector(unlockWithPassword))
        return button
    }()
    
    lazy var setPasswordButton: UIBarButtonItem = {
        let button =  UIBarButtonItem(title: "Set Password", style: .plain, target: self, action: #selector(setPassword))
        button.isEnabled = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Locked"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        secret.addDoneButton(title: "Done", target: self, selector: #selector(keyboardDoneTapped(_:)))
        secret.isHidden = true
        
        let password: String? = KeychainWrapper.standard.string(forKey: "password")
        if password == nil {
            unlockButton.isEnabled = false
        }

        navigationItem.leftBarButtonItem = setPasswordButton
        navigationItem.rightBarButtonItems = [lockButton, unlockButton]
    }
    
    @IBAction func authenticateTapped(_ sender: UIButton) {
        // perform biometric evaluation and determing whether or not to unlock the secret message text field
        let context = LAContext()
        
        // Swift's Objective-C form of errors is used IE NSError because LocalAuthentication framework is an Objective-C API not Swift API
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            
            let reason = "Identify yourself with your TouchID" // this reason here is only showed for the touchID. If you want a reason for faceID shown you must ad it to the info.plist Privacy - Face ID Usage Description
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] (success, error) in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        // error biometrics failed to recognize
                        let ac = UIAlertController(title: "Authentication Failed", message: error?.localizedDescription, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // device is not capable of using biometrics IE touchID or faceID or it isn't enabled on the device
            let alertContoller = UIAlertController(title: "Biometry Unavailable", message: "You're device is not configured for biometric authentication.", preferredStyle: .alert)
            alertContoller.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(alertContoller, animated: true)
        }
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        
        setPasswordButton.isEnabled = true
        unlockButton.isEnabled = false
        lockButton.isEnabled = true
        self.title = "Unlocked"
    }
    
    @objc func saveSecretMessage() {
        guard !secret.isHidden else { return }
        self.title = "Locked"
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        
        lockButton.isEnabled = false
        setPasswordButton.isEnabled = false
        // check to see if a password was set to enable to unlock button
        if let _ = KeychainWrapper.standard.string(forKey: "password") {
            unlockButton.isEnabled = true
        }
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
    
    @objc func lockSecretMessage() {
        guard !secret.isHidden else { return }
        saveSecretMessage()
    }
    
    // alert with text field and submit. check against saved KeyChainWrapper saved password value
    // unlock if possible
    @objc func unlockWithPassword() {
        guard secret.isHidden else { return }
        let alertController = UIAlertController(title: "Enter Password", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        alertController.addAction(UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak alertController] action in
            if let text = alertController?.textFields?[0].text {
                if let password = KeychainWrapper.standard.string(forKey: "password") {
                    if text == password {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Invalid Password", message: "The password you provided is invalid.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    // alert controller with text field to enter password and save using KeyChainWrapper
    @objc func setPassword() {
        guard !secret.isHidden else { return }
        let alertController = UIAlertController(title: "Set Password", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Submit", style: .default) { [weak alertController] action in
            if let text = alertController?.textFields?[0].text {
                KeychainWrapper.standard.set(text, forKey: "password")
            }
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
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

