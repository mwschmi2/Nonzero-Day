//
//  SampleData.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 7/4/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit

func getComplementColor(color : UIColor) -> UIColor{
	let index = colors.indexOf(color)
	return colors[(index! + 1) % colors.count]
}

var colors : [UIColor] {
	return buildColorsArray()
}

func buildColorsArray() -> [UIColor]{
	let hexes : [Int] = [0x00ffff, 0xff9966]
	var temp : [UIColor] = []
	for hex in hexes {
		temp.append(UIColor(netHex: hex))
	}
	return temp
}


class Type {
	let title : String
	let verb : String
	let units : [Noun]
	
	init(withTitle t : String, withVerb v : String, withUnits u: [Noun]){
		title = t
		verb = v
		units = u
	}
}

struct Noun {
	let singularNoun : String
	let pluralNoun : String
	
	init(s : String, p : String){
		singularNoun = s
		pluralNoun = p
	}
}

let readingNouns = [Noun(s: "page", p: "pages"), Noun(s: "chapter", p: "chapters"), Noun(s: "minute", p: "minutes")]
let reading = Type(withTitle: "Reading", withVerb: "read", withUnits: readingNouns)

let writingNouns = [Noun(s: "sentence", p: "sentences"), Noun(s: "page", p: "pages"), Noun(s: "minute", p: "minutes")]
let writing = Type(withTitle: "Writing", withVerb: "write", withUnits: writingNouns)

let types : [Type] = [reading, writing]

var objectiveData = [
	Objective(withType: reading, withUnits: reading.units[0], withColor: colors[0]),
	Objective(withType: writing, withUnits: writing.units[0], withColor: colors[1])]
