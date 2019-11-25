//
//  Concentration.swift
//  Concentration
//
//  Created by Adam Israfil on 11/15/19.
//  Copyright © 2019 Adam Israfil. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var score = 0
    
    var flipCount = 0
    
    func chooseCard(at index: Int) -> (scoreReturn: Int, flipCountReturn: Int) {
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    if cards[matchIndex].hasBeenFliped && cards[index].hasBeenFliped {
                        score -= 2
                    }
                    else if cards[matchIndex].hasBeenFliped || cards[index].hasBeenFliped{
                        score -= 1
                    }
                    else {
                        cards[matchIndex].hasBeenFliped = true
                        cards[index].hasBeenFliped = true
                    }
                }
                cards[index].isFaceUp = true
            }
            else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        return (scoreReturn: score, flipCountReturn: flipCount)
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}
