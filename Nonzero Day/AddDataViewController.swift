//
//  ObjectiveViewController.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 6/28/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit

class AddDataViewController : UIViewController {
	var objective : Objective! 
	
	override func viewDidLoad() {
		super.viewDidLoad()
		var vc : AddDataViewController
		switch objective.entryStyle {
		
		case .scroll:
			vc = storyboard!.instantiateViewControllerWithIdentifier("AddDataViewControllerScroll") as! AddDataViewControllerScroll
			
		case .numpad:
			vc = storyboard!.instantiateViewControllerWithIdentifier("AddDataViewControllerNumpad") as! AddDataViewControllerNumpad
		}
		
		vc.objective = objective
		addChildViewController(vc)
		view.addSubview(vc.view)
		vc.didMoveToParentViewController(self)
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
}

class AddDataViewControllerScroll: AddDataViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    
	@IBOutlet weak var unitLabel: UILabel!
	
	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var scorePicker: UIPickerView!
	
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var unitLabelSpacer: NSLayoutConstraint!
	
	var score = 1
	
    
	
    override func viewDidLoad() {
        //super.viewDidLoad()
		
		print("Makes it here?")
		
        scorePicker.dataSource = self
        scorePicker.delegate = self
		scorePicker.showsSelectionIndicator = false
		unitLabel.text = objective.singularNoun
		view.backgroundColor = objective.color
		confirmButton.tintColor = objective.accentColor
		cancelButton.tintColor = objective.accentColor
		
		
		questionLabel.text = "How much did you " + objective.verb + " today?"
		
	}
    
    /*
	@IBAction func directButton(sender: AnyObject) {
		let alert = UIAlertController(title: objective.title + " Data", message: "How much did you " + objective.verb + " today?", preferredStyle: .Alert)
		var scoreField : UITextField?
		alert.addTextFieldWithConfigurationHandler({
			(textField) -> Void in
			scoreField = textField
			let row = self.scorePicker.selectedRowInComponent(0)
			if row == 0 {
				scoreField?.placeholder = String(row + 1) + " " + self.objective.singularNoun
			} else {
				scoreField?.placeholder = String(row + 1) + " " + self.objective.pluralNoun
			}
			textField.keyboardType = .NumberPad
		})
		
		alert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: {
			(action) -> Void in
			if let textField = scoreField {
				self.scorePicker.selectRow(Int(textField.text!)! - 1, inComponent: 0, animated: true)
				self.selectRow(Int(textField.text!)! - 1)
			}
		}))
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		
		self.presentViewController(alert, animated: true, completion: {})
	}*/

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
		selectRow(row)

    }
	
	func selectRow(row: Int) {
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
		if segue.identifier == "confirmDataEntry" {
			print("[AddDataViewController] Objective : " + objective.title)
			objective.addTodayData(withContext: objective.managedObjectContext!, withScore: scorePicker.selectedRowInComponent(0) + 1)
		}
	}
	
	

}

class AddDataViewControllerNumpad : AddDataViewController {
	
	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!

	@IBOutlet weak var textField: UITextField!
	
	@IBOutlet weak var unitLabel: UILabel!
	@IBOutlet weak var cancelConstraint: NSLayoutConstraint!
	@IBOutlet weak var confirmConstraint: NSLayoutConstraint!
	override func viewDidLoad() {
		

		view.backgroundColor = objective.color
		confirmButton.tintColor = objective.accentColor
		cancelButton.tintColor = objective.accentColor
		questionLabel.text = "How much did you " + objective.verb + " today?"
		unitLabel.text = objective.pluralNoun
		setUpObserver()
		textField.becomeFirstResponder()
		
		
	}
	
	private func setUpObserver() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
	}
	
	@objc private func keyboardWillShow(notification:NSNotification) {
		
		let userInfo:NSDictionary = notification.userInfo!
		let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
		let keyboardRectangle = keyboardFrame.CGRectValue()
		let keyboardHeight = keyboardRectangle.height
		cancelConstraint.constant = keyboardHeight + 20
		confirmConstraint.constant = keyboardHeight + 20
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		textField.resignFirstResponder()
		if segue.identifier == "confirmDataEntry" {
			objective.addTodayData(withContext: objective.managedObjectContext!, withScore: Int(textField.text!)!)
		}
	}
	
}


