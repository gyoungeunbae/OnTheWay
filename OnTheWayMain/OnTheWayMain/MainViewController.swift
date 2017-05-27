import UIKit
import HealthKit
import RealmSwift
import CoreLocation

class MainViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var walkRecordLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var serverManager = ServerManager()
    var calenderManager = CalenderManager()
    var graphView = GraphView()
   
    
    
    // 메인 스크롤뷰
    var mainScrollView = UIScrollView()
    // 메인 스크롤뷰에 추가할 뷰
    var dailyCounterViewArray = [CounterView]()
    // 카운터 뷰에 추가할 텍스트 
    var dailyCounterViewTextArray = [UILabel]()
    // 날짜 텍스트
    var dailyCounterViewDayTextArray = [UILabel]()
    // 목표 걸음수 텍스트
    var goalTextArray = [UILabel]()
    // 뷰 전체 폭 길이
    let screenWidth = UIScreen.main.bounds.size.width
    // 뷰 전체 높이 길이
    let screenHeight = UIScreen.main.bounds.size.height
    let weeklyStepsDic = StepManager.sharedInstance.getWeeklyStepsDic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let thisWeek = self.calenderManager.getLastWeekArr()
        
        
        LocationService.sharedInstance.startUpdatingLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(draw), name: Notification.Name("goalChanged"), object: nil)

        DispatchQueue.main.async {
            
            for indexOfDay in self.weeklyStepsDic.keys {
                
                //let steps:Int = self.weeklyStepsDic[indexOfDay]!
                let steps:Int = 5000
                
                StepManager.sharedInstance.updateWeeklySteps(indexOfDay: indexOfDay, steps: steps)
                
                self.dailyCounterViewArray[indexOfDay].stepOfWalked = steps
                self.graphView.graphValues[indexOfDay] = CGFloat(steps)
                
                self.graphView.graphValues[indexOfDay] = CGFloat(steps)
                self.dailyCounterViewArray[indexOfDay].stepOfWalked = steps
                self.dailyCounterViewTextArray[indexOfDay].text = "\(steps)"
                
                if(indexOfDay == 5){
                    self.dailyCounterViewDayTextArray[indexOfDay].text = "어제"
                } else if(indexOfDay == 6) {
                    self.dailyCounterViewDayTextArray[indexOfDay].text = "오늘"
                } else {
                    self.dailyCounterViewDayTextArray[indexOfDay].text = "\(self.calenderManager.getTimeString(todayDate: thisWeek[indexOfDay]))"
                }
                self.goalTextArray[indexOfDay].text = "\(self.dailyCounterViewArray[indexOfDay].getGoal())"
                
                
                self.draw()
                
                self.graphView.setNeedsDisplay()
                self.dailyCounterViewArray[indexOfDay].setNeedsDisplay()
            }
        }
        
        print(weeklyStepsDic)

        
        for _ in 0...6 {
            dailyCounterViewArray.append(CounterView())
            dailyCounterViewTextArray.append(UILabel())
            dailyCounterViewDayTextArray.append(UILabel())
            goalTextArray.append(UILabel())
        }
        
        mainScrollView.frame = CGRect(x: 0, y: 50, width: screenWidth, height: screenHeight / 2)
        mainScrollView.backgroundColor = UIColor.clear
        
        graphView.frame = CGRect(x: 0, y: self.view.frame.height / 2 , width: self.view.frame.width, height: self.view.frame.height / 2)
        graphView.backgroundColor = UIColor.clear
    
        for i in 0...6 {
            dailyCounterViewArray[i].frame = CGRect(x: screenWidth * CGFloat(i)  ,y: 50 ,width: screenWidth ,height: screenHeight / 2 - 50)
            
            if(i == 5 || i == 6){
                dailyCounterViewDayTextArray[i].frame = CGRect(x: screenWidth * CGFloat(i)+(screenWidth/2 - 20) , y: 0, width: screenWidth, height: 50)
            } else {
                dailyCounterViewDayTextArray[i].frame = CGRect(x: screenWidth * CGFloat(i) + 75, y: 0, width: screenWidth, height: 50)
            }
            
            dailyCounterViewArray[i].backgroundColor = UIColor.clear
            dailyCounterViewDayTextArray[i].font = dailyCounterViewDayTextArray[i].font.withSize(30)
        }
        
        for i in 0...6 {
            let centerY = dailyCounterViewArray[i].bounds.height / 2
            dailyCounterViewTextArray[i].frame = CGRect(x: screenWidth / 2 - 35 , y: centerY - 20 , width:screenWidth, height: 50 )
            dailyCounterViewTextArray[i].font = dailyCounterViewTextArray[i].font.withSize(30)
            
            goalTextArray[i].frame = CGRect(x: screenWidth / 2 - 35  ,y:centerY + 50  ,width: screenWidth ,height: 50)
        }
        
        for i in 0...6{
            dailyCounterViewArray[i].addSubview(dailyCounterViewTextArray[i])
            dailyCounterViewArray[i].addSubview(goalTextArray[i])
        }
    
        for i in 0...6{
            mainScrollView.addSubview(dailyCounterViewArray[i])
            mainScrollView.addSubview(dailyCounterViewDayTextArray[i])
        }
        
        mainScrollView.contentSize = CGSize(width: screenWidth * 7, height: screenHeight / 2)
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.isPagingEnabled = true


        mainScrollView.setContentOffset(CGPoint(x:screenWidth * 6, y: 0), animated: true)
        


        self.view.addSubview(mainScrollView)
        self.view.addSubview(graphView)
        
        self.mainScrollView.delegate = self
        
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
                LocationService.sharedInstance.sendLocationToServer()
            }
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width: CGFloat = self.mainScrollView.frame.size.width
        let page: Int = Int(self.mainScrollView.contentOffset.x / width)
    }

    func draw() {

        for index in 0...6 {
            if UserSettingManager.sharedInstance.getUserSetting().items.count != 0 {
                let userGoal = UserSettingManager.sharedInstance.getUserSetting().items.last?.dailyGoal
                self.dailyCounterViewArray[index].setGoal(Int(userGoal!)!)
                self.goalTextArray[index].text = "\(Int(userGoal!)!)"
            } else {
                self.dailyCounterViewArray[index].setGoal(10000)
                self.goalTextArray[index].text = "10000"
            }
            
            self.dailyCounterViewArray[index].setNeedsDisplay()
        }
    }
    
}

