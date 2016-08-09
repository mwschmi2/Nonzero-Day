//
//  SettingsViewController.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 7/6/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	
	@IBAction func deleteObjective(sender: AnyObject) {
		let alert = UIAlertController(title: "Are you sure you want to delete this objective?", message: "All data will be lost, there is no way to undo this action!", preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: {
			(action) -> Void in
			self.dismissViewControllerAnimated(true, completion: nil)
			self.rootViewController.deleteObjective(self.objective)

		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
		
		
	}
	
	var objective : Objective!
	
	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var titleField: UITextField!
	@IBOutlet weak var unitsField: UITextField!
	@IBOutlet weak var colorPicker: UICollectionView!
	@IBOutlet weak var deleteButton: UIButton!
	
	var colorPickerDelegate : ColorPicker!
	
	var rootViewController : ViewController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = objective.color
		doneButton.tintColor = objective.accentColor
		deleteButton.tintColor = objective.accentColor
		
		var index = 0
		for i in 0..<colors.count {
			if objective.color.isRoughlyEqual(colors[i]){
				index = i
			}
		}
	
		let selectedIndex = NSIndexPath(forRow: index, inSection: 0)
		
		colorPickerDelegate = ColorPicker(withView: view, withSelectedIndex: selectedIndex, withAccentObjects: [doneButton, deleteButton], withRootViewController : rootViewController)
		colorPicker.delegate = colorPickerDelegate
		colorPicker.dataSource = colorPickerDelegate
		colorPicker.backgroundColor = UIColor.clearColor()
		
	}
	
	
}
