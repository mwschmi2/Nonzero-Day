//
//  MarkerView.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 8/7/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit

class MarkerView: UIView {

	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet var contentView: UIView!
	

	/*override func drawRect(rect: CGRect) {
		print("Drawing MarkerView")
	}*/
	
	var objective : Objective!
	var score : Int = 0
	var date : String = ""
	
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initSubviews()
	}
	
	init(frame: CGRect, objective: Objective, score: Int, date: String) {
		super.init(frame: frame)
		self.objective = objective
		self.score = score
		self.date = date
		initSubviews()
	}
	func initSubviews() {
		let nib = UINib.init(nibName: "MarkerView", bundle: nil)
		nib.instantiateWithOwner(self, options: nil)
		
		scoreLabel.text = String(score)
		dateLabel.text = date
		
		scoreLabel.sizeToFit()
		dateLabel.sizeToFit()
		
		let width = max(scoreLabel.frame.width, dateLabel.frame.width) + 10
		let height = scoreLabel.frame.height + 5 + dateLabel.frame.height
		contentView.frame = CGRectMake(-width/2, 0, width, height)
		addSubview(contentView)
		
	
		//custom configuration
		contentView.backgroundColor = objective.accentColor
		contentView.layer.cornerRadius = 5
		
		
		
	}
}
