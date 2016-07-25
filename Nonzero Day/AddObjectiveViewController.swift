//
//  AddObjectiveViewController.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 7/7/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit

extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(netHex:Int) {
		self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
	}
}

class AddObjectiveViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, PageContentController, UICollectionViewDelegate, UICollectionViewDataSource{

	
	@IBAction func confirmButton(sender: AnyObject) {
		let objective = Objective(withType: types[typePicker.selectedRowInComponent(0)], withUnits: types[typePicker.selectedRowInComponent(0)].units[nounPicker.selectedRowInComponent(0)], withColor: colors[selectedIndex.row % colors.count])
		objectiveData.append(objective)
		let startingViewController = rootViewController.viewControllerAtIndex(objectiveData.count - 1)
		let viewControllers:[UIViewController] = [startingViewController!]
		rootViewController.pageViewController?.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
		rootViewController.refreshPageControl(objectiveData.count - 1)

	}
	
	
	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var colorPicker: UICollectionView!
	
	@IBOutlet weak var typePicker: UIPickerView!
	@IBOutlet weak var nounPicker: UIPickerView!
	var pageIndex : Int {
		return objectiveData.count
	}
	
	var rootViewController : ViewController!
	
	var selectedIndex : NSIndexPath!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		typePicker.dataSource = self
		typePicker.delegate = self
		typePicker.tag = 0
		
		
		nounPicker.delegate = self
		nounPicker.dataSource = self
		nounPicker.tag = 1
		
		colorPicker.delegate = self
		colorPicker.dataSource = self
		colorPicker.backgroundColor = UIColor.clearColor()

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
	
	/*func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView.tag == 0 {
			//type picker view
			return types[row].title
		} else {
			let currentTypeIndex = typePicker.selectedRowInComponent(0)
			return types[currentTypeIndex].units[row].pluralNoun
		}
	}*/
	
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
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 8
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ColorCell", forIndexPath: indexPath) as! ColorCell
		cell.color = colors[indexPath.row % colors.count]
		cell.drawCell(false)
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		//deselect original cell
		var oldColor = view.backgroundColor
		if(selectedIndex != nil){
			let oldCell = collectionView.cellForItemAtIndexPath(selectedIndex) as! ColorCell
			oldCell.color = colors[selectedIndex.row % colors.count]
			UIView.transitionWithView(oldCell, duration: 0.25, options: [.TransitionCrossDissolve], animations: {
				oldCell.drawCell(false)
				}, completion: nil)
			oldColor = oldCell.color
		}
		
		selectedIndex = indexPath
		
		let newCell = collectionView.cellForItemAtIndexPath(selectedIndex) as! ColorCell
		newCell.color = colors[selectedIndex.row % colors.count]
		UIView.transitionWithView(newCell, duration: 0.25, options: [.TransitionCrossDissolve], animations: {
			newCell.drawCell(true)
			}, completion: nil)
		
		
		changeBackgroundColor(fromColor: oldColor!, toColor: newCell.color)
		
	}
	
	func changeBackgroundColor(fromColor start : UIColor, toColor end : UIColor) {
		
		print("startColor: " + String(start) + " endColor: " + String(end))
		var sRed, sGreen, sBlue : CGFloat
		sRed = 0.0
		sGreen = 0.0
		sBlue = 0.0
		start.getRed(&sRed, green: &sGreen, blue: &sBlue, alpha: nil)
		
		var eRed, eGreen, eBlue : CGFloat
		eRed = 0.0
		eGreen = 0.0
		eBlue = 0.0
		end.getRed(&eRed, green: &eGreen, blue: &eBlue, alpha: nil)
		
		let steps = 50
		let timeStep = 1.0/Double(steps)
		let redSlope = (eRed - sRed)/CGFloat(steps)
		let greenSlope = (eGreen - sGreen)/CGFloat(steps)
		let blueSlope = (eBlue - sBlue)/CGFloat(steps)

		UIView.animateKeyframesWithDuration(1.5, delay: 0.0, options: [.AllowUserInteraction], animations: {
			for i in 0...50 {
				let time = Double(i) * timeStep
				let newColor = UIColor(red: sRed + redSlope * CGFloat(i),
					green: sGreen + greenSlope * CGFloat(i),
					blue: sBlue + blueSlope * CGFloat(i),
					alpha: 1)
				UIView.addKeyframeWithRelativeStartTime(time, relativeDuration: timeStep, animations: {
					self.view.backgroundColor = newColor
					print("added keyframe #" + String(i) + " with time " + String(time) + " with color " + String(newColor))
				})
			}
			}, completion: nil)
		print("finished animating")
	}
	
	
	
	

}
