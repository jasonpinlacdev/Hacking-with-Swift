//
//  ViewController.swift
//  Milestone10 Concentration
//
//  Created by Jason Pinlac on 4/13/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//



// MARK: - TODO
// ADD FLIP ANIMATIONS
// CHCEK ALL CARDS ARE MATCHED AND END/ RESTART IF SO


import UIKit

class ViewController: UIViewController {
    
    var contentForCardButtons = ["🍎","🍑","🍊","🍐","🥥","🍒","🍌","🍋","🍏","🥝","🍉"]
    var cardButtons = [CardButton]()
    
    var firstTouchedCard: CardButton?
    var secondTouchedCard: CardButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Concentration"
        createCards()
        setupStackViews()
    }
    
    
    func setupStackViews() {
        let verticalStackView = UIStackView()
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
            cardA.addTarget(self, action: #selector(cardButtonTapped(_:)), for: .touchUpInside)
            
            let cardB = CardButton()
            cardB.configure(content: content)
            cardButtons.append(contentsOf: [cardA, cardB])
            cardB.addTarget(self, action: #selector(cardButtonTapped(_:)), for: .touchUpInside)
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
            
            // MARK: TODO - check if all cards are matched and then restart game
            
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
    
}
