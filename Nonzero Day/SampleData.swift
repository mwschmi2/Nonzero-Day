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
	return complementaryColors[index!]
}

var colors : [UIColor] {
	return buildColorsArray()
}

var complementaryColors : [UIColor] {
	return buildComplementaryColorsArray()
}

func buildComplementaryColorsArray() -> [UIColor] {
	var temp : [UIColor] = []
	for colorPair in colorPairs {
		temp.append(UIColor(netHex: colorPair.accent))
	}
	return temp

}
func buildColorsArray() -> [UIColor]{
	
	var temp : [UIColor] = []
	for colorPair in colorPairs {
		temp.append(UIColor(netHex: colorPair.primary))
	}
	return temp
}

let colorPairs : [(primary: Int, accent: Int)] = [
	(primary: 0x53B3CB, accent: 0xE01A4F),
	(primary: 0x9893DA, accent: 0x9AD5CA),
	(primary: 0x037971, accent: 0x5B1865),
	(primary: 0xFF5A5F, accent: 0x40476D),
	(primary: 0x414288, accent: 0xA1E8AF),
	(primary: 0xF4C3C2, accent: 0xE88EED)
]


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

let programmingNouns = [Noun(s: "line of code", p: "lines of code"), Noun(s: "minute", p: "minutes")]
let programming = Type(withTitle: "Programming", withVerb: "program", withUnits: programmingNouns)

let musicNouns = [Noun(s: "minute", p: "minutes")]
let music = Type(withTitle: "Music", withVerb: "practice", withUnits: musicNouns)

let runningNouns = [Noun(s: "block", p: "blocks"), Noun(s: "mile", p: "miles"), Noun(s: "minute", p: "minutes")]
let running = Type(withTitle: "Running", withVerb: "run", withUnits: runningNouns)

let types : [Type] = [reading, writing, programming, music, running]

/*var objectiveData = [
	Objective(withType: reading, withUnits: reading.units[0], withColor: colors[0]),
	Objective(withType: writing, withUnits: writing.units[0], withColor: colors[1])]*/

//var objectiveData : [Objective] = []
