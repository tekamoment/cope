//
//  SurveyScoreIndicatorView.swift
//  Cope
//
//  Created by Carlos Arcenas on 10/11/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit

class SurveyScoreIndicatorView: UIView {
    var colors: [UIColor]? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        // radius
        guard colors != nil else {
            guard layer.sublayers != nil else {
                return
            }
            for sub in layer.sublayers! {
                sub.removeFromSuperlayer()
            }
            return
        }
        
        let numberOfCircles = colors!.count
        
        var radius = min(rect.height, rect.width) / 2
        
        // 1: Figure out which dimension is the smallest.
        let minDimension = min(rect.height, rect.width)
        // 2:
        let minDimensionRadius = minDimension / 2
        
        let numberOfRadii = numberOfCircles + 1
        
        if (CGFloat(numberOfRadii) * minDimensionRadius) > rect.width {
            radius = rect.width / CGFloat(numberOfRadii)
        }
        
        var mid = rect.midX
        
        if (numberOfCircles % 2 == 0) {
            mid = mid + radius / 2
        }
        
        let stepsBack = CGFloat(floor(Double(numberOfCircles / 2)))
        let start = mid - (radius * stepsBack)
        
        for circleNumber in 0..<numberOfCircles {
            addCircle(center: CGPoint(x: start + (CGFloat(circleNumber) * radius), y: rect.midY), radius: radius, color: colors![circleNumber])
        }
        
    }
    
    func addCircle(center: CGPoint, radius: CGFloat, color: UIColor) {
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        addOval(lineWidth: 0.0, path: path.cgPath, strokeStart: 0.0, strokeEnd: 1.0, strokeColor: color, fillColor: color, shadowRadius: 0.0, shadowOpacity: 0.0, shadowOffsset: CGSize.zero)
    }
    
    func addOval(lineWidth: CGFloat, path: CGPath, strokeStart: CGFloat, strokeEnd: CGFloat, strokeColor: UIColor, fillColor: UIColor, shadowRadius: CGFloat, shadowOpacity: Float, shadowOffsset: CGSize) {
        let arc = CAShapeLayer()
        arc.lineWidth = lineWidth
        arc.path = path
        arc.strokeStart = strokeStart
        arc.strokeEnd = strokeEnd
        arc.strokeColor = strokeColor.cgColor
        arc.fillColor = fillColor.cgColor
        arc.shadowColor = UIColor.black.cgColor
        arc.shadowRadius = shadowRadius
        arc.shadowOpacity = shadowOpacity
        arc.shadowOffset = shadowOffsset
        layer.addSublayer(arc)
    }
}
