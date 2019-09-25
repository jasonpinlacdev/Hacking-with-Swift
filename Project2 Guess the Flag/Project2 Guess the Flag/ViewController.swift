//
//  ViewController.swift
//  Project2 Guess the Flag
//
//  Created by Jason Pinlac on 9/20/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet var flagButton1: UIButton!
	@IBOutlet var flagButton2: UIButton!
	@IBOutlet var flagButton3: UIButton!
	
	var countries = [String]()
	var score = 0
	var correctAnswer = 0
	var numberOfQuestionsAsked = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		flagButton1.layer.borderWidth = 1
		flagButton2.layer.borderWidth = 1
		flagButton3.layer.borderWidth = 1
		
		flagButton1.layer.borderColor = UIColor.lightGray.cgColor
		flagButton2.layer.borderColor = UIColor.lightGray.cgColor
		flagButton3.layer.borderColor = UIColor.lightGray.cgColor
		
		countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
		askQuestion(action: nil)
	}
	
	func askQuestion(action: UIAlertAction!) {
		numberOfQuestionsAsked += 1
		
		if numberOfQuestionsAsked > 10 {
			restartGame()
		} else {
			countries.shuffle()
			correctAnswer = Int.random(in: 0...2)
			self.title = "\(numberOfQuestionsAsked)/10 \(countries[correctAnswer].uppercased()) \tScore: \(score)"
			
			flagButton1.setImage(UIImage(named: countries[0]), for: .normal)
			flagButton2.setImage(UIImage(named: countries[1]), for: .normal)
			flagButton3.setImage(UIImage(named: countries[2]), for: .normal)
		}
	}
	
	@IBAction func flagButtonPressed(_ sender: UIButton) {
		var title = ""
		var message = ""
		
		if sender.tag == correctAnswer {
			title = "Correct"
			score += 1
			message = "Your score: \(score)"
		} else {
			title = "Wrong"
			score -= 1
			message = "You incorrectly selected \(countries[sender.tag].uppercased())\nYour score: \(score)"
		}
		
		self.title = "\(numberOfQuestionsAsked)/10 \(countries[correctAnswer].uppercased()) \tScore: \(score)"
		
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
		present(ac, animated: true)
	}
	
	func restartGame() {
		let finalScore = score
		score = 0
		correctAnswer = 0
		numberOfQuestionsAsked = 0
		
		let ac = UIAlertController(title: "Restart", message: "Your Final Score: \(finalScore)", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: askQuestion))
		present(ac, animated: true)
	}
	
	
}
	
