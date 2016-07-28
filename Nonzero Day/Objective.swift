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
    @NSManaged var streak : NSInteger
    @NSManaged var score : NSInteger
	@NSManaged var trueDate : NSDate
	var myDate : MSDate {
		return MSDate(withDate : trueDate)
	}
	
	class func createInManagedObjectContext(moc: NSManagedObjectContext, streak : NSInteger, score: NSInteger, trueDate : NSDate) -> Data {
		let newData = NSEntityDescription.insertNewObjectForEntityForName("Data", inManagedObjectContext: moc) as! Data
		newData.streak = streak
		newData.score = score
		newData.trueDate = trueDate
		
		return newData
	}
}



class Objective  {
    
    var title : String
	var singularNoun : String
	var pluralNoun : String
	var verb : String
	
	var total = 0
    var dataDictionary : [MSDate: Data]
	
	var color : UIColor
	var complementColor : UIColor
	
	init(withType t: Type, withUnits u: Noun, withColor c : UIColor){
		title = t.title
		singularNoun = u.singularNoun
		pluralNoun = u.pluralNoun
		verb = t.verb
		
		color = c
		complementColor = getComplementColor(c)
		dataDictionary = [:]
	}
	
	func addData(withNSDate date: NSDate, withScore score: NSInteger, withContext context : NSManagedObjectContext){
		let myDate = MSDate(withDate: date)
        if (dataDictionary[myDate] != nil) {
            //already something there
			dataDictionary[myDate]!.score += score
		} else {
			var newData:Data
			if let yesterdayData = getYesterdayData() {
				//if there is data from yesterday
				
				//newData = Data(entity: yesterdayData.streak + 1, insertIntoManagedObjectContext: score)
				
				newData = Data.createInManagedObjectContext(context, streak: yesterdayData.streak + 1, score: score, trueDate: date)
			} else {
				newData = Data.createInManagedObjectContext(context, streak: 1, score: score, trueDate: date)
			}
			dataDictionary[myDate] = newData
		}
		
        total += score
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
	

    
    
    
    
}
