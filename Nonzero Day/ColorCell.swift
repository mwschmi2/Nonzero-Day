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
		let center = view.center
		let strokeWidth = CGFloat(2)
		let radius = view.frame.size.width/2 - strokeWidth
		
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
