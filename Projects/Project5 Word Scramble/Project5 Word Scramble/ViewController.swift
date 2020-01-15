//
//  ViewController.swift
//  Project5 Word Scramble
//
//  Created by Jason Pinlac on 12/14/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startGame()
    }
    
    func setup() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restart))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords.append("silkworm")
        }
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        load()
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Add word", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            if let answer = ac?.textFields?[0].text {
                self?.submit(answer)
            }
        }
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let title: String
        let message: String
        let loweredAnswer = answer.lowercased()
        if isOriginal(loweredAnswer) {
            if isPossible(loweredAnswer) {
                if isReal(loweredAnswer) {
                    if isLargerThanTwoLetters(loweredAnswer) {
                        usedWords.insert(loweredAnswer, at: 0)
                        save()
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)
                        return
                    } else {
                        title = "Too small"
                        message = "You're word must be made up of atleast three letters."
                    }
                } else {
                    title = "Not real"
                    message = "Don't make up words now."
                }
            } else  {
                title = "Not possible"
                message = "You're trying to use letters that are not part of the title word."
            }
        } else {
            title = "Not original"
            message = "You already submitted that word."
        }
        showErrorMessage(title, message)
    }
    
    func isOriginal(_ word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(_ word: String) -> Bool {
        guard var titleWord = title?.lowercased() else { return false }
        for letter in word {
            if let index = titleWord.firstIndex(of: letter) {
                titleWord.remove(at: index)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isLargerThanTwoLetters(_ word: String) -> Bool {
        return word.count > 2
    }
    
    func showErrorMessage(_ title: String, _ message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
              ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
              present(ac, animated: true)
    }
    
    
    @objc func restart() {
         title = allWords.randomElement()
         usedWords.removeAll(keepingCapacity: true)
         save()
         tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let titleWord = title {
            if let titleData = try? encoder.encode(titleWord) {
                let defaults = UserDefaults.standard
                defaults.set(titleData, forKey: "titleWord")
            }
            if let usedWordsData = try? encoder.encode(usedWords) {
                let defaults = UserDefaults.standard
                defaults.set(usedWordsData, forKey: "usedWords")
            }
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        if let savedTitleData = defaults.object(forKey: "titleWord") as? Data {
            do {
                title = try decoder.decode(String.self, from: savedTitleData)
            } catch {
                print("Failed to load title")
            }
        }
        if let usedWordsData = defaults.object(forKey: "usedWords") as? Data {
            do {
                usedWords = try decoder.decode([String].self, from: usedWordsData)
            } catch {
                print("Failed to load used words")
            }
        }
    }
    
    
}

