//
//  Objective.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 6/14/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit
import CoreData

class Data : NSManagedObject{
    @NSManaged var streak : NSNumber?
    @NSManaged var score : NSNumber?
	@NSManaged var trueDate : NSDate?
	
	@NSManaged var objective : Objective?
	
	var myDate : MSDate {
		return MSDate(withDate : trueDate!)
	}
	
}



class Objective : NSManagedObject{
    
    @NSManaged var title : String
	@NSManaged var singularNoun : String
	@NSManaged var pluralNoun : String
	@NSManaged var verb : String
	
	@NSManaged var index : NSNumber
	
	@NSManaged var total : NSNumber
	
	@NSManaged var data : Set<Data>
	
	enum dataEntryType {
		case scroll
		case numPad
	}
	
	var entryType = dataEntryType.scroll
	
	var dataDictionary : [MSDate : Data] = [:]
	
	func refreshDictionary() {
		for (item) in data {
			dataDictionary[item.myDate] = item
		}
	}
	
	@NSManaged var color : UIColor
	@NSManaged var accentColor : UIColor
	
	
	class func createInManagedObjectContext(moc: NSManagedObjectContext, withType t : Type, withUnits u: Noun, withColor c : UIColor, withIndex i : NSInteger) -> Objective{
		let newObjective = NSEntityDescription.insertNewObjectForEntityForName("Objective", inManagedObjectContext: moc) as! Objective
		newObjective.title = t.title
		newObjective.singularNoun = u.singularNoun
		newObjective.pluralNoun = u.pluralNoun
		newObjective.verb = t.verb
		
		newObjective.color = c
		newObjective.accentColor = getComplementColor(c)
		newObjective.index = i
		newObjective.total = 0
		
		newObjective.save()
		
		return newObjective
	}

	
	func addData(withNSDate date: NSDate, withScore score: NSInteger, withContext context : NSManagedObjectContext){
		let myDate = MSDate(withDate: date)
        if let todayData = dataDictionary[myDate] {
            //already something there
			//print("Data present")
			todayData.score = todayData.score!.integerValue + score
		} else {
			var newData : Data
			if let yesterdayData = getYesterdayData() {
				//print("On a streak, adding new data")
				//if there is data from yesterday
				newData = createData(yesterdayData.streak!.integerValue + 1, score: score, trueDate: date)
			} else {
				//print("Not on a streak, adding new data")
				newData = createData(1, score: score, trueDate: date)
			}
			dataDictionary[myDate] = newData
			data.insert(newData)
		}
        total = total.integerValue + score
		
		save()
    }
	
    
	func addTodayData(withContext context : NSManagedObjectContext, withScore score: NSInteger){
		addData(withNSDate: NSDate(), withScore: score, withContext: context)
    }
	
	func getYesterdayData() -> Data? {
		let today = MSDate()
		let yesterday = today.getYesterday()
		
		let data = dataDictionary[yesterday]
		//returns either data or nil if there is nothing there
		
		return data
	}
	
	func getTodayData() -> Data? {
		let today = MSDate()
		return dataDictionary[today]
	}

	
	func getTopData() -> Data? {
		var top = MSDate()
		var data = dataDictionary[top]
		var count = 0
		while data == nil && count < dataDictionary.count{
			top = top.getYesterday()
			data = dataDictionary[top]
			count += 1
			
		}
		
		return data
	}
	
	func isOnStreak() -> Bool {
		if getTodayData() != nil || getYesterdayData() != nil {
			return true
		} else {
			return false
		}
	}
	
	override func awakeFromFetch() {
		super.awakeFromFetch()
		print("woke from fetch")
		refreshDictionary()
	}
	
	func createData(streak : NSNumber, score : NSNumber, trueDate : NSDate) -> Data {
		let newData = NSEntityDescription.insertNewObjectForEntityForName("Data", inManagedObjectContext: managedObjectContext!) as! Data
		newData.streak = streak
		newData.score = score
		newData.trueDate = trueDate
		
		newData.objective = self
		
		return newData
	}
	
	func getDataForDays(numDays : Int) -> [Data?]{
		var data : [Data?] = []
		var currDate = MSDate()
		for _ in 0..<numDays {
			data.append(dataDictionary[currDate])
			currDate = currDate.getYesterday()
		}
		
		return data.reverse()
	}
	
	func allDataNumDays() -> Int {
		var earliest = NSDate()
		for d in data {
			earliest = (d.trueDate?.earlierDate(earliest))!
		}
		let timeInSeconds = earliest.timeIntervalSinceNow * -1
		let timeInMinutes = timeInSeconds/60
		let timeInHours = timeInMinutes/60
		let timeInDays = timeInHours/24
		print(timeInDays)
		return max(Int(ceil(timeInDays) + 1), 3)
		
	}
	
	func save() {
		do {
			try managedObjectContext!.save()
		} catch {
			print("Could not save, this shouldn't happen")
		}
	}
	
	

    
    
    
    
}
