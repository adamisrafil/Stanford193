//
//  Card.swift
//  Set
//
//  Created by Adam Israfil on 1/12/20.
//  Copyright © 2020 Adam Israfil. All rights reserved.
//

import Foundation

struct Card: Equatable {
    
    var shape: Shape
    var color: Color
    var fill: Fill
    var number: Number
    
    enum Number: Int {
        
        case one
        case two
        case three
        
        static let all = [Number.one, .two, .three]
    }
    
    enum Fill: String {
        
        case solid = "solid"
        case striped = "striped"
        case outlined = "outlined"
        
        static let all = [Fill.solid, .striped, .outlined]
    }
    
    enum Shape: String {
        
        case squiggle = "squiggle"
        case diamond = "diamond"
        case oval = "oval"
        
        static let all = [Shape.squiggle, .diamond, .oval]
    }
    
    enum Color: String {
        case purple = "purple"
        case red = "red"
        case green = "green"
        
        static let all = [Color.purple, .red, .green]
    }
    
    init(color: Color, shape: Shape, number: Number, fill: Fill) {
        self.color = color
        self.shape = shape
        self.number = number
        self.fill = fill
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color &&
            lhs.fill == rhs.fill &&
            lhs.shape == rhs.shape &&
            lhs.number == rhs.number
    }
}
