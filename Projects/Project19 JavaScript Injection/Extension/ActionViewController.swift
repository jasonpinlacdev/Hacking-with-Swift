//
//  ActionViewController.swift
//  Extension
//
//  Created by Jason Pinlac on 2/12/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    var pageTitle = ""
    var pageURL = ""
    var scripts: [String] = []
    var savedScripts: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let prewrittenScriptsButton = UIBarButtonItem(title: "Scripts", style: .plain, target: self, action: #selector(selectPrewrittenScript))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItems = [doneButton, prewrittenScriptsButton]
        
       
        let newButton = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(newScript))
        let showTableButton = UIBarButtonItem(title: "Table", style: .done, target: self, action: #selector(showTable))
        self.navigationItem.leftBarButtonItems = [newButton, showTableButton]
        
        
        //add observer to the notification center
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    self?.scripts.append("alert(\"\((self?.pageURL)!)\")")
                    self?.loadSiteCode()
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary  = ["customJavaScript": textView.text as String]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
        saveSiteCode()
    }
    
    // the parameter notification will contain the name of the notification and specific data in a dictionary related to the notification called userInfo. If the notification was from a keyboard the dictionary will contain a key called UIResponder.keyboardFrameEndUserInfoKey telling us of the frame of the keyboard. Value will be NSValue which is a wrapper to CGRect which has the properties CGSize and CGPoint used to describe the rectangle keyboard.
    @objc func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    
    @objc func showTable() {
        let vc = ScriptsTableViewController()
        vc.scripts = savedScripts
        vc.textView = self.textView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func newScript() {
        let ac = UIAlertController(title: "Save a Script", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default) {
            [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            self?.savedScripts.append(text)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func selectPrewrittenScript() {
        let ac = UIAlertController(title: "Prewritten Scripts", message: nil, preferredStyle: .actionSheet)
        for script in scripts {
            ac.addAction(UIAlertAction(title: script, style: .default, handler: importScript))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func importScript(action: UIAlertAction) {
        guard let text = action.title else { return }
        textView.text = text
    }
    
    func saveSiteCode() {
        let userDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        let siteCode = textView.text
        if let saveData = try? encoder.encode(siteCode) {
            userDefaults.set(saveData, forKey: pageURL)
            print("Save complete")
        } else {
            print("Failed to save")
        }
    }
    
    func loadSiteCode() {
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()
        if let data = userDefaults.object(forKey: pageURL) as? Data {
            DispatchQueue.main.async { [weak self] in
                do {
                    self?.textView.text = try decoder.decode(String.self, from: data)
                    print("Load complete")
                } catch {
                    print("Failed to load")
                }
            }
        }
        
    }
    
}
