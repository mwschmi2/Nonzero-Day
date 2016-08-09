//
//  MSDate.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 6/14/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import Foundation
let userCalendar = NSCalendar.currentCalendar()
let requestedDateComponents: NSCalendarUnit = [.Year,
                                               .Month,
                                               .Day,
]

class MSDate : Hashable, CustomStringConvertible{
    var day: NSInteger
    var month: NSInteger
    var year: NSInteger
    var realDate: NSDate
	
	var string : String {
		return String(month) + "/" + String(day)
	}
    var hashValue: Int {
        return day * month + year
    }
    var description: String {
        return String(month) + "/" + String(day) + "/" + String(year)
    }
	
	init(){
		let components = userCalendar.components(requestedDateComponents, fromDate: NSDate())
		day = components.day
		month = components.month
		year = components.year
		realDate = userCalendar.dateFromComponents(components)!

	}
	
    init(withDate d:NSDate){
        let components = userCalendar.components(requestedDateComponents, fromDate: d)
        day = components.day
        month = components.month
        year = components.year
        realDate = userCalendar.dateFromComponents(components)!
    }
    
    init(withDay d:NSInteger, withMonth m:NSInteger, withYear y:NSInteger){
        
        realDate = NSDate()
        var components = userCalendar.components(requestedDateComponents, fromDate: realDate)
        components.day = d;
        components.month = m;
        components.year = y;
        realDate = userCalendar.dateFromComponents(components)!
        components = userCalendar.components(requestedDateComponents, fromDate: realDate)
        day = components.day
        month = components.month
        year = components.year
    }
    
    func getYesterday() -> MSDate{
        return MSDate(withDay: day - 1, withMonth: month, withYear: year)
    }
    
    func getTomorrow() -> MSDate{
        return MSDate(withDay: day + 1, withMonth: month, withYear: year)
    }
	
	
	
	
    
    
}

extension MSDate : Equatable {}

func ==(lhs: MSDate, rhs:MSDate) -> Bool {
    return lhs.day == rhs.day && lhs.month == rhs.month && lhs.year == rhs.year
}