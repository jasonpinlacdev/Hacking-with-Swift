//
//  ViewController.swift
//  Project21 Local Notifications
//
//  Created by Jason Pinlac on 2/19/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    // this method reuqeusts for permission. you register your settings based on what you actually need and that is done with request authorization() on UNUserNotificationCenter. Also a closure is provided that will be executed when the user has granted or denied permissions request.
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("yay!")
            } else {
                print("neh.")
            }
        }
    }
    
    // this method will configure all the data needed to schedule a notification which is 3 things. what content to show, when to show it, plus a request; which is a combination of content and timing.
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        // content for the notifcation
        let content = UNMutableNotificationContent()
        content.title = "Project 21 Notification Baby!"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        // trigger -- IE Timing; when it should be shown
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        var dateComponents = DateComponents()
//        dateComponents.hour = 17
//        dateComponents.minute = 16
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // request -- ties the content and the trigger together
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me later", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm" , actions: [show, remind], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
        let userInfo = response.notification.request.content.userInfo
       
        if let customData = userInfo["customData"] as? String {
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                let ac = UIAlertController(title: "Notification Received", message: "\"\(response.actionIdentifier)\" was used. userInfo customData: \(customData).", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
                present(ac, animated: true)
            case "show":
                let ac = UIAlertController(title: "Notification Received", message: "\"\(response.actionIdentifier)\" was used. userInfo custom Data: \(customData).", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
                present(ac, animated: true)
            case "remind":
                let ac = UIAlertController(title: "Notification Received", message: "\"\(response.actionIdentifier)\" was used. userInfo CustomData: \(customData). Another notification has been scheduled.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
                present(ac, animated: true)
                scheduleLocal()
            default:
                break
            }
        }
        
        // you must call the completion handler whe you're done
        completionHandler()
    }
}

