//
//  HealthDataViewController.swift
//  OnTheWayMain
//
//  Created by lee on 2017. 5. 15..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit
import HealthKit

class HealthDataViewController: UIViewController {
    var stepCountArr = Array<Double>()
    var drawPieChart = PieView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestHealthKitAuthorization()
        
        
    }
}

private extension HealthDataViewController {
    
    //건강데이터 요청 메소드
    func requestHealthKitAuthorization() {
        
        let dataTypesToRead = NSSet(objects: HealthKitManager.sharedInstance.stepsCount as Any)
        
        HealthKitManager.sharedInstance.healthStore?.requestAuthorization(toShare: nil, read: dataTypesToRead as? Set<HKObjectType>, completion: { [unowned self] (success, error) in
            if success {
                for i in 0...6 {
                    self.dailyStepQuery(indexOfDay: i)
                    
                }
                
            } else {
                print(error.debugDescription)
            }
        })
    }
    
    //이번주 일주일 걸음수 요청
    func dailyStepQuery(indexOfDay: Int) { // this function gives you all of the steps the user has taken since the beginning of the current day.
        
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) // The type of data we are requesting
        let weekArr = CalenderManager.sharedInstance.getWeekArr()
        print(weekArr)
        let predicate = HKQuery.predicateForSamples(withStart: weekArr[indexOfDay], end: weekArr[indexOfDay].addingTimeInterval(60*60*24) as Date)
        
        
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            
            var steps: Int = 0
            
            if (results?.count)! > 0 {
                
                for result in results as! [HKQuantitySample] {
                    if (result.sourceRevision.source.name.range(of: "Watch") == nil) {
                        steps += Int(result.quantity.doubleValue(for: HKUnit.count()))
                    }
                }
            }
            
            
//            let ratioOfSuccess: Double = Double(steps) / Double(self.counterView.stepOfGoal)
            
            DispatchQueue.main.async {
                CalenderManager.sharedInstance.weekDic.updateValue(steps, forKey: indexOfDay)
                }
            
        }
        
        HealthKitManager.sharedInstance.healthStore?.execute(query)
        
    }
    
    
}
