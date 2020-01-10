//
//  ViewController.swift
//  PlayingCard
//
//  Created by Adam Israfil on 1/10/20.
//  Copyright © 2020 Adam Israfil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()

    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...10 {
            if let card = deck.draw() {
                print("\(card)")
            }
        }
    }
}

