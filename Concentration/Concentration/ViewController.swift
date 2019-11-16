//
//  ViewController.swift
//  Concentration
//
//  Created by Adam Israfil on 11/14/19.
//  Copyright © 2019 Adam Israfil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    var flipCount = 0 {
        didSet{
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            let gameUpdate = game.chooseCard(at: cardNumber)
            updateViewFromModel()
            flipCount = gameUpdate.flipCountReturn
            score = gameUpdate.scoreReturn
        }
    }
    
    @IBAction func newGameStarted(_ sender: UIButton) {
        flipCount = 0
        score = 0
        //        startNewGame()
    }
    
    func startNewGame() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            var card = game.cards[index]
            card.isFaceUp = false
            card.isMatched = false
            button.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            button.setTitle("", for: UIControl.State.normal)
            button.isHidden = false
        }
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 0) : #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            }
        }
    }
    
    var themeDictionary = [
        "Sports" : ["⚽️","🏀","🏈","⚾️","🏓","🎾","🏐","🎱","🥏","🛹","🥅","🥌","🏂"],
        "Animals" : ["🐶","🐱","🐧","🦁","🐨","🦊","🐼","🐻","🐣","🐯","🙉","🐔","🐙"],
        "Face Emojis" : ["😀","😇","😂","🥰","😎","🤪","🧐","🥳","🤯","😱","😭","😧","🙁"],
        "Funny Emojis" : ["🤬","😈","👻","💩","🖕🏻","💪🏻","🤖","👀","🤮","🥴","🥶","💀","👽"],
        "Vehicles" : ["🚗","🛴","🚒","🛸","🛺","✈️","🚉","🏎","🚲","🚞","🚁","🛶","🦽"],
        "Signs" : ["🍏","🥑","🍆","🍑","🥩","🥓","🍗","🍕","🌮","🍔","🍒","🍟","🧀"]
    ]
    
    lazy var theme = themeDictionary.randomElement()!
    
    
    var emoji = [Int:String]()
    lazy var emojiChoices: [String] = theme.value
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
}
