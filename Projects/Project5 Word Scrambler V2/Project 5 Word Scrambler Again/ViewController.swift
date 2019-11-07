//
//  ViewController.swift
//  Project 5 Word Scrambler Again
//
//  Created by Jason Pinlac on 11/6/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	var allWords = [String]()
	var usedWords = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		setupNavigationBar()
		getWordsFromFile()
		startGame()
	}
	
	func setupNavigationBar() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(promptForAnswer))
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
	}
	
	func getWordsFromFile() {
		if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
			if let startWords = try? String(contentsOf: startWordsURL) {
				allWords = startWords.components(separatedBy: "\n")
				return
			}
		}
		allWords.append("silkworm")
	}
	
	@objc func startGame() {
		title = allWords.randomElement()
		usedWords.removeAll(keepingCapacity: true)
		tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return usedWords.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Words", for: indexPath)
		cell.textLabel?.text = usedWords[indexPath.row]
		return cell
	}
	
	@objc func promptForAnswer() {
		let ac = UIAlertController(title: "Guess a word...", message: nil, preferredStyle: .alert)
		ac.addTextField(configurationHandler: nil)
		
		let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak ac, weak self] _ in
			if let answer = ac?.textFields?[0].text {
				self?.submit(answer)
			}
		}
		
		ac.addAction(submitAction)
		present(ac, animated: true)
	}
	
	func submit(_ word: String) {
		let loweredWord = word.lowercased()
		let title: String
		let message: String
		
		if isNotTitle(loweredWord) {
			if isPossible(loweredWord) {
				if isOriginal(loweredWord) {
					if isReal(loweredWord) {
						if isMoreThanTwoLetters(loweredWord) {
							usedWords.insert(loweredWord, at: 0)
							let indexPath = IndexPath(row: 0, section: 0)
							tableView.insertRows(at: [indexPath], with: .automatic)
						} else {
							title = "Word is less the three letters"
							message = "You're trying to submit a word that is too small."
							wordValidationAlert(title: title, message: message)
						}
					} else {
						title = "Word is not real"
						message = "You're trying to submit a made up word."
						wordValidationAlert(title: title, message: message)
					}
				} else {
					title = "Word is not original"
					message = "You're trying to submit a word that has already been submitted."
					wordValidationAlert(title: title, message: message)
				}
			} else {
				guard let titleWord = self.title?.lowercased() else { return }
				title = "Word not possible"
				message = "You're trying to submit characters that are not part of \"\(titleWord)\""
				wordValidationAlert(title: title, message: message)
			}
		} else {
			guard let _ = self.title?.lowercased() else { return }
			title = "Word is the title"
			message = "You're trying to submit the title word."
			wordValidationAlert(title: title, message: message)
		}
		
	}
	
	func isNotTitle(_ word: String) -> Bool {
		return !(word == title)
	}
	
	func isMoreThanTwoLetters(_ word: String) -> Bool {
		return word.count > 2
	}
	
	func isPossible(_ word: String) -> Bool {
		guard var titleWord = title?.lowercased() else { return false}
		
		for letter in word {
			if let position = titleWord.firstIndex(of: letter) {
				titleWord.remove(at: position)
			} else {
				return false
			}
		}
		return true
	}
	
	func isOriginal(_ word: String) -> Bool {
		return !usedWords.contains(word)
	}
	
	func isReal(_ word: String) -> Bool {
		let checker = UITextChecker()
		let range = NSRange(location: 0, length: word.utf16.count)
		let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
		return mispelledRange.location == NSNotFound
	}
	
	func wordValidationAlert(title: String, message: String) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
		present(ac, animated: true)
	}
}

