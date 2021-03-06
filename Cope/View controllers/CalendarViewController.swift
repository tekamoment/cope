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
    
    @IBOutlet weak var previousMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    
    var monthYearLabelDateFormatter: DateFormatter!
    var surveyRecordDateFormatter = DateFormatter()
    var requestedYear: Int!
    var requestedMonth: Int!
    var requestedDay: Int!
    
    let usedCalendar = Calendar(identifier: .gregorian)
    
//    var requestedComponents: DateComponents!
    var requestedDate = Date()
    
    let userID = "tester"
    
    var requestedMonthData: NSDictionary?
    var requestedMonthRecords = [SurveyRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "DayCellView")
        
//        calendarView.scrollEnabled = false
//        calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        
        calendarView.scrollEnabled = true
        
        calendarView.cellInset = CGPoint(x: 1, y: 1)
        
        self.tabBarController!.title = NSLocalizedString("calendar", comment: "Calendar")
        // Do any additional setup after loading the view.
        
        // set query to current month
        monthYearLabelDateFormatter = DateFormatter()
        monthYearLabelDateFormatter.dateFormat = "MMMM yyyy"
        monthYearLabel.text = monthYearLabelDateFormatter.string(from: Date())
        
        
        let usedLocale = Locale(identifier: "en_US_POSIX")
        surveyRecordDateFormatter.locale = usedLocale
        surveyRecordDateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        surveyRecordDateFormatter.dateFormat = DatabaseConstants.surveyTimeStorageFormat
        
        fetchData(year: 2016, month: 10)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController!.title = NSLocalizedString("calendar", comment: "Calendar")
//        view.layoutSubviews()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = TimeZone.current
        
        var usedCalendar = Calendar(identifier: .gregorian)
        usedCalendar.timeZone = TimeZone(abbreviation: "GMT")!
        
        let dateComponents = (usedCalendar as NSCalendar).components([.month , .year], from: Date())
        let startOfMonth = usedCalendar.date(from: dateComponents)!
        
        var endComponents = DateComponents()
        endComponents.month = 1
        endComponents.day = -1
        let endOfMonth = (usedCalendar as NSCalendar).date(byAdding: endComponents, to: startOfMonth, options: [])!
        
        let numberOfCalendarRows = 6
        
        // change start to user-start and end to today 
        return ConfigurationParameters(startDate: startOfMonth, endDate: endOfMonth, numberOfRows: numberOfCalendarRows, calendar: Calendar(identifier: .gregorian), generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .sunday)

    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let dayCell = cell as! DayCellView
        
        dayCell.setupCellBeforeDisplay(cellState, date: date)
        dayCell.surveyScoreIndicatorView.backgroundColor = UIColor.clear
        
        dayCell.backgroundColor = UIColor(hexString: "#FCFCFC")
        if cellState.dateBelongsTo == .thisMonth {
            guard requestedMonthRecords.count > 0 else {
                return
            }
            
            let startAndEndOfDay = self.generateStartAndEndOfDayFor(date: date)
            let startDate = startAndEndOfDay.0
            let endDate = startAndEndOfDay.1
            
            let dayRecords = requestedMonthRecords.filter({ (record) -> Bool in
                let recordDate = record.date
                return startDate.compare(recordDate).rawValue * recordDate.compare(endDate).rawValue >= 0
            })
            
            guard dayRecords.count > 0 else {
                dayCell.surveyScoreIndicatorView.colors = nil
                return
            }
            
            print("RECORDS FOR DAY")
            debugPrint(dayRecords)
            
            dayCell.dayLabel.textColor = dayCell.dayHasDataColor
            
            var colors = [UIColor]()
            for record in dayRecords {
                let score = record.score
                if score < 1.5 {
                    colors.append(dayCell.veryLowColor!)
                } else if score < 2 {
                    colors.append(dayCell.lowColor!)
                } else if score < 2.5 {
                    colors.append(dayCell.lowAverageColor!)
                } else if score < 3 {
                    colors.append(dayCell.averageColor!)
                } else if score < 3.5 {
                    colors.append(dayCell.goodColor!)
                } else {
                    colors.append(dayCell.veryGoodColor!)
                }
            }
            
            dayCell.surveyScoreIndicatorView.colors = colors
        } else {
            dayCell.surveyScoreIndicatorView.colors = nil
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
        
        
        // trigger segue
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        // toggle inner shadow
        (cell as! DayCellView).setupCellBeforeDisplay(cellState, date: date)
    }
    
    @IBAction func previousMonthPressed(_ sender: AnyObject) {
        // decrement month
        requestNewMonth(direction: .backward)
    }

    @IBAction func nextMonthPressed(_ sender: AnyObject) {
        // increment month
        requestNewMonth(direction: .forward)
    }
    
    func fetchData(year: Int, month: Int) {
        DatabaseConstants.fetchSurveyDataForMonth(userID: userID, year: year, month: month) { (snapshot) in
            print("Sourced from new fetch:")
            debugPrint(snapshot)
            
            self.requestedMonthRecords.removeAll()
            
            guard let requestedData = snapshot.value as? [String: Any] else {
                return
            }
            
            for (date, record) in requestedData {
                let dayRecord = record as! [String: Any]
                
                var answers = [SymptomAnswer]()
                var score: Double = 0.0
                
                for (category, answer) in dayRecord {
                    if category == DatabaseConstants.score {
                        score = answer as! Double
                        continue
                    }
                    
                    answers.append(SymptomAnswer(category: category, answer: answer as! String, value: 0.0))
                }
                
                self.requestedMonthRecords.append(SurveyRecord(date: self.surveyRecordDateFormatter.date(from: date)!, answers: answers, score: score))
            }
            debugPrint(self.requestedMonthRecords)
            self.calendarView.reloadData()
        }
    }
    
    func requestNewMonth(direction: Direction) {
        var addComponents = DateComponents()
        
        switch direction {
        case .forward:
            addComponents.month = 1
            addComponents.day = -1
            
        
        case .backward: break
        }
        
        requestedDate = usedCalendar.date(byAdding: addComponents, to: requestedDate)!
        calendarView.scrollToDate(requestedDate)
        
        
        monthYearLabel.text = monthYearLabelDateFormatter.string(from: requestedDate)
    }
    
    func generateStartAndEndOfDayFor(date: Date) -> (Date, Date) {
        var components = usedCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = usedCalendar.date(from: components)!
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = usedCalendar.date(from: components)!
        return (startDate, endDate)
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

enum Direction {
    case forward;
    case backward
}
