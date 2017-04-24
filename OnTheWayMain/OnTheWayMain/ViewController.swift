//
//  ViewController.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 4. 22..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit
import HealthKit


class ViewController: UIViewController {

    @IBOutlet weak var sundayImageView: RoundImageView!
    @IBOutlet weak var mondayImageView: RoundImageView!
    
    @IBOutlet weak var tuesdayImageView: RoundImageView!
    
    @IBOutlet weak var wednesdayImageView: RoundImageView!
    
    @IBOutlet weak var thursdayImageView: RoundImageView!
    
    @IBOutlet weak var fridayImageView: RoundImageView!
    
    @IBOutlet weak var saturdayImageView: RoundImageView!
    
    
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var walkRecordLabel: UILabel!
    
    fileprivate let healthKitManager = HealthKitManager.sharedInstance
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //건강데이터 요청
        requestHealthKitAuthorization()
        sundayImageView.setRounded()
        mondayImageView.setRounded()
        tuesdayImageView.setRounded()
        wednesdayImageView.setRounded()
        thursdayImageView.setRounded()
        fridayImageView.setRounded()
        saturdayImageView.setRounded()
        
    }
    
    

}

private extension ViewController {
    
    //건강데이터 요청 메소드
    func requestHealthKitAuthorization() {
        let dataTypesToRead = NSSet(objects: healthKitManager.stepsCount as Any)
        healthKitManager.healthStore?.requestAuthorization(toShare: nil, read: dataTypesToRead as? Set<HKObjectType>, completion: { [unowned self] (success, error) in
            if success {
                self.dailyStepQuery()
                
            } else {
                print(error.debugDescription)
            }
        })
    }
    
    func dailyStepQuery() { // this function gives you all of the steps the user has taken since the beginning of the current day.
        
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) // The type of data we are requesting
        let date = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let newDate = cal.startOfDay(for: date as Date)
        let predicate = HKQuery.predicateForSamples(withStart: newDate, end: NSDate() as Date) // Our search predicate which will fetch all steps taken today
        
        // The actual HealthKit Query which will fetch all of the steps and add them up for us.
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var steps: Int = 0
            
            if (results?.count)! > 0
            {
                for result in results as! [HKQuantitySample]
                {
                    steps += Int(result.quantity.doubleValue(for: HKUnit.count()))
                }
            }
            print(steps)
            DispatchQueue.main.async {
                self.walkRecordLabel.text = "\(steps)"
                self.counterView.stepOfWalked = steps
                self.counterView.setNeedsDisplay()
            }
        }
        
        healthKitManager.healthStore?.execute(query)
        
    }
}
