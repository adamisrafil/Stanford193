//
//  ConcentrationViewController.swift
//  Concentration
//
//  Created by Adam Israfil on 11/14/19.
//  Copyright © 2019 Adam Israfil. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (visibleCardButtons.count + 1) / 2
    }
    
    private func updateFlipCountLabel() {
        let attributedString = NSAttributedString(string: traitCollection.verticalSizeClass == .compact ? "Flips: \n\(flipCount)" : "Flips: \(flipCount)"
        )
        flipCountLabel.attributedText = attributedString
    }
    
    private(set) var flipCount = 0 {
        didSet{
            updateFlipCountLabel()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFlipCountLabel()
        updateScoreLabel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    
    private func updateScoreLabel() {
        let attributedString = NSAttributedString(string: traitCollection.verticalSizeClass == .compact ? "Score: \n\(score)" : "Score: \(score)"
        )
        scoreLabel.attributedText = attributedString
    }
    
    private(set) var score = 0 {
        didSet {
            updateScoreLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTheme()
        setup()
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter {
            !$0.superview!.isHidden
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = visibleCardButtons.firstIndex(of: sender) {
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
//        setupTheme()
    }
    
    private func updateViewFromModel() {
        if visibleCardButtons != nil {
            for index in visibleCardButtons.indices {
                let button = visibleCardButtons[index]
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
    }
    
    private lazy var randomThemeOptions: [[String]] = setupTheme()
    private var animals: [String] = []
    private var sports: [String] = []
    private var faceEmojis: [String] = []
    private var vehicles: [String] = []
    private var funnyEmojis: [String] = []
    private var foods: [String] = []
    private var emoji = [Card: String]()
    private lazy var randomTheme: [String] = getRandomTheme()
    
    var theme: [String]? {
        didSet {
            randomTheme = theme ?? getRandomTheme()
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    private func setupTheme() -> [[String]] {
        sports = ["⚽️","🏀","🏈","⚾️","🏓","🎾","🏐","🎱","🥏","🛹","🥅","🥌","🏂"]
        animals = ["🐶","🐱","🐧","🦁","🐨","🦊","🐼","🐻","🐣","🐯","🙉","🐔","🐙"]
        faceEmojis = ["😀","😇","😂","🥰","😎","🤪","🧐","🥳","🤯","😱","😭","😧","🙁"]
        funnyEmojis = ["🤬","😈","👻","💩","🖕🏻","💪🏻","🤖","👀","🤮","🥴","🥶","💀","👽"]
        vehicles = ["🚗","🛴","🚒","🛸","🛺","✈️","🚉","🏎","🚲","🚞","🚁","🛶","🦽"]
        foods = ["🍏","🥑","🍆","🍑","🥩","🥓","🍗","🍕","🌮","🍔","🍒","🍟","🧀"]
        randomThemeOptions = [sports, animals, faceEmojis, funnyEmojis, vehicles, foods]
        return randomThemeOptions
    }
    
    func getRandomTheme() -> [String] {
        guard let index = randomThemeOptions.randomElement() else { return randomThemeOptions[0] }
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
