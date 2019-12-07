//
//  ViewController.swift
//  Concentration
//
//  Created by Adam Israfil on 11/14/19.
//  Copyright © 2019 Adam Israfil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet{
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    private(set) var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme()
        setup()
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            let gameUpdate = game.chooseCard(at: cardNumber)
            updateViewFromModel()
            flipCount = gameUpdate.flipCountReturn
            score = gameUpdate.scoreReturn
        }
    }
    
    @IBAction private func newGameStarted(_ sender: UIButton) {
        flipCount = 0
        score = 0
        setup()
    }
    
    private func setup() {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        updateViewFromModel()
        setupTheme()
    }
    
    private func updateViewFromModel() {
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
    
    private var theme: [[String]] = []
    private var randomTheme: [String] = []
    private var animals: [String] = []
    private var sports: [String] = []
    private var faceEmojis: [String] = []
    private var vehicles: [String] = []
    private var funnyEmojis: [String] = []
    private var foods: [String] = []
    private var emoji = [Card: String]()
    
    private func setupTheme() {
        sports = ["⚽️","🏀","🏈","⚾️","🏓","🎾","🏐","🎱","🥏","🛹","🥅","🥌","🏂"]
        animals = ["🐶","🐱","🐧","🦁","🐨","🦊","🐼","🐻","🐣","🐯","🙉","🐔","🐙"]
        faceEmojis = ["😀","😇","😂","🥰","😎","🤪","🧐","🥳","🤯","😱","😭","😧","🙁"]
        funnyEmojis = ["🤬","😈","👻","💩","🖕🏻","💪🏻","🤖","👀","🤮","🥴","🥶","💀","👽"]
        vehicles = ["🚗","🛴","🚒","🛸","🛺","✈️","🚉","🏎","🚲","🚞","🚁","🛶","🦽"]
        foods = ["🍏","🥑","🍆","🍑","🥩","🥓","🍗","🍕","🌮","🍔","🍒","🍟","🧀"]
        theme = [sports, animals, faceEmojis, funnyEmojis, vehicles, foods]
        randomTheme = getRandomTheme()
    }
    
    private func getRandomTheme() -> [String] {
        guard let index = theme.randomElement() else { return theme[0] }
        return index
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil {
            emoji[card] = randomTheme.remove(at: randomTheme.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
