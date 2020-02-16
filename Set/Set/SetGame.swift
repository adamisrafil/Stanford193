//
//  Set.swift
//  Set
//
//  Created by Adam Israfil on 1/12/20.
//  Copyright © 2020 Adam Israfil. All rights reserved.
//

import Foundation

struct SetGame {
    
    private(set) var cardDeck = [Card]()
    
    var numberOfCardsInDeck: Int {
        return cardDeck.count
    }
    
    private(set) var cardsOnTable = [Card]()
    private var selectedCards = [Card]()
    private var cardsMatched = [Card]()
    
    mutating func chooseCard(indexes: [Int]) -> Bool {
        for index in indexes {
            if index < cardsOnTable.count {
                selectedCards.append(cardsOnTable[index])
            }
        }
        
        if isMatchingSet(cardsToCheck: selectedCards) {
            updateGameForSetFoundAt(indexes: indexes)
            return true
        } else {
            selectedCards.removeAll()
            return false
        }
    }
    
    mutating func isMatchingSet(cardsToCheck: [Card]) -> Bool {
        let color = Set(cardsToCheck.map{ $0.color }).count
        let shape = Set(cardsToCheck.map{ $0.shape }).count
        let number = Set(cardsToCheck.map{ $0.number }).count
        let fill = Set(cardsToCheck.map{ $0.fill }).count
        
        return color != 2 && shape != 2 && number != 2 && fill != 2
    }
    
    private mutating func updateGameForSetFoundAt(indexes: [Int]) {
        for card in selectedCards {
            if let cardIndexToRemove = selectedCards.firstIndex(of: card) {
                if cardDeck.count > 0 { cardDeck.remove(at: cardIndexToRemove) }
            }
        }
        
        for card in selectedCards {
            cardsMatched.append(card)
            if let selectedCardIndex = cardsOnTable.firstIndex(of: card) {
                if cardDeck.count > 0 {
                    cardsOnTable.insert(cardDeck.removeFirst(), at: selectedCardIndex)
                    cardsOnTable.remove(at: selectedCardIndex + 1)
                } else {
                    cardsOnTable.remove(at: selectedCardIndex)
                }
            }
            if let cardIndexToRemove = selectedCards.firstIndex(of: card) {
                selectedCards.remove(at: cardIndexToRemove)
            }
        }
        
        if cardsOnTable.count == 0 {
            self = SetGame()
        }
    }
    
    mutating func drawThreeCards() {
        if cardDeck.count > 0 {
            for _ in 1...3 {
                cardsOnTable += [cardDeck.remove(at: cardDeck.randomIndex)]
            }
        }
        selectedCards.removeAll()
    }
    
    mutating func drawCardsForNewGame() {
        if cardDeck.count > 0 {
            for _ in 0..<12 {
                cardsOnTable += [cardDeck.remove(at: cardDeck.randomIndex)]
            }
        }
    }
    
    private mutating func redrawShuffledCards() -> [Card] {
        if cardDeck.count > 0 {
            var drawCards = [Card]()
            for _ in 1...3 {
                drawCards.append(cardDeck.remove(at: cardDeck.randomIndex))
            }
            return drawCards
        }
        return []
    }
    
    mutating func shuffleCardsOnTable() {
        let numberOfCardsOnTable = cardsOnTable.count / 3
        for card in cardsOnTable {
            cardDeck.append(card)
        }
        cardsOnTable.removeAll()
        for _ in 1...numberOfCardsOnTable {
            cardsOnTable += redrawShuffledCards()
        }
    }
    
    init() {
        for color in Card.Color.all {
            for shape in Card.Shape.all {
                for number in Card.Number.all {
                    for fill in Card.Fill.all {
                        let card = Card(color: color, shape: shape, number: number, fill: fill)
                        cardDeck += [card]
                    }
                }
            }
        }
        cardDeck.shuffle()
        
        drawCardsForNewGame()
    }
}

extension Array {
    
    var randomIndex: Int {
        return Int(arc4random_uniform(UInt32(count - 1)))
    }
}
