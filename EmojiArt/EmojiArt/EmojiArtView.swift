//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Adam Israfil on 2/27/20.
//  Copyright © 2020 Adam Israfil. All rights reserved.
//

import UIKit

class EmojiArtView: UIView {

    var backgroundImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }

}
