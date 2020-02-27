//
//  ActionViewController.swift
//  JavaScript Extension
//
//  Created by Jason Pinlac on 2/26/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    var scripts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let selectScriptButton = UIBarButtonItem(title: "Scripts", style: .done, target: self, action: #selector(selectScript))
        let newScriptButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newScript))
        
        self.navigationItem.leftBarButtonItems = [newScriptButton, selectScriptButton]
    
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) {
                    [weak self] (dict, error) in
                    guard let itemDict = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDict[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    self?.loadJavaScript()
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                    
                }
            }
        }
    }

    
    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }

    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    
    @objc func selectScript() {
        let vc = ScriptsTableViewController()
        vc.title = "My Saved Scripts"
        vc.scripts = self.scripts
        vc.script = self.script
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func newScript() {
        let ac = UIAlertController(title: "Add New Script", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            self?.scripts.append(text)
            self?.saveJavaScript()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func saveJavaScript() {
        guard let url = URL(string: pageURL) else { return }
        guard let urlHost = url.host else { return }
        guard let text = script.text else { return }
        DispatchQueue.global(qos: .default).async {
            [weak self] in
            self?.scripts.append(text)
            if let dataToSave = try? JSONEncoder().encode(self?.scripts) {
                let userDefaults = UserDefaults.standard
                userDefaults.set(dataToSave, forKey: urlHost)
                print("Save successful")
            } else {
                print("Failed to save")
            }
        }
        
        
    }
    
    func loadJavaScript() {
        guard let url = URL(string: pageURL) else { return }
        guard let urlHost = url.host else { return }
        let userDefaults = UserDefaults.standard
        
        if let dataToLoad = userDefaults.object(forKey: urlHost) as? Data {
            DispatchQueue.main.async {
                [weak self] in
                do {
                    self?.scripts = try JSONDecoder().decode([String].self, from: dataToLoad)
                    print("Load successful")
                } catch {
                    print("Failed to load")
                }
            }
        }
       
    }
}
