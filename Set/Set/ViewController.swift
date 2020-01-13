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
    @IBOutlet weak var drawCardsButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet var cardButtons: [UIButton]!
    
    private var set = SetGame()
    private var selectedButtons = [UIButton]() {
        didSet {
            if selectedButtons.count == 3 {
                setWasFound = checkIfSelectedButtonsFormASet()
                if setWasFound {
                    score += 3
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        
    }
    @IBAction func didPressDrawCardsButton(_ sender: UIButton) {
        set.draw()
        updateViewFromModel()
        updateDrawButton()
    }
    
    @IBAction func didPressNewGameButton(_ sender: UIButton) {
        set = SetGame()
        resetButton()
        updateViewFromModel()
        updateDrawButton()
        selectedButtons.removeAll()
        score = 0
    }
    
    @IBAction func didPressCardButton(_ sender: UIButton) {
        if selectedButtons.count == 3 {
            selectedButtons.removeAll()
            updateViewFromModel()
        }
        if selectedButtons.contains(sender) {
            sender.layer.borderWidth = 0.0
            if let buttonIndex = selectedButtons.firstIndex(of: sender) {
                selectedButtons.remove(at: buttonIndex)
            }
        } else {
            sender.layer.borderWidth = 3.0
            sender.layer.borderColor = UIColor.blue.cgColor
            selectedButtons.append(sender)
        }
    }
    
    private func checkIfSelectedButtonsFormASet() -> Bool {
        var selectedCardIndexes = [Int]()
        for button in selectedButtons {
            if let selectedCardIndex = cardButtons.firstIndex(of: button) {
                selectedCardIndexes.append(selectedCardIndex)
            }
        }
        
        return set.chooseCard(indexes: selectedCardIndexes)
    }
    
    private func updateViewFromModel() {
        for (index, button) in cardButtons.enumerated() {
            if index < set.cardsOnTable.count {
                let cardToDisplay = set.cardsOnTable[index]
                let cardFaceString = setCardTitle(card: cardToDisplay)
                button.setAttributedTitle(cardFaceString, for: .normal)
                button.layer.borderWidth = 0.0
                button.backgroundColor = .lightGray
                button.isEnabled = true
            } else {
                button.backgroundColor = .white
                button.layer.borderWidth = 0.0
                button.isEnabled = false
                button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
            }
        }
    }
    
    private func updateDrawButton() {
        if set.cardsOnTable.count == 24 || set.cardDeck.count == 0 {
            drawCardsButton.isEnabled = false
            drawCardsButton.backgroundColor = .gray
            drawCardsButton.setTitleColor(.black, for: .disabled)
        } else {
            drawCardsButton.isEnabled = true
            drawCardsButton.backgroundColor = .red
            drawCardsButton.setTitleColor(.white, for: .normal)
        }
    }
    
    private func resetButton() {
        for button in cardButtons{
            let nsAttributedString = NSAttributedString(string: "")
            button.setAttributedTitle(nsAttributedString, for: .normal)
            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    private func setCardTitle(card: Card) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: ModelToView.colors[card.color]!,
            .strokeWidth: ModelToView.strokeWidth[card.fill]!,
            .foregroundColor: ModelToView.colors[card.color]!.withAlphaComponent(ModelToView.alpha[card.fill]!)
        ]
        var cardTitle = ModelToView.shapes[card.shape]!
        switch card.number {
        case .two:
            cardTitle = "\(cardTitle) \(cardTitle)"
        case .three:
            cardTitle = "\(cardTitle) \(cardTitle) \(cardTitle)"
        default:
            break
        }
        
        return NSAttributedString(string: cardTitle, attributes: attributes)
    }
    
    struct ModelToView {
        static let shapes: [Card.Shape: String] = [.circle: "●", .triangle: "▲", .square: "■"]
        static let colors: [Card.Color: UIColor] = [.orange: .orange, .blue: .blue, .yellow: .yellow]
        static let alpha: [Card.Fill: CGFloat] = [.solid: 1.0, .empty: 0.5, .stripe: 0.25]
        static let strokeWidth: [Card.Fill: CGFloat] = [.solid: -5, .empty: 5, .stripe: -5]
    }
}

