import UIKit
import HealthKit
class MainViewController: UIViewController {
    var serverManager = ServerManager()
    var calenderManager = CalenderManager()

    @IBAction func logoutButton(_ sender: Any) {
        serverManager.logout()
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
        self.present(loginVC, animated: false, completion: nil)
    }

    @IBOutlet weak var firstDayLabel: UILabel!
    @IBOutlet weak var secondDayLabel: UILabel!
    @IBOutlet weak var thirdDayLabel: UILabel!
    @IBOutlet weak var fourthDayLabel: UILabel!
    @IBOutlet weak var fifthDayLabel: UILabel!
    @IBOutlet weak var sixthDayLabel: UILabel!
    @IBOutlet weak var seventhDayLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var firstImageView: RoundImageView!
    @IBOutlet weak var secondImageView: RoundImageView!
    @IBOutlet weak var thirdImageView: RoundImageView!
    @IBOutlet weak var fourthImageView: RoundImageView!
    @IBOutlet weak var fifthImageView: RoundImageView!
    @IBOutlet weak var sixthImageView: RoundImageView!
    @IBOutlet weak var seventhImageView: RoundImageView!
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var walkRecordLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let simpleWeekStr = calenderManager.getSimpleWeekArrStr()
        requestHealthKitAuthorization()
        let imageViews = [firstImageView, secondImageView, thirdImageView, fourthImageView, fifthImageView, sixthImageView, seventhImageView]
        for i in 0..<imageViews.count {
            imageViews[i]?.setRounded()
        }
        let weekLabels = [firstDayLabel, secondDayLabel, thirdDayLabel, fourthDayLabel, fifthDayLabel, sixthDayLabel, seventhDayLabel]
        for i in 0..<weekLabels.count {
            weekLabels[i]?.text = simpleWeekStr[i]
        }
    }

}
private extension MainViewController {

    //건강데이터 요청 메소드
    func requestHealthKitAuthorization() {

        let dataTypesToRead = NSSet(objects: HealthKitManager.sharedInstance.stepsCount as Any)

        HealthKitManager.sharedInstance.healthStore?.requestAuthorization(toShare: nil, read: dataTypesToRead as? Set<HKObjectType>, completion: { [unowned self] (success, error) in
            if success {

                for i in 0...6 {
                    self.dailyStepQuery(indexOfDay: i)
                }

                self.todayStepQuery()

            } else {
                print(error.debugDescription)
            }
        })
    }

    //오늘 걸음수 데이터 요청
    func todayStepQuery() { // this function gives you all of the steps the user has taken since the beginning of the current day.

        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) // The type of data we are requesting
        let date = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let newDate = cal.startOfDay(for: date as Date)

        //오늘
        let predicate = HKQuery.predicateForSamples(withStart: newDate, end: NSDate() as Date)

        // The actual HealthKit Query which will fetch all of the steps and add them up for us.

        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { _, results, _ in
            var steps: Int = 0

            if (results?.count)! > 0 {
                for result in results as! [HKQuantitySample] {
                    if (result.sourceRevision.source.name.range(of: "Watch") == nil) {
                        steps += Int(result.quantity.doubleValue(for: HKUnit.count()))
                        //print(result)
                    }

                }

            }
            let ratioOfSuccess: Double = Double(steps) / Double(self.counterView.stepOfGoal)
            DispatchQueue.main.async {
                self.walkRecordLabel.text = "\(steps)"
                self.counterView.stepOfWalked = steps
                self.counterView.setNeedsDisplay()

                switch ratioOfSuccess {
                case 0..<0.5:
                    self.messageLabel.text = "운동 부족입니다!"
                case 0.5..<1.0:
                    self.messageLabel.text = "거의 다 왔어요!"
                default:
                    self.messageLabel.text = "축하합니다!"
                }
            }
        }

        HealthKitManager.sharedInstance.healthStore?.execute(query)
    }

    //이번주 일주일 걸음수 요청
    func dailyStepQuery(indexOfDay: Int) { // this function gives you all of the steps the user has taken since the beginning of the current day.

        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) // The type of data we are requesting
        let imageViews = [firstImageView, secondImageView, thirdImageView, fourthImageView, fifthImageView, sixthImageView, seventhImageView]
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

            let ratioOfSuccess: Double = Double(steps) / Double(self.counterView.stepOfGoal)

            DispatchQueue.main.async {
                CalenderManager.sharedInstance.weekDic.updateValue(steps, forKey: indexOfDay)

                switch ratioOfSuccess {
                case 0..<0.5:
                    imageViews[indexOfDay]?.backgroundColor = UIColor.black
                case 0.5..<1.0:
                    imageViews[indexOfDay]?.backgroundColor = UIColor.white
                default:
                    imageViews[indexOfDay]?.backgroundColor = UIColor.green
                }
            }
        }

        HealthKitManager.sharedInstance.healthStore?.execute(query)

    }

}
