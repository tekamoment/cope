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
    var dayHasDataColor = UIColor.darkGray
    var outOfMonthColor = UIColor(red: 0.796, green: 0.796, blue: 0.796, alpha: 1)
    
    var veryLowColor = UIColor(hexString: "921717")
    var lowColor = UIColor(hexString: "AF5A5A")
    var lowAverageColor = UIColor(hexString: "99A1B0")
    var averageColor = UIColor(hexString: "66698A")
    var goodColor = UIColor(hexString: "B8E986")
    var veryGoodColor = UIColor(hexString: "7ED321")
    
    var shadowLayer: CALayer!
    
    @IBOutlet weak var surveyScoreIndicatorView: SurveyScoreIndicatorView!
    
    
    func setupCellBeforeDisplay(_ cellState: CellState, date: Date) {
        dayLabel.text = cellState.text
        
        configureTextColor(cellState)
        
        // might move to separate function
        if cellState.isSelected {
            // apply inner shadow
            if (shadowLayer == nil) {
                let size = self.frame.size
                self.clipsToBounds = true
                let layer: CALayer = CALayer()
                layer.masksToBounds = true
                layer.position = CGPoint(x: size.width / 2, y: size.height / 2)
                layer.bounds = CGRect(origin: CGPoint(x:0, y:0), size: size)
                layer.shadowColor = UIColor.darkGray.cgColor
                layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                layer.shadowOpacity = 1.0
                layer.shadowRadius = 2.0
                
                layer.borderColor = UIColor(hexString: "#FCFCFC").cgColor
                layer.borderWidth = 1.0
                
                self.shadowLayer = layer
                self.layer.addSublayer(layer)
                dayLabel.font = UIFont.boldSystemFont(ofSize: dayLabel.font.pointSize)
            }
        } else {
            if (shadowLayer != nil) {
                shadowLayer.removeFromSuperlayer()
                shadowLayer = nil
                dayLabel.font = UIFont.systemFont(ofSize: dayLabel.font.pointSize)
            }
        }
    }
    
    func configureTextColor(_ cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            dayLabel.textColor = normalDayColor
        } else {
            dayLabel.textColor = outOfMonthColor
        }
    }

}
