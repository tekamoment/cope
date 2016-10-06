//
//  DateRange.swift
//  Cope
//
//  Created by Carlos Arcenas on 10/3/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import Foundation

func > (left: NSDate, right: NSDate) -> Bool {
    return left.compare(right as Date) == .orderedDescending
}

extension NSCalendar {
    func dateRange(startDate: NSDate, endDate: NSDate, stepUnits: NSCalendar.Unit, stepValue: Int) -> DateRange {
        let dateRange = DateRange(calendar: self, startDate: startDate, endDate: endDate,
                                  stepUnits: stepUnits, stepValue: stepValue, multiplier: 0)
        return dateRange
    }
}

struct DateRange: Sequence {
    
    var calendar: NSCalendar
    var startDate: NSDate
    var endDate: NSDate
    var stepUnits: NSCalendar.Unit
    var stepValue: Int
    private var multiplier: Int
    
    func generate() -> Generator {
        return Generator(range: self)
    }
    
    struct Generator: IteratorProtocol {
        
        var range: DateRange
        
        mutating func next() -> NSDate? {
            guard let nextDate = range.calendar.date(byAdding: range.stepUnits,
                                                     value: range.stepValue * range.multiplier,
                                                     to: range.startDate as Date,
                                                                 options: []) else {
                                                                    return nil
            }
            if nextDate > range.endDate as Date {
                return nil
            }
            else {
                range.multiplier += 1
                return nextDate
            }
        }
    }
}
