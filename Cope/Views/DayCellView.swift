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
    var outOfMonthColor = UIColor(red: 0.796, green: 0.796, blue: 0.796, alpha: 1)
    
    var veryLowColor = UIColor(hexString: "921717")
    var lowColor = UIColor(hexString: "AF5A5A")
    var lowAverageColor = UIColor(hexString: "99A1B0")
    var averageColor = UIColor(hexString: "66698A")
    var goodColor = UIColor(hexString: "B8E986")
    var veryGoodColor = UIColor(hexString: "7ED321")

    
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
            
            // selected cell is BOLD
            
            // modify background color here.
        } else {
            dayLabel.textColor = outOfMonthColor
        }
    }

}
