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
        case stripe = "stripe"
        case empty = "empty"
        
        static let all = [Fill.solid, .stripe, .empty]
    }
    
    enum Shape: String {
        
        case square = "square"
        case triangle = "triangle"
        case circle = "circle"
        
        static let all = [Shape.square, .triangle, .circle]
    }
    
    enum Color: String {
        case orange = "orange"
        case blue = "blue"
        case yellow = "yellow"
        
        static let all = [Color.orange, .blue, .yellow]
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
