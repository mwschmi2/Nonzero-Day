//
//  ObjectiveViewController.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 6/29/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit
import Charts


class ObjectiveViewController: PageContentController, ChartViewDelegate{

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var totalLabel: UILabel!
	@IBOutlet weak var streakLabel: UILabel!
	@IBOutlet weak var expirationLabel: UILabel!
	@IBOutlet weak var secondLabel: UILabel!
	@IBOutlet weak var addDataButton: UIButton!
	@IBOutlet weak var settingsButton: UIButton!
	@IBOutlet weak var lineChartView: LineChartView!
	@IBOutlet weak var chartControl: UISegmentedControl!
	
	var markerView : MarkerView!
	
	var objective : Objective!
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		updateLabels(animated: true)
		
		
		
		/*let timer = NSTimer.scheduledTimerWithTimeInterval(30.0, target: self, selector: #selector(self.updateLabels), userInfo: nil, repeats: true)
		NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
		*/
		//configure linechartView
		
		
		
		let numberFormatter = NSNumberFormatter()
		numberFormatter.numberStyle = .DecimalStyle
		
		
		lineChartView.backgroundColor = UIColor.clearColor()
		lineChartView.xAxis.labelPosition = .Bottom
		lineChartView.xAxis.axisLineWidth = 2
		lineChartView.xAxis.axisLineColor = UIColor.whiteColor()
		lineChartView.xAxis.labelTextColor = UIColor.whiteColor()
		lineChartView.xAxis.drawGridLinesEnabled = false
		lineChartView.leftAxis.drawGridLinesEnabled = false
		lineChartView.leftAxis.axisMinValue = 0
		lineChartView.leftAxis.axisLineWidth = 2
		lineChartView.leftAxis.axisLineColor = UIColor.whiteColor()
		lineChartView.leftAxis.labelTextColor = UIColor.whiteColor()
		lineChartView.leftAxis.valueFormatter = numberFormatter
		lineChartView.rightAxis.enabled = false
		lineChartView.legend.enabled = false
		lineChartView.descriptionText = ""
		lineChartView.dragEnabled = false
		lineChartView.setScaleEnabled(false)
		lineChartView.delegate = self
		
		
		
		
		chartControl.selectedSegmentIndex = 0
		refreshChart(animated: true)

		
	}
	
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
		
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		updateLabels(animated: false)
	}
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "addData" {
			let vc = segue.destinationViewController as! AddDataViewController
			vc.objective = objective
		} else if segue.identifier == "settings" {
			let vc = segue.destinationViewController as! SettingsViewController
			vc.objective = objective
			vc.rootViewController = rootViewController

		}
	}
	
	@IBAction func cancelDataEntry(segue: UIStoryboardSegue) {
	}
	
	@IBAction func confirmDataEntry(segue: UIStoryboardSegue) {
		refreshChart(animated: true)
	}
	
	@IBAction func confirmSettings(segue: UIStoryboardSegue) {
		let settings = segue.sourceViewController as! SettingsViewController
		objective.title = settings.titleField.text!
		objective.pluralNoun = settings.pluralField.text!
		objective.singularNoun = settings.singularField.text!
		objective.verb = settings.verbField.text!
		objective.color = colors[settings.colorPickerDelegate.selectedIndex.row]
		objective.accentColor = getComplementColor(objective.color)
		switch settings.styleControl.selectedSegmentIndex {
		case 0:
			objective.scrolling = true
			objective.entryStyle = .scroll
		default:
			objective.scrolling = false
			objective.entryStyle = .numpad
			
		}
		updateLabels(animated: true)
		refreshChart(animated: true)
		objective.save()
	}
	
	func updateLabels(animated animated : Bool) {
		
		//view.backgroundColor = objective.color
		view.backgroundColor = UIColor.clearColor()
		backgroundColor = objective.color
		addDataButton.tintColor = objective.accentColor
		settingsButton.tintColor = objective.accentColor
		chartControl.tintColor = objective.accentColor

		print("[ObjectiveViewController] Updating labels with objective : " + objective.title)
		titleLabel.text = objective.title
		totalLabel.text = objective.total == 1 ? "1 " + objective.singularNoun + " in total" : String(objective.total) + " " + objective.pluralNoun + " in total"
		
		
		//Streak String
		if objective.isOnStreak() {
			let streak = objective.getTopData()!.streak
			if streak == 1 {
				streakLabel.text = "1 day on a streak"
			} else {
				streakLabel.text = String(streak!) + " days on a streak"
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
	
	func refreshChart(animated animated : Bool) {
		hideMarker(animated: animated)
		var days : Int
		switch chartControl.selectedSegmentIndex {
		case 0:
			days = 7
		case 1:
			days = 30
		case 2:
			days = objective.allDataNumDays()
		default:
			days = 5
		}
		
		let data : [Data?] = objective.getDataForDays(days)
		
		let dates = getChartLabels(days)
		var dataEntries : [[ChartDataEntry]] = [[]]
		var numStreaks = 0

		
		
		//each array of dataentries represents a single streak
		for i in 0..<data.count{
			if let currData = data[i] {
				let entry = ChartDataEntry(value: currData.score!.doubleValue, xIndex: i)
				dataEntries[numStreaks].append(entry)
			} else {
				if !dataEntries[numStreaks].isEmpty {
					numStreaks += 1
					dataEntries.append([])
				}
			
			}
		}
		var dataSets : [LineChartDataSet] = []
		for streak in dataEntries {
			
			let set = LineChartDataSet(yVals: streak, label: "")
			set.colors = [objective.accentColor]
			set.circleColors = [objective.accentColor]
			set.circleHoleColor = objective.color
			set.lineWidth = 4
			set.drawValuesEnabled = false
			set.highlightColor = UIColor.clearColor()
			dataSets.append(set)
		}
		let lineChartData = LineChartData(xVals: dates, dataSets: dataSets)
	
		lineChartView.data = lineChartData
		if animated {
			lineChartView.animate(yAxisDuration: 1.0, easingOption: .EaseInOutBack)
		}
		
		
	}
	
	func getChartLabels(numDays : Int) -> [String]{
		var current = MSDate()
		var strings : [String] = []
		for _ in 0..<numDays {
			strings.append(current.string)
			current = current.getYesterday()
		}
		
		return strings.reverse()
	}
	
	
	@IBAction func controlValueChanged(sender: AnyObject) {
		refreshChart(animated: true)
		
	}
	
	func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
		let markerPosition = chartView.getMarkerPosition(entry: entry, highlight: highlight)
		//TODO: draw a view here programatically
		
		/*let label = UILabel(frame: CGRect(x: markerPosition.x, y: markerPosition.y+chartView.frame.minY , width: 100, height: 30))
		
		label.text = "testtesttesttesttestasdfMarkisthebest"
		self.view.addSubview(label)*/
		
		
		hideMarker(animated: true)
		let width: CGFloat = 30
		let height: CGFloat = 30
		let x = markerPosition.x
		let y = markerPosition.y + 10
		self.markerView = MarkerView(frame: CGRect(x: x, y: y, width: width, height: height), objective: self.objective, score: Int(entry.value), date: chartView.xAxis.values[entry.xIndex]!)
		self.markerView.alpha = 0.0
		
		UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseInOut], animations: {
			self.markerView.alpha = 1.0
			}, completion: nil)
		chartView.addSubview(self.markerView)
		
	}
	
	func chartValueNothingSelected(chartView: ChartViewBase) {
		hideMarker(animated: true)
	}
	
	func hideMarker(animated animated: Bool) {
		if let mv = markerView {
			if animated  {
				UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseInOut], animations: {
					mv.alpha = 0.0
					}, completion: {
						(Bool) in
						mv.removeFromSuperview()
				})
			} else {
				mv.removeFromSuperview()
			}
		}
	}
	

	
	
	

}
