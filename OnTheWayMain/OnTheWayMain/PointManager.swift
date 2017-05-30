//
//  PointManager.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 30..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation
import CoreGraphics

struct PointManager {
    //싱글톤
    static var sharedInstance = PointManager()
    private var cgPoints = [CGPoint]()
    
    mutating func addTodayCGPoints(point: CGPoint) {
        self.cgPoints.append(point)
    }
    
    func getTodayCGPointsArr() -> [CGPoint] {
        return self.cgPoints
    }
    
    mutating func removeArr() {
        self.cgPoints.removeAll()
    }
}

