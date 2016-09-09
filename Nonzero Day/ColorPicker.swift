//
//  ColorPicker.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 7/31/16.
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
	
	func isRoughlyEqual(otherColor : UIColor) -> Bool{
		let minVariance : CGFloat = 0.0000001
		//calculate distance
		func distance(a a : CGFloat, b : CGFloat) -> CGFloat {
			return abs(pow(a, 2) - pow(b, 2))
		}
		
		var sRed, sGreen, sBlue : CGFloat
		sRed = 0.0
		sGreen = 0.0
		sBlue = 0.0
		self.getRed(&sRed, green: &sGreen, blue: &sBlue, alpha: nil)
		
		var eRed, eGreen, eBlue : CGFloat
		eRed = 0.0
		eGreen = 0.0
		eBlue = 0.0
		otherColor.getRed(&eRed, green: &eGreen, blue: &eBlue, alpha: nil)
		
		return (distance(a: sRed, b: eRed) + distance(a: sGreen, b: eGreen) + distance(a: sBlue, b: eBlue))	< minVariance
	}
}

class ColorPicker : NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

	var view : UIView
	var controller : AddObjectiveViewController?
	var selectedIndex : NSIndexPath
	var accentObjects : [UIView]
	var rootViewController : ViewController

	init(withView v : UIView, withSelectedIndex i : NSIndexPath, withAccentObjects a: [UIView], withRootViewController rvc : ViewController) {
		view = v
		selectedIndex = i
		accentObjects = a
		rootViewController = rvc
		
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return colors.count
	}
	
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ColorCell", forIndexPath: indexPath) as! ColorCell

		cell.color = colors[indexPath.row]
		if indexPath == selectedIndex {
			cell.drawCell(true)
		} else {
			cell.drawCell(false)
		}
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let frameWidth = collectionView.frame.width
		let cellSpacing = spacing(collectionView)
		let cellSize = (frameWidth - 3.0 * cellSpacing)/4.0 - 1
		//print("Framewidth: \(frameWidth) cellSpacing: \(cellSpacing) cellSize: \(cellSize)")
		
		return CGSize(width: cellSize, height: cellSize)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
		return spacing(collectionView)
	}
	
	func spacing(collectionView : UICollectionView) -> CGFloat {
		let frameWidth = collectionView.frame.width
		let spacing = frameWidth/15
		//print("Actual spacing: " + String(spacing))
		return spacing
	}
	
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		//deselect original cell
		let oldColor = colors[selectedIndex.row]
		if let oldCell = collectionView.cellForItemAtIndexPath(selectedIndex) as? ColorCell {
			
			UIView.transitionWithView(oldCell, duration: 0.25, options: [.TransitionCrossDissolve], animations: {
				oldCell.drawCell(false)
				}, completion: nil)
		}
		
		selectedIndex = indexPath
		
		
		let newCell = collectionView.cellForItemAtIndexPath(selectedIndex) as! ColorCell
		newCell.color = colors[selectedIndex.row]
		UIView.transitionWithView(newCell, duration: 0.25, options: [.TransitionCrossDissolve], animations: {
			newCell.drawCell(true)
			}, completion: nil)
		
		
		changeColors(fromColor: oldColor, toColor: newCell.color)
		
		
	}
	
	func changeColors(fromColor start : UIColor, toColor end : UIColor) {
		
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
		
		let pRedSlope = (eRed - sRed)/CGFloat(steps)
		let pGreenSlope = (eGreen - sGreen)/CGFloat(steps)
		let pBlueSlope = (eBlue - sBlue)/CGFloat(steps)
		
		
		
		UIView.animateKeyframesWithDuration(1.0, delay: 0.0, options: [], animations: {
			for i in 0...steps {
				let time = Double(i) * timeStep
				let newPrimaryColor = UIColor(
					red: sRed + pRedSlope * CGFloat(i),
					green: sGreen + pGreenSlope * CGFloat(i),
					blue: sBlue + pBlueSlope * CGFloat(i),
					alpha: 1)
				
				/*let newAccentColor = UIColor(
					red: aRed + aRedSlope * CGFloat(i),
					green: aGreen + aGreenSlope * CGFloat(i),
					blue: aBlue + aBlueSlope * CGFloat(i),
					alpha: 1)*/
				
				
				
				UIView.addKeyframeWithRelativeStartTime(time, relativeDuration: timeStep, animations: {
					//self.view.backgroundColor = newPrimaryColor
					self.rootViewController.view.backgroundColor = newPrimaryColor
					self.controller?.backgroundColor = newPrimaryColor
				})
			}
			}, completion: nil)
		for obj in self.accentObjects {
			obj.tintColor = getComplementColor(end)
		}
	}
}

