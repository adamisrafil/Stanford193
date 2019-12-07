//
//  Concentration.swift
//  Concentration
//
//  Created by Adam Israfil on 11/15/19.
//  Copyright © 2019 Adam Israfil. All rights reserved.
//

import Foundation

struct Concentration {
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var score = 0
    
    var flipCount = 0
    
    mutating func chooseCard(at index: Int) -> (scoreReturn: Int, flipCountReturn: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
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
        assert(numberOfPairsOfCards > 0, "Concentration.init(numberOfPairsOfCards: \(numberOfPairsOfCards): you must have at least 1 pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

extension Collection {
    
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
