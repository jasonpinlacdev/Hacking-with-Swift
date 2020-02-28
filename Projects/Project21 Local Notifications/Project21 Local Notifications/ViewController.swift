//
//  ViewController.swift
//  Project21 Local Notifications
//
//  Created by Jason Pinlac on 2/27/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit
import UserNotifications


class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Local Notifications"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocalNotification))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocalNotification))
    }

    
    @objc func registerLocalNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            (granted, error) in
            if granted {
                print("Registration complete and permissions for local notifications granted.")
            } else {
                print("Registration failed. Local notifications cannot be used.")
            }
        }
    }
    
    @objc func scheduleLocalNotification() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        // what to show - content
        let content = UNMutableNotificationContent()
        content.title = "A late wake up call"
        content.body = "The early bird gets catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "early bird"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        //when to show - timing. 3 types - calendar trigger, interval trigger, geofence IE location
//        var dateComponents = DateComponents()
//        dateComponents.hour = 23
//        dateComponents.minute = 17
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let time: Double = 5.0
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        
        // request - combination of content and timeing
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        print("Local notification schedule in \(time) seconds.")
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me later.", options: .foreground)
        let category = UNNotificationCategory(identifier: "early bird", actions: [show, remind], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
       
        if let customData = userInfo["customData"] as? String {
            print("Custom data recieved: \(customData)")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            let ac = UIAlertController(title: "Local Notification Recieve Response", message: "Default action was taken.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
        case "show":
            let ac = UIAlertController(title: "Local Notification Recieve Response", message: "Show action was taken.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
        case "remind":
            let ac = UIAlertController(title: "Local Notification Recieve Response", message: "Remind action was taken.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .default) {
                [weak self] _ in
                self?.scheduleLocalNotification()
            })
            present(ac, animated: true)
        default:
            break
        }
        
        completionHandler()
    }
    
    
    

}

