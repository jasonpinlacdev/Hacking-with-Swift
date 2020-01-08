//
//  ViewController.swift
//  Milestone3 Hangman
//
//  Created by Jason Pinlac on 1/5/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var hangmanLabel: UILabel!
    var displayWordLabel: UILabel!
    var buttonsView: UIView!
    var hintButton: UIBarButtonItem!
    var scoreLabel: UILabel!
    var streakLabel: UILabel!
    
    var arrayOfHangmanStages = [String]()
    var arrayOfWords = [String]()
    var arrayOfLetterButtons = [UIButton]()
    let winPhrases = ["Nice!", "Good job.", "Excellent!", "Good...Goooood!", "You're the best!"]
    let losePhrases = ["Dang, good try.", "Neh.", "Game over.", "Sorry, you lost"]
    
    var originalWord = ""
    var helpLetters = [String]()
    var usedLetters = [String]()
    var stage = 1 {
        didSet {
            hangmanLabel.text = arrayOfHangmanStages[stage]
        }
    }
    var displayWord = "" {
        didSet {
            var formattedCurrentWord = ""
            for char in displayWord {
                formattedCurrentWord += " \(char) "
            }
            displayWordLabel.text = formattedCurrentWord
        }
    }
    
    var completed = 0 {
        didSet {
            scoreLabel.text = "Words completed: (\(completed)/\(attempted))"
        }
    }
    var attempted = 0 {
        didSet {
            scoreLabel.text = "Words completed: (\(completed)/\(attempted))"
        }
    }
    var streak = 0 {
        didSet {
            streakLabel.text = "Current Streak: \(streak)"
        }
    }
    var lives = 6
   
    
    override func loadView() {
        view = UIView()
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Words completed: (\(completed)/\(attempted))"
        scoreLabel.textAlignment = .right
        scoreLabel.layer.borderWidth = 1
//        scoreLabel.layer.borderColor = UIColor.yellow.cgColor
        view.addSubview(scoreLabel)
        
        streakLabel = UILabel()
        streakLabel.translatesAutoresizingMaskIntoConstraints = false
        streakLabel.text = "Current Streak: \(streak)"
        streakLabel.textAlignment = .right
        streakLabel.layer.borderWidth = 1
//        streakLabel.layer.borderColor = UIColor.yellow.cgColor
        view.addSubview(streakLabel)
        
        hangmanLabel = UILabel()
        hangmanLabel.translatesAutoresizingMaskIntoConstraints = false
        hangmanLabel.text = "Hangman Stages"
        hangmanLabel.numberOfLines = 0
        hangmanLabel.textAlignment = .left
        hangmanLabel.layer.borderWidth = 1
//        hangmanLabel.layer.borderColor = UIColor.yellow.cgColor
        hangmanLabel.font = UIFont(name: "Courier-Bold", size: 18)
        view.addSubview(hangmanLabel)
        
        displayWordLabel = UILabel()
        displayWordLabel.translatesAutoresizingMaskIntoConstraints = false
        displayWordLabel.text = "Current word"
        displayWordLabel.textAlignment = .left
        displayWordLabel.textColor = .systemGreen
        displayWordLabel.font = UIFont.systemFont(ofSize: 42)
//        displayWordLabel.layer.borderColor = UIColor.yellow.cgColor
        displayWordLabel.layer.borderWidth = 1
        view.addSubview(displayWordLabel)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
//        buttonsView.layer.borderColor = UIColor.white.cgColor
        view.addSubview(buttonsView)
        
        let buttonWidth = 43
        let buttonHeight = 43
        
        var asciiValue = Character("a").asciiValue! - 1
        for row in 0 ..< 3 {
            for column in 0 ..< 8 {
                let button = UIButton(type: .system)
                
                asciiValue += 1
                let u = UnicodeScalar(asciiValue)
                let char = Character(u)
                button.setTitle(String(char).uppercased(), for: .normal)
                
                button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                button.frame = CGRect(x: buttonWidth * column, y: buttonHeight * row, width: buttonWidth, height: buttonHeight)
                button.backgroundColor = .systemGray
//                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.white.cgColor
                button.setTitleColor(.white, for: .normal)
                button.layer.cornerRadius = 23

                button.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                arrayOfLetterButtons.append(button)
                buttonsView.addSubview(button)
            }
            
            let yAsciiValue = Character("y").asciiValue!
            let u1 = UnicodeScalar(yAsciiValue)
            let char1 = Character(u1)
            let yButton = UIButton(type: .system)
            yButton.setTitle(String(char1).uppercased(), for: .normal)
            yButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            yButton.frame = CGRect(x: buttonWidth * 0, y: buttonHeight * 3, width: buttonWidth, height: buttonHeight)
            yButton.backgroundColor = .lightGray
//            yButton.layer.borderWidth = 1
            yButton.layer.borderColor = UIColor.white.cgColor
            yButton.setTitleColor(.white, for: .normal)
            yButton.layer.cornerRadius = 23
            yButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            arrayOfLetterButtons.append(yButton)
            buttonsView.addSubview(yButton)
            
            let zAsciiValue = Character("z").asciiValue!
            let u2 = UnicodeScalar(zAsciiValue)
            let char2 = Character(u2)
            let zButton = UIButton(type: .system)
            zButton.setTitle(String(char2).uppercased(), for: .normal)
            zButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            zButton.frame = CGRect(x: buttonWidth * 1, y: buttonHeight * 3, width: buttonWidth, height: buttonHeight)
            zButton.backgroundColor = .lightGray
//            zButton.layer.borderWidth = 1
            zButton.layer.borderColor = UIColor.white.cgColor
            zButton.setTitleColor(.white, for: .normal)
            zButton.layer.cornerRadius = 23
            zButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            arrayOfLetterButtons.append(zButton)
            buttonsView.addSubview(zButton)
        }
        
        NSLayoutConstraint.activate([
            
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            scoreLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            streakLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            streakLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            hangmanLabel.bottomAnchor.constraint(equalTo: displayWordLabel.topAnchor, constant: -40),
            hangmanLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            displayWordLabel.bottomAnchor.constraint(equalTo: buttonsView.topAnchor, constant: -10),
            displayWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: 344),
            buttonsView.heightAnchor.constraint(equalToConstant: 172),
        ])
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Hangman"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(newWord))
        hintButton = UIBarButtonItem(title: "Hint", style: .plain, target: self, action: #selector(hintTapped))
        navigationItem.rightBarButtonItem = hintButton
        parseHangmanStagesFile()
        parseWordsFile()
        startNewGame()
    }
    
    func startNewGame() {
        attempted += 1
        stage = 0
        lives = 6
        helpLetters.removeAll()
        
        originalWord = arrayOfWords.randomElement()!
        var tempWord = ""
        for letter in originalWord {
            tempWord += "_"
            helpLetters.append(String(letter))
        }
        displayWord = tempWord
        
        usedLetters.removeAll()
        for button in arrayOfLetterButtons {
            button.isEnabled = true
            button.backgroundColor = .darkGray
        }
        hintButton.isEnabled = true
        
        print(originalWord)
    }
    
    func parseHangmanStagesFile() {
        guard let url = Bundle.main.url(forResource: "hangman", withExtension: "txt") else { return }
        guard let fileContent = try? String(contentsOf: url) else { return }
        arrayOfHangmanStages = fileContent.components(separatedBy: "break")
    }
    
    func parseWordsFile() {
        guard let url = Bundle.main.url(forResource: "words", withExtension: "txt") else { return }
        guard let fileContent = try? String(contentsOf: url) else { return }
        arrayOfWords = fileContent.components(separatedBy: "\n")
        arrayOfWords.shuffle()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let tappedTitle = sender.titleLabel?.text else { print("error"); return }
        let tappedLetter = Character(tappedTitle.lowercased())
        
        // ADD LETTER TO USED LETTERS
        if !usedLetters.contains(String(tappedLetter)) {
            usedLetters.append(String(tappedLetter))
        }
        
        // REMOVE LETTERS FROM HELP LETTERS
        if helpLetters.contains(String(tappedLetter)) {
            var helpWord = helpLetters.joined(separator: "")
            helpWord = helpWord.replacingOccurrences(of: String(tappedLetter), with: "")
            helpLetters.removeAll()
            for letter in helpWord {
                let strLetter = String(letter)
                helpLetters.append(strLetter)
            }
        }
        
        // CHANGE COLOR AND DEACTIVE BUTTON
        if originalWord.contains(tappedLetter) {
            sender.backgroundColor = .systemGreen
        } else {
            sender.backgroundColor = .systemRed
            stage += 1
            lives -= 1
        }
        sender.isEnabled = false
        
        // BUILD CURRENTWORD FOR DISPLAY
        var tempWord = ""
        for letter in originalWord {
            let strLetter = String(letter)
            
            if usedLetters.contains(strLetter) {
                tempWord += strLetter
            } else {
                tempWord += "_"
            }
        }
        displayWord = tempWord
        
        // CHECK IF OUT OF LIVES
        if lives == 0 {
            streak = 0
            let ac = UIAlertController(title: losePhrases.randomElement(), message: "\"\(originalWord)\"", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .default) { [weak self]_ in
                self?.startNewGame()
            })
            present(ac, animated: true)
        }
        
        // CHECK IF WORD IS MATCHED
        if displayWord == originalWord {
            completed += 1
            streak += 1
            hangmanLabel.text = arrayOfHangmanStages[arrayOfHangmanStages.count-1]
            let ac = UIAlertController(title: winPhrases.randomElement(), message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .default) { [weak self]_ in
                self?.startNewGame()
            })
            present(ac, animated: true)
        }
    }
    
    @objc func hintTapped(_ sender: UIButton) {
        if let randomHelpLetter = helpLetters.randomElement() {
            
            sender.isEnabled = false
            
            // ADD LETTER TO USED LETTERS
            if !usedLetters.contains(randomHelpLetter) {
                usedLetters.append(randomHelpLetter)
            }
            
            // REMOVE LETTERS FROM HELP LETTERS
            if helpLetters.contains(randomHelpLetter) {
                var helpWord = helpLetters.joined(separator: "")
                helpWord = helpWord.replacingOccurrences(of: randomHelpLetter, with: "")
                helpLetters.removeAll()
                for letter in helpWord {
                    let strLetter = String(letter)
                    helpLetters.append(strLetter)
                }
            }
            
            // CHANGE COLOR AND DEACTIVE BUTTON
            var matchingButton: UIButton
            for button in arrayOfLetterButtons {
                if button.titleLabel?.text?.lowercased() == randomHelpLetter {
                    matchingButton = button
                    button.backgroundColor = .systemGreen
                    matchingButton.isEnabled = false
                }
            }
            
            // BUILD CURRENT WORD FOR DISPLAY
            var tempWord = ""
            for letter in originalWord {
                let strLetter = String(letter)
                
                if usedLetters.contains(strLetter) {
                    tempWord += strLetter
                } else {
                    tempWord += "_"
                }
            }
            displayWord = tempWord
            
            // CHECK IF WORD IS MATCHED
            if displayWord == originalWord {
                completed += 1
                streak += 1
                hangmanLabel.text = arrayOfHangmanStages[arrayOfHangmanStages.count-1]
                let ac = UIAlertController(title: winPhrases.randomElement(), message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .default) { [weak self]_ in
                    self?.startNewGame()
                })
                present(ac, animated: true)
            }
        }
    }
    
    @objc func newWord(_ sender:UIBarButtonItem) {
        startNewGame()
        streak = 0
    }
}

