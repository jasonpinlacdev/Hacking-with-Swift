//
//  ViewController.swift
//  Project8 Swifty Words iPhone
//
//  Created by Jason Pinlac on 1/2/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var wordsCompletedLabel: UILabel!
    var scoreLabel: UILabel!
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswerTextField: UITextField!
    var submitButton: UIButton!
    var clearButton: UIButton!
    var buttonsView: UIView!
    
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var wordsCompleted = 0 {
        didSet {
            wordsCompletedLabel.text = "Words Completed: \(wordsCompleted)"
        }
    }
    var currentLevel = 1
    var solutions = [String]()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        
        wordsCompletedLabel = UILabel()
        wordsCompletedLabel.translatesAutoresizingMaskIntoConstraints = false
        wordsCompletedLabel.textAlignment = .right
        wordsCompletedLabel.text = "Words completed: \(wordsCompleted)"
        view.addSubview(wordsCompletedLabel)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: \(score)"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        cluesLabel.textAlignment = .left
        cluesLabel.numberOfLines = 0
        cluesLabel.text = "Clues label"
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.text = "Answers label"
        view.addSubview(answersLabel)
        
        currentAnswerTextField = UITextField()
        currentAnswerTextField.translatesAutoresizingMaskIntoConstraints = false
        currentAnswerTextField.placeholder = "TAP LETTERS TO GUESS"
        currentAnswerTextField.font = UIFont.systemFont(ofSize: 24)
        currentAnswerTextField.isUserInteractionEnabled = false
        currentAnswerTextField.textAlignment = .center
        view.addSubview(currentAnswerTextField)
        
        submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        view.addSubview(clearButton)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        // BUTTONS
        let buttonWidth = 86
        let buttonHeight = 60
        for column in 0 ..< 4 {
            for row in 0 ..< 5 {
                let button = UIButton(type: .system)
                button.setTitle("WWW", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 35)
                button.frame = CGRect(x: buttonWidth * column, y: buttonHeight * row, width: buttonWidth, height: buttonHeight)
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.lightGray.cgColor
                button.layer.cornerRadius = 10
                //                button.backgroundColor = .yellow
                button.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
                buttonsView.addSubview(button)
                letterButtons.append(button)
            }
        }
        
        currentAnswerTextField.layer.borderColor = UIColor.lightGray.cgColor
        currentAnswerTextField.layer.borderWidth = 1
        currentAnswerTextField.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            wordsCompletedLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            wordsCompletedLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: wordsCompletedLabel.bottomAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            cluesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
            answersLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswerTextField.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 10),
            currentAnswerTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            currentAnswerTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            submitButton.topAnchor.constraint(equalTo: currentAnswerTextField.bottomAnchor, constant: 10),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -35),
            
            clearButton.topAnchor.constraint(equalTo: currentAnswerTextField.bottomAnchor, constant: 10),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 35),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 344),
            buttonsView.heightAnchor.constraint(equalToConstant: 300),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 10),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }
    
    @objc func letterButtonTapped(_ sender: UIButton) {
        if let letters = sender.titleLabel?.text {
            currentAnswerTextField.text = currentAnswerTextField.text?.appending(letters)
            sender.isHidden = true
            activatedButtons.append(sender)
        }
    }
    
    @objc func clearButtonTapped(_ sender: UIButton) {
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
        currentAnswerTextField.text = ""
    }
    
    @objc func submitButtonTapped(_ sender: UIButton) {
        guard let currentAnswer = currentAnswerTextField.text else { return }
        if let positionFound = solutions.firstIndex(of: currentAnswer) {
            guard var answersArray = answersLabel.text?.components(separatedBy: "\n") else { return }
            guard let cluesArray = cluesLabel.text?.components(separatedBy: "\n") else { return }
            
            let ac = UIAlertController(title: "Correct!", message: "\(cluesArray[positionFound]): \"\(solutions[positionFound])\"", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default) { [weak self] _ in
                if self!.wordsCompleted % 7 == 0 {
                    let ac = UIAlertController(title: "Congratulations", message: "You did it! Now select a new level.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Level 1", style: .default, handler: self?.levelTapped))
                    ac.addAction(UIAlertAction(title: "Level 2", style: .default, handler: self?.levelTapped))
                    self?.present(ac, animated: true)
                    
                    self?.solutions.removeAll(keepingCapacity: true)
                    for button in self?.letterButtons ?? [] {
                        button.isHidden = false
                    }
                }
            })
            present(ac, animated: true)
            
            answersArray[positionFound] = solutions[positionFound]
            answersLabel.text = answersArray.joined(separator: "\n")
            
            activatedButtons.removeAll()
            currentAnswerTextField.text = ""
            score += 1
            wordsCompleted += 1
        } else {
            var message = "\"\(currentAnswer)\" is incorrect"
            if currentAnswer == "" {
                message = "Tap the letters before submitting an answer"
            }
            let ac = UIAlertController(title: "Incorrect", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
            score -= 1
            for button in activatedButtons {
                button.isHidden = false
            }
            activatedButtons.removeAll()
            currentAnswerTextField.text = ""
        }
    }
    
    func loadLevel() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let levelURL = Bundle.main.url(forResource: "level\((self?.currentLevel)!)", withExtension: "txt") else { print("Error: getting level url"); return }
            guard let levelContents = try? String(contentsOf: levelURL).trimmingCharacters(in: .whitespacesAndNewlines) else { print("Error: getting level contents of the provided url"); return }
            
            var cluesText = ""
            var answersText = ""
            var letterBits = [String]()
        
            var levelLines = levelContents.components(separatedBy: "\n")
            levelLines.shuffle()
            
            for (index, line) in levelLines.enumerated() {
                let lineParts = line.components(separatedBy: ": ")
                let answer = lineParts[0]
                let clue = lineParts[1]
                
                cluesText += "\(index + 1). \(clue)\n"
                let answerWord = answer.replacingOccurrences(of: "|", with: "")
                answersText += "\(answerWord.count) letters\n"
                self?.solutions.append(answerWord)
                
                letterBits += answer.components(separatedBy: "|")
            }
            
            DispatchQueue.main.sync {
                self?.cluesLabel.text = cluesText.trimmingCharacters(in: .whitespacesAndNewlines)
                self?.answersLabel.text = answersText.trimmingCharacters(in: .whitespacesAndNewlines)
                if letterBits.count == self?.letterButtons.count {
                    for button in self?.letterButtons ?? [] {
                        button.setTitle(letterBits.remove(at: Int.random(in: 0..<letterBits.count)), for: .normal)
                    }
                }
            }
        }
        
    }
    
    func levelTapped(action: UIAlertAction) {
        if let levelTitle = action.title {
            let titleParts = levelTitle.components(separatedBy: " ")
            if let levelNumber = Int(titleParts[1]) {
                currentLevel = levelNumber
                loadLevel()
            }
        }
    }
    
    
}
