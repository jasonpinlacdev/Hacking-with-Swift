//
//  ViewController.swift
//  Project8 Swifty Words
//
//  Created by Jason Pinlac on 12/30/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var scoreLabel: UILabel!
    var wordsCompletedLabel: UILabel!
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var submitButton: UIButton!
    var clearButton: UIButton!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
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
    
    var level = 1
    var levels = [1, 2]
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        wordsCompletedLabel = UILabel()
        wordsCompletedLabel.translatesAutoresizingMaskIntoConstraints = false
        wordsCompletedLabel.textAlignment = .right
        wordsCompletedLabel.text = "Words Completed: \(wordsCompleted)"
        view.addSubview(wordsCompletedLabel)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: \(score)"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.textAlignment = .center
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("CLEAR", for: .normal)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clearButton)
        
        // button view and buttons
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                letterButton.layer.backgroundColor = UIColor.cyan.cgColor
                letterButton.layer.borderWidth = 1
                letterButton.layer.cornerRadius = 25
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        
        NSLayoutConstraint.activate([
            wordsCompletedLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            wordsCompletedLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: wordsCompletedLabel.bottomAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: answersLabel.bottomAnchor, constant: 20),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submitButton.heightAnchor.constraint(equalToConstant: 44.0),
            
            clearButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clearButton.heightAnchor.constraint(equalToConstant: 44.0),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll(keepingCapacity: true)
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            currentAnswer.text = ""
            wordsCompleted += 1
            score += 1
            
            if wordsCompleted % 7 == 0 {
                let ac = UIAlertController(title: "Well Done!", message: "Ready for another level?", preferredStyle: .alert)
                for level in levels {
                    ac.addAction(UIAlertAction(title: "Level \(level)", style: .default, handler: levelTapped))
                }
                present(ac, animated: true)
            }
        } else {
            score -= 1
            let ac = UIAlertController(title: "Incorrect", message: "\"\(currentAnswer.text!)\" is an incorrect submission", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
        }
        
        
        
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        for button in activatedButtons {
            button.isHidden = false
        }
        currentAnswer.text = ""
        activatedButtons.removeAll(keepingCapacity: true)
    }
    
    func loadLevel() {
        guard let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else { print("level\(level).txt doesn't exist"); return }
        guard let levelContents = try? String(contentsOf: levelFileURL) else { print("Could not get contents from level\(level).txt"); return }
        
        var clueString = ""
        var solutionsString = ""
        var letterBits = [String]()
        
        solutions.removeAll(keepingCapacity: true)
        for button in self.letterButtons {
            button.isHidden = false
        }
        
        var lines = levelContents.components(separatedBy: "\n")
        lines.shuffle()
        for (index, line) in lines.enumerated() {
            let parts = line.components(separatedBy: ": ")
            let answer = parts[0]
            let clue = parts[1]
            
            clueString += "\(index + 1). \(clue)\n"
            let solutionWord = answer.replacingOccurrences(of: "|", with: "")
            solutionsString += "\(solutionWord.count) letters\n"
            solutions.append(solutionWord)
            
            let bits = answer.components(separatedBy: "|")
            letterBits += bits
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
        letterBits.shuffle()
        if letterButtons.count == letterBits.count {
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    func levelTapped(action: UIAlertAction) {
        guard let levelTitle = action.title else { return }
        let levelParts = levelTitle.components(separatedBy: " ")
        if let levelInt = Int(levelParts[1]) {
            level = levelInt
            loadLevel()
        }
    }
    
}

