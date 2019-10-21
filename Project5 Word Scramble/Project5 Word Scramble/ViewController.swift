//
//  ViewController.swift
//  Project5 Word Scramble
//
//  Created by Jason Pinlac on 10/20/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

// SUMMARY
// 1. Reloading table views
// 2. inserting rows
// 3. text input in alerts
// 4. strings and utf-16
// 5. closures
// 6. NSRange

import UIKit

class ViewController: UITableViewController {

	var allWords = [String]()
	var usedWords = [String]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		navigationConfigurations()
		getAllWordsFromFile()
		startGame()
	}
	
	
	func navigationConfigurations() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return usedWords.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
		cell.textLabel?.text = usedWords[indexPath.row]
		return cell
	}
	
	
	func getAllWordsFromFile() {
		if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
			if let startWords = try? String(contentsOf: startWordsURL) {
				allWords = startWords.components(separatedBy: "\n")
			}
		}
		if allWords.isEmpty { allWords.append("silkworm") }
	}

	
	func startGame() {
		title = allWords.randomElement()
		usedWords.removeAll(keepingCapacity: true)
		tableView.reloadData()
	}
	
	
	@objc func promptForAnswer() {
		let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
		ac.addTextField()
		
		let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
			guard let answer = ac?.textFields?[0].text else { return }
			self?.submit(answer)
		}
		
		ac.addAction(submitAction)
		present(ac, animated: true)
	}
	
	
	func submit(_ answer: String) {
		let errorTitle: String
		let errorMessage: String
		let loweredAnswer = answer.lowercased()
		
		if isPossible(word: loweredAnswer) {
			if isOriginal(word: loweredAnswer) {
				if isReal(word: loweredAnswer) {
					
					usedWords.insert(loweredAnswer, at: 0)
					let indexPath = IndexPath(row: 0, section: 0)
					tableView.insertRows(at: [indexPath], with: .automatic)
					return
				} else {
					errorTitle = "That is not a real word"
					errorMessage = "You can't just make them up, you know."
				}
			} else {
				errorTitle = "Word has already been used"
				errorMessage = "Be more original please."
			}
		} else {
			errorTitle = "Word is not possible"
			errorMessage = "Can't spell that word from \(title!)"
		}
		
		let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
		present(ac, animated: true)
	}
	
	
	func isPossible(word: String) -> Bool {
		guard var titleCopy = title else { return false }
		for letter in word {
			if let position = titleCopy.firstIndex(of: letter) {
				titleCopy.remove(at: position)
			} else {
				return false
			}
		}
		return true
	}
	
	
	func isOriginal(word: String) -> Bool {
		if usedWords.contains(word) {
			return false
		}
		return true
	}
	
	
	// THIS IS A REAL WORD CHECKER USES OBJECT C CODE
	func isReal(word: String) -> Bool {
		let checker = UITextChecker()
		let range = NSRange(location: 0, length: word.utf16.count)
		let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
		return misspelledRange.location == NSNotFound
	}
	


}

