import UIKit
import HealthKit
import RealmSwift


class MainViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var walkRecordLabel: UILabel!
    
    var serverManager = ServerManager()
    var calenderManager = CalenderManager()
    
    var graphView = GraphView()
    
    // 메인 스크롤뷰
    var mainScrollView = UIScrollView()
    // 메인 스크롤뷰에 추가할 서브 스크롤뷰
    var subScrollViewArray = [UIScrollView]()
    // 서브 스크롤뷰에 추가할 뷰
    var dailyCounterViewArray = [CounterView]()
    // 카운터 뷰에 추가할 텍스트 
    var dailyCounterViewTextArray = [UILabel]()
    // 뷰 전체 폭 길이
    let screenWidth = UIScreen.main.bounds.size.width
    // 뷰 전체 높이 길이
    let screenHeight = UIScreen.main.bounds.size.height
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestHealthKitAuthorization()
        
        
        
        for _ in 0...6 {
            subScrollViewArray.append(UIScrollView())
            dailyCounterViewArray.append(CounterView())
            dailyCounterViewTextArray.append(UILabel())
        }
        
        graphView.frame = CGRect(x: 0, y: self.view.frame.height / 2 , width: self.view.frame.width, height: self.view.frame.height / 2)
        graphView.backgroundColor = UIColor.blue
            
        mainScrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight / 2 )
    
        for i in 0...6 {
            subScrollViewArray[i].frame = CGRect(x: screenWidth * CGFloat(i)  ,y: 0 ,width: screenWidth ,height: screenHeight / 2)
        }
        
        for i in 0...6{
            dailyCounterViewArray[i].frame = CGRect(x:0, y: 0, width:screenWidth, height:screenHeight/2 )
            subScrollViewArray[i].addSubview(dailyCounterViewArray[i])
            mainScrollView.addSubview(subScrollViewArray[i])
            dailyCounterViewArray[i].backgroundColor = UIColor.white
            dailyCounterViewArray[i].addSubview(dailyCounterViewTextArray[i])
            
            
        }

        mainScrollView.contentSize = CGSize(width: screenWidth * 7, height: screenHeight / 2)
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.isPagingEnabled = true
        
        self.view.addSubview(mainScrollView)
        
        self.view.addSubview(graphView)
        //로그인 사용자의 정보 가져오기
        serverManager.getSession { (user) in
            UserManager.sharedInstance.addUser(user)
            
            //로그인한 유저의 세팅을 realm에서 불러와서 넣어놓기
            
            let realm = try! Realm()
            
            let results = realm.objects(SettingList.self).filter("email == '\(user.email!)'")

            if results.count != 0 {
                let dailyGoal = results.last?.items.last?.dailyGoal
                let notification = results.last?.items.last?.notification
        
                UserSettingManager.sharedInstance.updateUserSetting(user: user, dailyGoal: dailyGoal!, notification: notification!)
    
            }
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

            } else {
            }
        })
    }
    //이번주 일주일 걸음수 요청
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
                
                self.dailyCounterViewArray[indexOfDay].stepOfWalked = steps
                self.graphView.graphValues[indexOfDay] = CGFloat(steps)
                
                self.dailyCounterViewTextArray[indexOfDay].frame = CGRect(x: self.dailyCounterViewArray[indexOfDay].center.x - 20 ,y: self.dailyCounterViewArray[indexOfDay].center.y - 10 ,width: 200 ,height: 25)
                self.dailyCounterViewTextArray[indexOfDay].text = "\(steps)"
                self.dailyCounterViewTextArray[indexOfDay].font = self.dailyCounterViewTextArray[indexOfDay].font.withSize(30)
                
                self.graphView.setNeedsDisplay()
                self.dailyCounterViewArray[indexOfDay].setNeedsDisplay()
                
            }
        }

        HealthKitManager.sharedInstance.healthStore?.execute(query)

    }

}
