//
//  NoteViewController.swift
//  Milestone7 iOS Imitation Notes App
//
//  Created by Jason Pinlac on 2/28/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    var selectedNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        navigationItem.largeTitleDisplayMode = .never
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        navigationItem.rightBarButtonItem = shareButton
        
        guard let selectedNote = selectedNote else { return }
        textView.text = "\(selectedNote.title)\n\(selectedNote.body)"
        title = selectedNote.date
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            // pass the new note back
            var textViewComponents = textView.text.components(separatedBy: "\n")
            selectedNote?.title = textViewComponents.remove(at: 0)
            selectedNote?.body = textViewComponents.joined(separator: "\n")
        }
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {
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
    
    
    @objc func shareButtonTapped() {
        guard let text = textView.text else { return }
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }
    
}
