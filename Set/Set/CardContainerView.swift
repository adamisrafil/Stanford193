//
//  CardContainerView.swift
//  Set
//
//  Created by Adam Israfil on 2/1/20.
//  Copyright © 2020 Adam Israfil. All rights reserved.
//

import UIKit

class CardContainerView: UIView {
    
    private(set) var cardButtons = [SetCardButton]()
    
    private(set) var grid = Grid(layout: Grid.Layout.aspectRatio(3/2))
    
    private var centeredRect: CGRect {
        get {
            return CGRect(x: bounds.size.width * 0.025, y: bounds.size.height * 0.025, width: bounds.size.width * 0.95, height: bounds.size.height * 0.95)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        grid.frame = centeredRect
        
        for (i, button) in cardButtons.enumerated() {
            if let frame = grid[i] {
                button.frame = frame
                button.layer.cornerRadius = 10
                button.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                button.layer.borderWidth = 0.5
            }
        }
    }
    
    func addCardButtons(numberOfCardButtonsToAdd: Int = 3) {
        let cardButtonsToAdd = (0..<numberOfCardButtonsToAdd).map { _ in SetCardButton() }
        
        for button in cardButtonsToAdd {
            addSubview(button)
        }
        
        cardButtons += cardButtonsToAdd
        
        grid.cellCount = cardButtons.count
        
        setNeedsLayout()
    }
    
    func removeCardButtons(numberOfCardButtonsToRemove: Int) {
        guard cardButtons.count >= numberOfCardButtonsToRemove else { return }
        
        for cardButton in 0..<numberOfCardButtonsToRemove {
            let button = cardButtons[cardButton]
            button.removeFromSuperview()
        }
        
        cardButtons.removeSubrange(0..<numberOfCardButtonsToRemove)
        grid.cellCount = cardButtons.count
        
        setNeedsLayout()
    }
    
    func removeAllCardsFromTable() {
        cardButtons = []
        grid.cellCount = 0
        for subview in subviews {
            subview.removeFromSuperview()
        }
        setNeedsLayout()
    }
}

extension UIView {
    
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
