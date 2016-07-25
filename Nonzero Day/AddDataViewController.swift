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
	
	var score = 1
    var data:[Int] = []
	var objective : Objective!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var count = 1
		while count < 50 {
            data.append(count)
            count += 1
        }
        scorePicker.dataSource = self
        scorePicker.delegate = self
		unitLabel.text = objective.singularNoun
		
		
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
        return data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		return String(data[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		print(String(row))
		if row == 0 {
			UIView.transitionWithView(unitLabel, duration: 0.25, options: [.TransitionCrossDissolve], animations: {
				self.unitLabel.text = self.objective.singularNoun
				}, completion: nil)
		} else {
			UIView.transitionWithView(unitLabel, duration: 0.25, options: [.TransitionCrossDissolve], animations: {
				self.unitLabel.text = self.objective.pluralNoun
				}, completion: nil)
			
		}
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if(segue.identifier == "confirmDataEntry"){
			score = data[scorePicker.selectedRowInComponent(0)]
		}
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}

}
