//
//  ViewController.swift
//  Milestone10 Concentration
//
//  Created by Jason Pinlac on 4/13/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    var contentForCardButtons = ["🍎","🍑","🍊","🍐","🥥","🍒","🍌","🍋","🍏","🥝","🍉","🥭"]
    var cardButtons = [CardButton]()
    
    var firstTouchedCard: CardButton?
    var secondTouchedCard: CardButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Concentration"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(optionsTapped))
        
        createCards()
        setupStackViews()
    }
    
    @objc func optionsTapped() {
        let optionsTableViewController = OptionsTableViewController()
        optionsTableViewController.viewController = self
        navigationController?.pushViewController(optionsTableViewController, animated: true)
    }
    
    func setupStackViews() {
        cardButtons.shuffle()
        
        let verticalStackView = UIStackView()
        verticalStackView.accessibilityIdentifier = "Vertical Column"
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 5.0
        
        view.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        verticalStackView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor).isActive = true
        
        var horizontalStackView = UIStackView()

        for (index, cardButton) in cardButtons.enumerated() {
            if index % 4 == 0 {
                horizontalStackView = UIStackView()
                horizontalStackView.accessibilityIdentifier = "Horizontal Row"
                horizontalStackView.axis = .horizontal
                horizontalStackView.alignment = .fill
                horizontalStackView.distribution = .fillEqually
                horizontalStackView.spacing = 5.0
                verticalStackView.addArrangedSubview(horizontalStackView)
            }
            horizontalStackView.addArrangedSubview(cardButton)
        }
    }
    
    
    func createCards() {
        for content in contentForCardButtons {
            let cardA = CardButton()
            cardA.configure(content: content)
            cardA.accessibilityIdentifier = content
            cardA.addTarget(self, action: #selector(cardButtonTapped(_:)), for: .touchUpInside)
            
            let cardB = CardButton()
            cardB.configure(content: content)
            cardB.accessibilityIdentifier = content
            cardB.addTarget(self, action: #selector(cardButtonTapped(_:)), for: .touchUpInside)
            
            cardButtons.append(contentsOf: [cardA, cardB])
        }
        cardButtons.shuffle()
    }

    
    @objc func cardButtonTapped(_ sender: CardButton) {
        if sender == firstTouchedCard { return } // user can't touch a card already touched
        if secondTouchedCard != nil { return } // can't have more than two cards touched
        
        sender.flipUp()
        
        if firstTouchedCard == nil {
            firstTouchedCard = sender
            return
        }
        
        if secondTouchedCard == nil {
            secondTouchedCard = sender
        }
        
        // if secondTouchedCard gets assigned sender that means two cards have been touched
        // check if match
        if firstTouchedCard?.content == secondTouchedCard?.content {
            firstTouchedCard?.isMatched = true
            secondTouchedCard?.isMatched = true
            firstTouchedCard?.isUserInteractionEnabled = false
            secondTouchedCard?.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.firstTouchedCard?.blackOut()
                self?.secondTouchedCard?.blackOut()
                self?.firstTouchedCard = nil
                self?.secondTouchedCard = nil
            }
            checkToResetGame()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.flipDownAllCards()
                self?.firstTouchedCard = nil
                self?.secondTouchedCard = nil
            }
        }
        
    }
    
    func flipDownAllCards() {
        for card in cardButtons {
            if !card.isMatched {
                card.flipDown()
            }
        }
    }
    
    
    func checkToResetGame() {
        for card in cardButtons {
            if !card.isMatched { return }
        }
        
        // alert youve completed the game
        let endGameAlertController = UIAlertController(title: "Congratulations", message: "You've matched all the cards.", preferredStyle: .alert)
        endGameAlertController.addAction(UIAlertAction(title: "Play Again", style: .default) { [weak self] action in
            // reset all values to starting
            self?.resetGame()
        })
        present(endGameAlertController, animated: true)
    }
    
    func resetGame() {
        removeAllSubviews()
        cardButtons.removeAll(keepingCapacity: true)
        createCards()
        setupStackViews()
    }
    
    
    func removeAllSubviews() {
        // remove all card buttons
        for verticalColumn in view.subviews {
            for horizontalRow in verticalColumn.subviews {
                for cardButton in horizontalRow.subviews {
                    print("REMOVING: \(cardButton.accessibilityIdentifier!)")
                    cardButton.removeFromSuperview()
                }
            }
        }
        
        // remove all rows
        for verticalColumn in view.subviews {
            for horizontalRow in verticalColumn.subviews {
                print("REMOVING: \(horizontalRow.accessibilityIdentifier!)")
                horizontalRow.removeFromSuperview()
            }
        }
        
        // remove all columns
        for verticalColumn in view.subviews {
            print("REMOVING: \(verticalColumn.accessibilityIdentifier!)")
            verticalColumn.removeFromSuperview()
        }
    }
    
}
