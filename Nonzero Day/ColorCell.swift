//
//  ColorCell.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 7/18/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
	
	@IBOutlet weak var view: UIView!
	var color : UIColor! 
	
	func drawCell(selected : Bool)  {
		
		view.backgroundColor = UIColor.clearColor()
		//draw circle
		if layer.sublayers?.count > 1 {
			layer.sublayers?.removeLast()
		}
		
		let center = CGPoint(x: frame.size.width/2, y: frame.size.width/2)
		let strokeWidth = CGFloat(2)
		let radius = frame.size.width/2 - strokeWidth
		//print("Drawing circle with cellSize: " + String(view.frame.width))
		
		let circlePath = UIBezierPath(arcCenter: center,
		                              radius: radius,
		                              startAngle: CGFloat(0),
		                              endAngle: CGFloat(M_PI * 2),
		                              clockwise: true)
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = circlePath.CGPath
		shapeLayer.fillColor = color.CGColor
		if selected {
			shapeLayer.strokeColor = UIColor.whiteColor().CGColor
		} else {
			shapeLayer.strokeColor = UIColor.blackColor().CGColor
		}
		shapeLayer.lineWidth = strokeWidth
		layer.addSublayer(shapeLayer)
	}
	
	
}
