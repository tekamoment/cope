//
//  CalendarViewController.swift
//  Cope
//
//  Created by Carlos Arcenas on 9/6/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import JTAppleCalendar

import Firebase

class CalendarViewController: UIViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var wellnessScoreLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var reccommendationLabel: UILabel!
    
    @IBOutlet weak var previousMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    
    var dateFormatter: DateFormatter!
    var requestedYear: Int!
    var requestedMonth: Int!
    var requestedDay: Int!
    
    let usedCalendar = Calendar(identifier: .gregorian)
    
    let userID = "tester"
    
    var requestedMonthData: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(fileName: "DayCellView")
        
        calendarView.scrollEnabled = false
        
        calendarView.cellInset = CGPoint(x: 1, y: 1)
        
        self.tabBarController!.title = NSLocalizedString("calendar", comment: "Calendar")
        // Do any additional setup after loading the view.
        
        // set query to current month
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        monthYearLabel.text = dateFormatter.string(from: Date())
        
        
        // firebase fetch
        DatabaseConstants.fetchDataForMonth(userID: userID, year: 2016, month: 10) { (snapshot) in
            debugPrint(snapshot)
            self.requestedMonthData = snapshot.value as? NSDictionary
            self.calendarView.reloadData()
        }
        
        calendarView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController!.title = NSLocalizedString("calendar", comment: "Calendar")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> (startDate: Date, endDate: Date, numberOfRows: Int, calendar: Calendar) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let usedCalendar = Calendar.current
        
        let dateComponents = (usedCalendar as NSCalendar).components([.month , .year], from: Date())
        let startOfMonth = usedCalendar.date(from: dateComponents)!
        
        var endComponents = DateComponents()
        endComponents.month = 1
        endComponents.day = -1
        let endOfMonth = (usedCalendar as NSCalendar).date(byAdding: endComponents, to: startOfMonth, options: [])!
        
        let numberOfCalendarRows = 6
        
        return (startDate: startOfMonth, endDate: endOfMonth, numberOfRows: numberOfCalendarRows, calendar: usedCalendar)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, isAboutToDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let dayCell = cell as! DayCellView
        
        dayCell.setupCellBeforeDisplay(cellState, date: date)
        
        // apply score colors here
        
        dayCell.backgroundColor = UIColor(hexString: "#FCFCFC")
        if cellState.dateBelongsTo == .thisMonth{
            let dayComponent = (usedCalendar as NSCalendar).components([.day], from: date)
            
            // do an if let
            guard requestedMonthData != nil, let dayData = requestedMonthData!["\(dayComponent.day!)"] as? NSDictionary, let score = dayData["score"] as? Double else {
                return
            }
            
            dayCell.dayLabel.textColor = dayCell.dayHasDataColor
            
            if score < 1.5 {
                dayCell.backgroundColor = dayCell.veryLowColor
            } else if score < 2 {
                dayCell.backgroundColor = dayCell.lowColor
            } else if score < 2.5 {
                dayCell.backgroundColor = dayCell.lowAverageColor
            } else if score < 3 {
                dayCell.backgroundColor = dayCell.averageColor
            } else if score < 3.5 {
                dayCell.backgroundColor = dayCell.goodColor
            } else {
                dayCell.backgroundColor = dayCell.veryGoodColor
            }
        }
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, canSelectDate date: Date, cell: JTAppleDayCellView, cellState: CellState) -> Bool {
        if date.timeIntervalSinceNow > 0 {
            return false
        } else {
            if cellState.dateBelongsTo != .thisMonth {
                return false
            }
            return true
        }
        
        // doesn't count days before state or those that have cell states
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        
        // toggle inner shadow
        (cell as! DayCellView).setupCellBeforeDisplay(cellState, date: date)
        
        
        // set data displayed
        
        // refactor check out to own function
        let dayComponent = (usedCalendar as NSCalendar).components([.day], from: date)
        
        guard requestedMonthData != nil, let dayData = requestedMonthData!["\(dayComponent.day!)"] as? NSDictionary, let score = dayData["score"] as? Double else {
            wellnessScoreLabel.text = "You do not have data for this day."
            return
        }
        
        // FORMAT DATES CORRECTLY ACCORDING TO INTERNATIONALIZATION
        wellnessScoreLabel.text = "Your wellness score for this day is \(score)."
        summaryLabel.text = "You had \(NSLocalizedString(dayData["sleepCategory"] as! String, comment:"Hours of sleep a user had")) of sleep, were \(NSLocalizedString(dayData["emotionCategory"] as! String, comment:"User's emotion"))"
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        // toggle inner shadow
        (cell as! DayCellView).setupCellBeforeDisplay(cellState, date: date)
    }
    
    @IBAction func previousMonthPressed(_ sender: AnyObject) {
        // decrement month
        calendarView.reloadData()
    }

    @IBAction func nextMonthPressed(_ sender: AnyObject) {
        // increment month
        calendarView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
