//
//  StepManager.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 22..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation

struct StepManager {
    //싱글톤
    static var sharedInstance = StepManager()
    private var weeklySteps = [Int:Int]()
    
    //로그인시 내 정보 넣기
    mutating func updateWeeklySteps(indexOfDay: Int, steps: Int) {
        weeklySteps.updateValue(steps, forKey: indexOfDay)
    }
    
    func getWeeklyStepsDic() -> [Int:Int] {
        return weeklySteps
    }
    
}

