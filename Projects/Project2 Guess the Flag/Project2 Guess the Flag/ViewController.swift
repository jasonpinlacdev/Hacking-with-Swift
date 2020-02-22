//
//  ViewController.swift
//  Project2 Guess The Flag
//
//  Created by Jason Pinlac on 12/11/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var highScore = 0
    var score = 0
    var toGuess: Int!
    var numberOfQuestionsAsked = 0
    
    var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        setup()
        askQuestion()
    }
    
    func askQuestion() {
        numberOfQuestionsAsked += 1
        countries.shuffle()
        toGuess = Int.random(in: 0...2)
        title = countries[toGuess].uppercased()
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.25, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        })
        
        if sender.tag == toGuess {
            score += 100
            let ac = UIAlertController(title: "Correct", message: "Nice one!\n+100 points", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .default) { [weak self] _ in
                if self?.numberOfQuestionsAsked == 10 {
                    self?.reset()
                } else {
                    self?.askQuestion()
                }
            })
            present(ac, animated: true)
        } else {
            score -= 50
            let ac = UIAlertController(title: "Wrong", message: "That's the flag of \(countries[sender.tag].capitalized).\n-50 points", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            present(ac, animated: true)
        }
        
        UIView.animate(withDuration: 1, delay: 0.25, usingSpringWithDamping: 0.25, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func setup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .done, target: self, action: #selector(showScore))
        let question = UIBarButtonItem(title: "Question", style: .done, target: self, action: #selector(showQuestion))
        let notification = UIBarButtonItem(title: "Notification", style: .done, target: self, action: #selector(registerLocalNotification))
        navigationItem.leftBarButtonItems = [notification, question]
        
        button1.layer.borderColor = UIColor.gray.cgColor
        button1.layer.borderWidth = 1
        button1.layer.cornerRadius = 15
        button2.layer.borderColor = UIColor.gray.cgColor
        button2.layer.borderWidth = 1
        button2.layer.cornerRadius = 15
        button3.layer.borderColor = UIColor.gray.cgColor
        button3.layer.borderWidth = 1
        button3.layer.cornerRadius = 15
        load()
    }
    
    @objc func showScore() {
        let ac = UIAlertController(title: "Scores", message: "Current Score: \(score)/1000\nHigh Score: \(highScore)/1000", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    @objc func showQuestion() {
        let ac = UIAlertController(title: "Current Question", message: "\(numberOfQuestionsAsked)/10", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(ac, animated: true)
    }
    
    
    
    func reset() {
        if score > highScore {
            highScore = score
            save()
            let ac = UIAlertController(title: "New High Score", message: "Congratulations, you set a new high score: \(highScore)!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default) {
                [weak self] _ in
                let ac = UIAlertController(title: "Results", message: "Score: \((self?.score)!)/1000", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
                    self?.score = 0
                    self?.numberOfQuestionsAsked = 0
                    self?.askQuestion()
                })
                self?.present(ac, animated: true)
            })
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Results", message: "Score: \(score)/1000", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
                self?.score = 0
                self?.numberOfQuestionsAsked = 0
                self?.askQuestion()
            })
            present(ac, animated: true)
        }
        
        
    }
    
    
    
    func save() {
        let encoder = JSONEncoder()
        if let saveData = try? encoder.encode(highScore) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "highScore")
        } else {
            print("Failed to save")
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "highScore") as? Data {
            let decoder = JSONDecoder()
            do {
                let savedHighScore = try decoder.decode(Int.self, from: savedData)
                highScore = savedHighScore
            } catch {
                print("Failed to load")
            }
        }
    }
    
    
    @objc func registerLocalNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            [weak self] (granted, error) in
            if granted {
                self?.scheduleLocalNotification()
                print("Permission for local notifications granted.")
            } else {
                print("Permission for local notifications denied.")
            }
        }
    }
    
    func scheduleLocalNotification() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        
        // content - data
        let content = UNMutableNotificationContent()
        content.title = "Guess the Flag Daily Reminder"
        content.body = "Hey! Do you want to play your daily game of Guess the Flag and see if you can set a new high score?"
        content.categoryIdentifier = "game"
        content.sound = UNNotificationSound.default
        
        // trigger - timing
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // request - content and trigger
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        print("Daily reminder scheduled")
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        
        // actions
        let turnOffNotification = UNNotificationAction(identifier: "off", title: "Turn off notifications", options: .foreground)
        
        // category
        let category = UNNotificationCategory(identifier: "game", actions: [turnOffNotification], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "off":
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            center.removeAllDeliveredNotifications()
            
            let ac = UIAlertController(title: "Turn off Notifications", message: "Your daily notification has been turned off and all game notifications cleared.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
        default:
            break
        }
        // you must call the completion handler whe you're done
        completionHandler()
    }
    
    
}

