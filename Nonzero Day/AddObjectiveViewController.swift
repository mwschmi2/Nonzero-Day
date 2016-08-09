//
//  AddObjectiveViewController.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 7/7/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit



class AddObjectiveViewController: PageContentController, UIPickerViewDataSource, UIPickerViewDelegate {

	
	@IBAction func confirmButton(sender: AnyObject) {
		
		let type = types[typePicker.selectedRowInComponent(0)]
		let units = types[typePicker.selectedRowInComponent(0)].units[nounPicker.selectedRowInComponent(0)]
		let color = colors[colorPickerDelegate.selectedIndex.row]
		
		let objective = Objective.createInManagedObjectContext(rootViewController.managedObjectContext, withType: type, withUnits: units, withColor: color, withIndex: pageIndex)
		print("Adding objective : " + objective.title)
		pageIndex! += 1
		
		rootViewController.objectives.append(objective)
		
		rootViewController.setupPageController(rootViewController.objectives.count - 1, forward: false)
	}
	
	
	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var colorPicker: UICollectionView!
	
	@IBOutlet weak var topLabel: UILabel!
	@IBOutlet weak var typePicker: UIPickerView!
	@IBOutlet weak var nounPicker: UIPickerView!


	var colorPickerDelegate : ColorPicker!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		
		let index = arc4random_uniform(UInt32(colors.count))
		view.backgroundColor = colors[Int(index)]
		backgroundColor = view.backgroundColor
		confirmButton.tintColor = getComplementColor(view.backgroundColor!)
		let selectedIndex = NSIndexPath(forRow: Int(index), inSection: 0)
		
		colorPickerDelegate = ColorPicker(withView: view, withSelectedIndex: selectedIndex, withAccentObjects: [confirmButton], withRootViewController: rootViewController)
		colorPicker.delegate = colorPickerDelegate
		colorPicker.dataSource = colorPickerDelegate
		colorPicker.backgroundColor = UIColor.clearColor()
		

		
		
		typePicker.dataSource = self
		typePicker.delegate = self
		typePicker.tag = 0
		
		
		nounPicker.delegate = self
		nounPicker.dataSource = self
		nounPicker.tag = 1

    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		backgroundColor = colors[colorPickerDelegate.selectedIndex.row]
		view.backgroundColor = colors[colorPickerDelegate.selectedIndex.row]
	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView.tag == 0 {
			//type picker view
			return types.count
		} else {
			let currentTypeIndex = typePicker.selectedRowInComponent(0)
			return types[currentTypeIndex].units.count
		}
	}
	

	
	func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		var string : String
		if pickerView.tag == 0 {
			//type picker view
			string = types[row].title
		} else {
			let currentTypeIndex = typePicker.selectedRowInComponent(0)
			string = types[currentTypeIndex].units[row].pluralNoun
		}
		
		return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if pickerView.tag == 0 {
			UIView.transitionWithView(nounPicker, duration: 0.25, options: [.TransitionCrossDissolve], animations: {
				self.nounPicker.reloadComponent(0)
				}, completion: nil)
		}
	}

	
	
	
	

}
