import UIKit
import HealthKit

class HealthDataViewController: UIViewController {
    @IBOutlet weak var PieView: PieView!
    
    var valueArr = [CGFloat]()
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
            self.requestHealthKitAuthorization()
        
    }
    
    func updateView(){
        self.PieView.values = self.valueArr
        self.PieView.setNeedsDisplay()
    }
    
}

private extension HealthDataViewController {
    
    //건강데이터 요청 메소드
    func requestHealthKitAuthorization() {
        self.count = 0
        let dataTypesToRead = NSSet(objects: HealthKitManager.sharedInstance.stepsCount as Any)
        
        HealthKitManager.sharedInstance.healthStore?.requestAuthorization(toShare: nil, read: dataTypesToRead as? Set<HKObjectType>, completion: { [unowned self] (success, error) in
            if success {
                for i in 0...6 {
                    self.dailyStepQuery(indexOfDay: i)
                }
            } else {
            }
        })
    }
    
    func dailyStepQuery(indexOfDay: Int) {
        
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        let weekArr = CalenderManager.sharedInstance.getLastWeekArr()
        let predicate = HKQuery.predicateForSamples(withStart: weekArr[indexOfDay], end: weekArr[indexOfDay].addingTimeInterval(60*60*24) as Date)
        
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { _, results, _ in
            
            var steps: Int = 0
            
            if (results?.count)! > 0 {
                
                for result in results as! [HKQuantitySample] {
                    if (result.sourceRevision.source.name.range(of: "Watch") == nil) {
                        steps += Int(result.quantity.doubleValue(for: HKUnit.count()))
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.PieView.values[self.count] = CGFloat(steps)
                self.count += 1
                self.PieView.setNeedsDisplay()
            }
            
           
                
            
            
        }
        
        HealthKitManager.sharedInstance.healthStore?.execute(query)
    }
    
}
