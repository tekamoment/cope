//
//  CalendarViewController.swift
//  Cope
//
//  Created by Carlos Arcenas on 9/6/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(fileName: "DayCellView")
        
        calendarView.scrollEnabled = false
        
        calendarView.cellInset = CGPoint(x: 0.5, y: 0.5)
        // Do any additional setup after loading the view.
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
        (cell as! DayCellView).setupCellBeforeDisplay(cellState, date: date)
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
