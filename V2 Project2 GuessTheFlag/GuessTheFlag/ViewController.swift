//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Jason Pinlac on 10/17/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet var flagButton1: UIButton!
	@IBOutlet var flagButton2: UIButton!
	@IBOutlet var flagButton3: UIButton!
	
	var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
	var flagToGuess: Int?
	var score = 0
	var count = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(getScore))
		
		flagButton1.layer.borderWidth = 1
		flagButton1.layer.borderColor = UIColor.gray.cgColor
		flagButton1.layer.cornerRadius = 25
		
		flagButton2.layer.borderWidth = 1
		flagButton2.layer.borderColor = UIColor.gray.cgColor
		flagButton2.layer.cornerRadius = 25
		
		flagButton3.layer.borderWidth = 1
		flagButton3.layer.borderColor = UIColor.gray.cgColor
		flagButton3.layer.cornerRadius = 25
		
		playGame()
	}
	
	@IBAction func flagTouched(_ sender: UIButton) {
		var title = ""
		var message = ""
		if sender.tag == flagToGuess {
			score += 1
			title = "Correct"
			message = "You guessed \(countries[sender.tag].uppercased()) correctly!"
		} else {
			title = "Wrong"
			message = "You chose the flag of \(countries[sender.tag].uppercased())."
		}
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Continue", style: .default) { _ in self.playGame() })
		present(alert, animated: true)
	}
	
	func playGame() {
		count += 1
		if count == 11 {
			count -= 1
			restartGame()
		}
		
		countries.shuffle()
		flagButton1.setImage(UIImage(named: countries[0]), for: .normal)
		flagButton2.setImage(UIImage(named: countries[1]), for: .normal)
		flagButton3.setImage(UIImage(named: countries[2]), for: .normal)
		flagToGuess = Int.random(in: 0 ... 2)
		title = "Question: \(count)\tFlag: \(countries[flagToGuess!].uppercased())\t\tScore:"
	}
	
	func restartGame() {
		let alert = UIAlertController(title: "End of game", message: "\(Double(score)/Double(count) * 100.0)%. You've answered \(score)/\(count) correctly!", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Restart", style: .default) { _ in
			self.count = 0
			self.score = 0
			self.playGame() })
		present(alert, animated: true)
	}
	
	@objc func getScore() {
		let alert = UIAlertController(title: "Score", message: "Your score is \(score).", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
		present(alert, animated: true)
	}
}

