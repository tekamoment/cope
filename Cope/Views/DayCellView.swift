//
//  DayCellView.swift
//  Cope
//
//  Created by Carlos Arcenas on 9/6/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DayCellView: JTAppleDayCellView {
    
    @IBOutlet weak var dayLabel: UILabel!
    var normalDayColor = UIColor.black
    var weekendDayColor = UIColor.gray

    
    func setupCellBeforeDisplay(_ cellState: CellState, date: Date) {
        dayLabel.text = cellState.text
        
        //if cellState.row() == 5 {
        //    self.hidden = true
        //}
        
        configureTextColor(cellState)
    }
    
    func configureTextColor(_ cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            dayLabel.textColor = normalDayColor
        } else {
            dayLabel.textColor = weekendDayColor
        }
    }

}
