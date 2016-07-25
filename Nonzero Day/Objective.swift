//
//  Objective.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 6/14/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit


struct Data : CustomStringConvertible{
    var streak : NSInteger
    var score : NSInteger
	
    var description: String {
        return "Streak : " + String(streak) + " Score: " + String(score)
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
    func addData(withMSDate date: MSDate, withScore score: NSInteger){
        if (dataDictionary[date] != nil) {
            //already something there
			dataDictionary[date]!.score += score
		} else {
			var newData:Data
			if let yesterdayData = dataDictionary[date.getYesterday()] {
				//if there is data from yesterday
				newData = Data(streak: yesterdayData.streak + 1, score: score)
			} else {
				newData = Data(streak: 1, score: score);
			}
			dataDictionary[date] = newData
		}
		
        total += score
    }
	
    
    func addTodayData(withScore score: NSInteger){
        addData(withMSDate: MSDate(), withScore: score)
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
