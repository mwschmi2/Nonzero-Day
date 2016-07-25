//
//  ObjectiveViewController.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 6/29/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit

import Charts

class ObjectiveViewController: UIViewController, PageContentController {
/*
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var streakLabel: UILabel!
	@IBOutlet weak var totalLabel: UILabel!
	@IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
	@IBOutlet weak var addDataButton: UIButton!
	
	@IBOutlet weak var settingsButton: UIButton!
*/
	
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var totalLabel: UILabel!
	@IBOutlet weak var streakLabel: UILabel!
	@IBOutlet weak var expirationLabel: UILabel!
	@IBOutlet weak var secondLabel: UILabel!
	
	
	var objective : Objective!
	var pageIndex : Int = 0
    override func viewDidLoad() {
		
        super.viewDidLoad()
		
		updateLabels()
		
		view.backgroundColor = objective.color
		//addDataButton.tintColor = objective.complementColor
		//settingsButton.tintColor = objective.complementColor
	}
	
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
		
    }
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "addData"{
			let vc = segue.destinationViewController as! AddDataViewController
			vc.objective = objective
		}
	}
	
	@IBAction func cancelDataEntry(segue:UIStoryboardSegue) {
	}
	
	@IBAction func confirmDataEntry(segue:UIStoryboardSegue) {
		let vc = segue.sourceViewController as? AddDataViewController
		objective.addTodayData(withScore: (vc?.score)!)
		print("Confirmed, score is " + String((vc?.score)!))
		updateLabels()
	}
	
	func updateLabels() {
		titleLabel.text = objective.title
		totalLabel.text = String(objective.total) + " " + objective.pluralNoun + " in total"
		
		
		//Streak String
		if objective.isOnStreak() {
			let streak = objective.getTopData()!.streak
			if streak == 1 {
				streakLabel.text = "1 day on a streak"
			} else {
				streakLabel.text = String(streak) + " days on a streak"
			}
		} else {
			streakLabel.text = "0 days on a streak"
		}
		
		
		//Expiration String
		let now = NSDate()
		let components = userCalendar.components(requestedDateComponents, fromDate: now)
		var expirationString : String
		var secondString : String
		components.hour = 24
		components.minute = 0
		components.second = 0
		if objective.getTodayData() != nil {
			// streak will expire tomorrow at midnight
			components.day += 1
			let expirationDate = userCalendar.dateFromComponents(components)
			expirationString = "Your streak will end in " + parseTime((expirationDate?.timeIntervalSinceDate(now))!)
			secondString = "Come back tomorrow to continue your streak!"
			
		} else { //no data today
			if objective.getYesterdayData() != nil { //is data yesterday
				//streak expires today at midnight
				let expirationDate = userCalendar.dateFromComponents(components)
				expirationString = "Your streak will end in " + parseTime((expirationDate?.timeIntervalSinceDate(now))!)
				secondString = "Add data now to continue your streak!"
			} else {
				//there is no streak
				expirationString = "Add some data to start a streak!"
				secondString = ""
			}
		}
		
		expirationLabel.text = expirationString
		secondLabel.text = secondString
		
		
		
	}
	// takes a time between two dates, returns hours, mins
	func parseTime(time : NSTimeInterval) -> String {
		let hours  = Int(time / 3600)
		let minutes = Int((time % 3600) / 60)
		
		return String(hours) + "h " + String(minutes) +  "m"
	}
	

}
