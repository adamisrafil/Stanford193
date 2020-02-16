//
//  SetCardButton.swift
//  Set
//
//  Created by Adam Israfil on 2/3/20.
//  Copyright © 2020 Adam Israfil. All rights reserved.
//

import UIKit

class SetCardButton: UIButton {

    enum cardSymbolShape {
        case squiggle
        case diamond
        case oval
    }
    
    enum cardColor {
        case red
        case green
        case purple
        
        func get() -> UIColor {
            switch self {
            case .red:
                return .red
            case .green:
                return .green
            case .purple:
                return .purple
            }
        }
    }
    
    enum cardSymbolShading {
        case solid
        case striped
        case outlined
    }
    
    var symbolShape: cardSymbolShape? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var numberOfSymbols = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var color: cardColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var symbolShading: cardSymbolShading? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var path: UIBezierPath?
    
    private var drawableRect: CGRect {
        let drawableWidth = frame.size.width * 0.80
        let drawableHeight = frame.size.height * 0.90
        
        return CGRect(x: frame.size.width * 0.1, y: frame.size.height * 0.05, width: drawableWidth, height: drawableHeight)
    }
    
    private var shapeHorizontalMargin: CGFloat {
      return drawableRect.width * 0.05
    }
    
    private var shapeVerticalMargin: CGFloat {
      return drawableRect.height * 0.05 + drawableRect.origin.y
    }
    
    private var shapeWidth: CGFloat {
      return (drawableRect.width - (2 * shapeHorizontalMargin)) / 3
    }
    
    private var shapeHeight: CGFloat {
      return drawableRect.size.height * 0.9
    }
    
    private var drawableCenter: CGPoint {
      return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    override func draw(_ rect: CGRect) {
        guard let shape = symbolShape else { return }
        guard let color = color?.get() else { return }
        guard let shading = symbolShading else { return }
        
        switch shape {
        case .squiggle:
            drawSquiggles(numberOfSquiggles: numberOfSymbols)
        case .diamond:
            drawDiamonds(numberOfDiamonds: numberOfSymbols)
        case .oval:
            drawOvals(numberOfOvals: numberOfSymbols)
        }
        
        path!.lineCapStyle = .round
        
        switch shading {
        case .solid:
            color.setFill()
            path!.fill()
        case .outlined:
            color.setStroke()
            path!.lineWidth = 1
            path!.stroke()
        case .striped:
            path!.lineWidth = 0.01 * frame.size.width
            color.setStroke()
            path!.stroke()
            path!.addClip()
            
            var currentX: CGFloat = 0
            
            let stripedPath = UIBezierPath()
            stripedPath.lineWidth = 0.005 * frame.size.width
            
            while currentX < frame.size.width {
                stripedPath.move(to: CGPoint(x: currentX, y: 0))
                stripedPath.addLine(to: CGPoint(x: currentX, y: frame.size.height))
                currentX += 0.03 * frame.size.width
            }
            
            color.setStroke()
            stripedPath.stroke()
            
            break
        }
    }
    
    private func drawSquiggles(numberOfSquiggles: Int) {
        let path = UIBezierPath()
        let allSquigglesWidth = CGFloat(numberOfSquiggles) * shapeWidth + CGFloat(numberOfSquiggles - 1) * shapeHorizontalMargin
        let beginX = (frame.size.width - allSquigglesWidth) / 2
        
        for squiggle in 0..<numberOfSquiggles {
            let currentShapeX = beginX + (shapeWidth * CGFloat(squiggle)) + (CGFloat(squiggle) * shapeHorizontalMargin)
            let currentShapeY = shapeVerticalMargin
            let curveXOffset = shapeWidth * 0.35
            
            path.move(to: CGPoint(x: currentShapeX, y: currentShapeY))

            path.addCurve(to: CGPoint(x: currentShapeX, y: currentShapeY + shapeHeight),
                          controlPoint1: CGPoint(x: currentShapeX + curveXOffset, y: currentShapeY + shapeHeight / 3),
                          controlPoint2: CGPoint(x: currentShapeX - curveXOffset, y: currentShapeY + (shapeHeight / 3) * 2))
            
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY + shapeHeight))
            
            path.addCurve(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY),
                          controlPoint1: CGPoint(x: currentShapeX + shapeWidth - curveXOffset, y: currentShapeY + (shapeHeight / 3) * 2),
                          controlPoint2: CGPoint(x: currentShapeX + shapeWidth + curveXOffset, y: currentShapeY + shapeHeight / 3))
            
            path.addLine(to: CGPoint(x: currentShapeX, y: currentShapeY))
        }
        
        self.path = path
    }
    
    private func drawOvals(numberOfOvals: Int) {
      let allOvalsWidth = CGFloat(numberOfOvals) * shapeWidth + CGFloat(numberOfOvals - 1) * shapeHorizontalMargin
      let beginX = (frame.size.width - allOvalsWidth) / 2
      path = UIBezierPath()
      
      for oval in 0..<numberOfOvals {
        let currentShapeX = beginX + (shapeWidth * CGFloat(oval)) + (CGFloat(oval) * shapeHorizontalMargin)

        path!.append(UIBezierPath(roundedRect: CGRect(x: currentShapeX,
                                                      y: shapeVerticalMargin,
                                                      width: shapeWidth,
                                                      height: shapeHeight),
                                  cornerRadius: shapeWidth))
      }
    }
    
    private func drawDiamonds(numberOfDiamonds: Int) {
      let allDiamondsWidth = CGFloat(numberOfDiamonds) * shapeWidth + CGFloat(numberOfDiamonds - 1) * shapeHorizontalMargin
      let beginX = (frame.size.width - allDiamondsWidth) / 2
      
      let path = UIBezierPath()
      
      for diamond in 0..<numberOfDiamonds {
        let currentShapeX = beginX + (shapeWidth * CGFloat(diamond)) + (CGFloat(diamond) * shapeHorizontalMargin)
        
        path.move(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin))
        path.addLine(to: CGPoint(x: currentShapeX, y: drawableCenter.y))
        path.addLine(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin + shapeHeight))
        path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: drawableCenter.y))
        path.addLine(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin))
      }
      
      self.path = path
    }

}
