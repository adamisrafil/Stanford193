//
//  ViewController.swift
//  Set
//
//  Created by Adam Israfil on 12/8/19.
//  Copyright © 2019 Adam Israfil. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var matchesLabel: UILabel!
    @IBOutlet weak var drawCardsButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var cardsContainerView: CardContainerView!
    
    private var set = SetGame()
    
    private var selectedButtons = [SetCardButton]() {
        didSet {
            if selectedButtons.count == 3 {
                setWasFound = checkIfSelectedButtonsFormASet()
                if setWasFound {
                    score += 3
                    matches += 1
                } else {
                    score -= 5
                }
                selectedButtons.forEach { button in
                    button.layer.borderColor = setWasFound ? UIColor.green.cgColor : UIColor.red.cgColor
                    button.isEnabled = !setWasFound
                }
            }
        }
    }
    private var setWasFound = false
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var matches = 0 {
        didSet {
            matchesLabel.text = "Matches: \(matches)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set.drawCardsForNewGame()
        cardsContainerView.addCardButtons(numberOfCardButtonsToAdd: 12)
        updateViewFromModel()
        assignTargetAction()
    }
    
    @IBAction func didPressDrawCardsButton(_ sender: UIButton) {
        set.drawThreeCards()
        cardsContainerView.addCardButtons(numberOfCardButtonsToAdd: 3)
        updateViewFromModel()
        updateDrawButton()
        selectedButtons.removeAll()
        assignTargetAction()
        cardsContainerView.layoutSubviews()
    }
    
    @IBAction func didPressNewGameButton(_ sender: UIButton) {
        set = SetGame()
        cardsContainerView.layoutSubviews()
        updateViewFromModel()
        updateDrawButton()
        selectedButtons.removeAll()
        score = 0
        matches = 0
    }
    
    @objc func didPressCardButton(_ sender: UIButton) {
        if selectedButtons.count == 3 {
            selectedButtons.removeAll()
            updateViewFromModel()
            cardsContainerView.layoutSubviews()
        }
        if selectedButtons.contains(sender as! SetCardButton) {
            sender.layer.borderWidth = 0.0
            if let buttonIndex = selectedButtons.firstIndex(of: sender as! SetCardButton) {
                selectedButtons.remove(at: buttonIndex)
            }
        } else {
            sender.layer.borderWidth = 3.0
            sender.layer.borderColor = UIColor.blue.cgColor
            selectedButtons.append(sender as! SetCardButton)
        }
    }
    
    private func checkIfSelectedButtonsFormASet() -> Bool {
        var selectedCardIndexes = [Int]()
        for button in selectedButtons {
            if let selectedCardIndex = cardsContainerView.cardButtons.firstIndex(of: button) {
                selectedCardIndexes.append(selectedCardIndex)
            }
        }
        
        return set.chooseCard(indexes: selectedCardIndexes)
    }
    
    private func assignTargetAction() {
        for button in cardsContainerView.cardButtons {
            button.addTarget(self, action: #selector(didPressCardButton(_:)), for: .touchUpInside)
        }
    }
    
    private func updateViewFromModel() {
        if cardsContainerView.cardButtons.count > set.cardsOnTable.count {
            cardsContainerView.removeCardButtons(numberOfCardButtonsToRemove: cardsContainerView.cardButtons.count - set.cardsOnTable.count)
        }
        
        for (index, button) in cardsContainerView.cardButtons.enumerated() {
            if index < set.cardsOnTable.count {
                let currentCard = set.cardsOnTable[index]
                
                button.backgroundColor = .white
                
                switch currentCard.color {
                case .purple:
                    button.color = .purple
                case .green:
                    button.color = .green
                case .red:
                    button.color = .red
                }
                
                switch currentCard.fill {
                case .outlined:
                    button.symbolShading = .outlined
                case .solid:
                    button.symbolShading = .solid
                case .striped:
                    button.symbolShading = .striped
                }
                
                switch currentCard.shape {
                case .diamond:
                    button.symbolShape = .diamond
                case .squiggle:
                    button.symbolShape = .squiggle
                case .oval:
                    button.symbolShape = .oval
                }
                
                switch currentCard.number {
                case .one:
                    button.numberOfSymbols = 1
                case .two:
                    button.numberOfSymbols = 2
                case .three:
                    button.numberOfSymbols = 3
                }
            }
            
            updateDrawButton()
        }
    }
    
    private func updateDrawButton() {
        if set.cardDeck.count == 0 {
            drawCardsButton.isHidden = true
        } else {
            drawCardsButton.isHidden = false
        }
    }
    
    // MARK: Gesture Recognizers
    
    @IBAction private func shuffle(_ recognizer: UIRotationGestureRecognizer) {
        //        cardsContainerView.removeAllCardsFromTable()
        //        set.shuffleCardsOnTable()
        //        updateViewFromModel()
        //        assignTargetAction()
        if recognizer.state == .began {
            set.shuffleCardsOnTable()
            updateViewFromModel()
        }
    }
    
    @IBAction private func draw(_ recognizer: UISwipeGestureRecognizer) {
        didPressDrawCardsButton(drawCardsButton)
        updateViewFromModel()
        updateDrawButton()
        assignTargetAction()
    }
}

