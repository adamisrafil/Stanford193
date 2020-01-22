//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Adam Israfil on 1/10/20.
//  Copyright © 2020 Adam Israfil. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible {
    
    var description: String { return "\(rank)\(suit)"}
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible {
        case hearts = "♥️"
        case spades = "♠️"
        case clubs = "♣️"
        case diamonds = "♦️"
        
        static var all = [Suit.hearts, .clubs, .diamonds, .spades]
        
        var description: String { return rawValue }
    }
    
    enum Rank: CustomStringConvertible {
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int {
            switch self {
            case .ace:
                return 1
            case .face(let kind) where kind == "J":
                return 11
            case .face(let kind) where kind == "Q":
                return 12
            case .face(let kind) where kind == "K":
                return 13
            case .numeric(let pips):
                return pips
            default:
                return 0
            }
        }
        
        static var all: [Rank] {
            var allRanks: [Rank] = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [Rank.face("J"), .face("Q"), .face("K")]
            return allRanks
        }
        
        var description: String {
            switch self {
            case .ace: return "A"
            case .numeric(let pips): return String(pips)
            case .face(let kind): return kind
            }
        }
    }
}
