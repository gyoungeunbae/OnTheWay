//
//  PathView.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 30..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit

class PathView: UIView {
    
    
    override func draw(_ rect: CGRect) {
        
        let cgPointsArr = PointManager.sharedInstance.getTodayCGPointsArr()
        //print("point = \(cgPointsArr)")
        if cgPointsArr.count > 1 {
            
            for index in 0..<cgPointsArr.count-1 {
                
                let context = UIGraphicsGetCurrentContext()
                
                context?.setStrokeColor(UIColor.white.cgColor)
                
                context?.setLineWidth(8.0)
                
                context?.move(to: CGPoint(x: self.bounds.width*(cgPointsArr[index].x/375), y: self.bounds.height*(cgPointsArr[index].y)/667))
                
                context?.addLine(to: CGPoint(x: self.bounds.width*(cgPointsArr[index+1].x/375), y: self.bounds.height*(cgPointsArr[index+1].y)/667))
                
                context?.strokePath()
                
            }

        }
        
    }
    
    
}
