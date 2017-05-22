import UIKit
import HealthKit

class HealthDataViewController: UIViewController {
    @IBOutlet weak var PieView: PieView!
    
    @IBOutlet weak var sixthDayLabel: UILabel!
    @IBOutlet weak var fifthDayLabel: UILabel!
    @IBOutlet weak var fourthDayLabel: UILabel!
    @IBOutlet weak var thirdDayLabel: UILabel!
    @IBOutlet weak var secondDayLabel: UILabel!
    @IBOutlet weak var firstDayLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var pieChartView: PieChartView!
    var dayLabelArray: Array<UILabel> = []
    var isGraphViewShowing = false
    let options = UIViewAnimationOptions.transitionFlipFromLeft.union(.showHideTransitionViews)
    
    
    
    
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
        dayLabelArray = [self.sixthDayLabel, self.fifthDayLabel, self.fourthDayLabel, self.thirdDayLabel, self.secondDayLabel, self.firstDayLabel, self.todayLabel]

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
        let getSimpleDay = CalenderManager.sharedInstance.getSimpleStr(todayDate: weekArr[indexOfDay])
        
        
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
               
                
                self.PieView.values[indexOfDay] = CGFloat(steps)
                self.graphView.graphValues[indexOfDay] = CGFloat(steps)
                self.dayLabelArray[indexOfDay].text! = getSimpleDay
                self.PieView.setNeedsDisplay()
                self.graphView.setNeedsDisplay()
            }
            
           
                
            
            
        }
        
        HealthKitManager.sharedInstance.healthStore?.execute(query)
    }
   
    @IBAction func pieChartViewTap(gesture:UITapGestureRecognizer?) {
        if(isGraphViewShowing) {
            UIView.transition(from: graphView, to: pieChartView, duration: 1.0, options: options, completion: nil)
        } else {
            UIView.transition(from: pieChartView, to: graphView, duration: 1.0, options: options, completion: nil)
        }
        isGraphViewShowing = !isGraphViewShowing
    }
    
}
