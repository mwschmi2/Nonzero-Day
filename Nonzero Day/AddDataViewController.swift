//
//  ObjectiveViewController.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 6/28/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit

class AddDataViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    
	@IBOutlet weak var unitLabel: UILabel!
	
	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var scorePicker: UIPickerView!
	
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var unitLabelSpacer: NSLayoutConstraint!
	
	var score = 1
	var objective : Objective!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
        scorePicker.dataSource = self
        scorePicker.delegate = self
		scorePicker.showsSelectionIndicator = false
		unitLabel.text = objective.singularNoun
		view.backgroundColor = objective.color
		confirmButton.tintColor = objective.accentColor
		cancelButton.tintColor = objective.accentColor
		
		
		questionLabel.text = "How much did you " + objective.verb + " today?"
		
	}
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2000
    }
	
	func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		return NSAttributedString(string: String(row + 1), attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
	}
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if row == 0 {
			UIView.transitionWithView(unitLabel, duration: 0.25, options: [.TransitionCrossDissolve], animations: {
				self.unitLabel.text = self.objective.singularNoun
				self.unitLabelSpacer.constant = 20
				}, completion: nil)
		} else {
			UIView.transitionWithView(unitLabel, duration: 0.25, options: [.TransitionCrossDissolve], animations: {
				self.unitLabel.text = self.objective.pluralNoun
				if row < 10 {
					self.unitLabelSpacer.constant = 25
				} else if row < 100 {
					self.unitLabelSpacer.constant = 30
				} else if row < 1000 {
					self.unitLabelSpacer.constant = 35
				} else {
					self.unitLabelSpacer.constant = 40
				}
				}, completion: nil)
		}
    }
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if(segue.identifier == "confirmDataEntry"){
			print("[AddDataViewController] Objective : " + objective.title)
			objective.addTodayData(withContext: objective.managedObjectContext!, withScore: scorePicker.selectedRowInComponent(0) + 1)
		}
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}

}
