//
//  HealthKitManager.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 4. 23..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
    
    //single ton
    class var sharedInstance: HealthKitManager {
        struct Singleton {
            static let instance = HealthKitManager()
        }
        return Singleton.instance
    }
    
    //건강데이터 저장소 생성
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
    }()
    
    //사용할 데이터 구체화
    let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
    
    
}
