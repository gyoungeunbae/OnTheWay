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
    var lineGraphView = LineGraphView()
    
    var currentValue: Int = 6
    
    
    
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
    var dayTextArray = [UILabel]()
    
    let screenWidth = UIScreen.main.bounds.size.width
    // 뷰 전체 높이 길이
    let screenHeight = UIScreen.main.bounds.size.height
    let weeklyStepsDic = StepManager.sharedInstance.getWeeklyStepsDic()
    let subBackgroundView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        let thisWeek = self.calenderManager.getLastWeekArr()
        
        subBackgroundView.frame = CGRect(x: 0, y: self.view.frame.height / 2 + 50 , width: self.view.frame.width, height: self.view.frame.height / 3 - 50)
        subBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.addSubview(subBackgroundView)
        
        LocationService.sharedInstance.startUpdatingLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(draw), name: Notification.Name("goalChanged"), object: nil)
        
        DispatchQueue.main.async {
            
            for indexOfDay in self.weeklyStepsDic.keys {
                
                let steps:Int = self.weeklyStepsDic[indexOfDay]!
                let today = self.calenderManager.getDayArr(todayDate: thisWeek[indexOfDay])
                
                StepManager.sharedInstance.updateWeeklySteps(indexOfDay: indexOfDay, steps: steps)
                self.dailyCounterViewDayTextArray[indexOfDay].textColor = UIColor.white
                //self.dailyCounterViewDayTextArray[indexOfDay].font = UIFont.boldSystemFont(ofSize: 23)
                
                self.dailyCounterViewArray[indexOfDay].stepOfWalked = steps
                self.lineGraphView.graphValues[indexOfDay] = CGFloat(steps)
                
                self.lineGraphView.graphValues[indexOfDay] = CGFloat(steps)
                self.dailyCounterViewArray[indexOfDay].stepOfWalked = steps
                self.dailyCounterViewTextArray[indexOfDay].text = "\(steps)"
                
                
                switch today {
                    
                case 1:
                    self.dayTextArray[indexOfDay].text = "일"
                case 2:
                    self.dayTextArray[indexOfDay].text = "월"
                case 3:
                    self.dayTextArray[indexOfDay].text = "화"
                case 4:
                    self.dayTextArray[indexOfDay].text = "수"
                case 5:
                    self.dayTextArray[indexOfDay].text = "목"
                case 6:
                    self.dayTextArray[indexOfDay].text = "금"
                case 7:
                    self.dayTextArray[indexOfDay].text = "토"
                default:
                    print("error")
                }
                
                
                if(indexOfDay == 5){
                    self.dailyCounterViewDayTextArray[indexOfDay].text = "어제"
                    self.dailyCounterViewDayTextArray[indexOfDay].textColor = UIColor.white
                } else if(indexOfDay == 6) {
                    self.dailyCounterViewDayTextArray[indexOfDay].text = "오늘"
                    self.dailyCounterViewDayTextArray[indexOfDay].textColor = UIColor.white
                } else {
                    self.dailyCounterViewDayTextArray[indexOfDay].text = "\(self.calenderManager.getTimeString(todayDate: thisWeek[indexOfDay]))"
                    self.dailyCounterViewDayTextArray[indexOfDay].textColor = UIColor.white
                }
                self.goalTextArray[indexOfDay].text = "\(self.dailyCounterViewArray[indexOfDay].getGoal())"
                
                
                self.draw()
                
                self.backgroundImageView.setNeedsDisplay()
                self.lineGraphView.setNeedsDisplay()
                self.dailyCounterViewArray[indexOfDay].setNeedsDisplay()
            }
        }
        
        for _ in 0...6 {
            dailyCounterViewArray.append(CounterView())
            dailyCounterViewTextArray.append(UILabel())
            dailyCounterViewDayTextArray.append(UILabel())
            goalTextArray.append(UILabel())
            dayTextArray.append(UILabel())
        }
        
        mainScrollView.frame = CGRect(x: 0, y: 30, width: screenWidth, height: screenHeight / 2)
        mainScrollView.backgroundColor = UIColor.clear
        
        lineGraphView.frame = CGRect(x: 0, y: self.view.frame.height / 2 + 110 , width: self.view.frame.width, height: self.view.frame.height / 2)
        lineGraphView.backgroundColor = UIColor.clear

        
        for i in 0...6 {
            dailyCounterViewArray[i].frame = CGRect(x: screenWidth * CGFloat(i)  ,y: 30 ,width: screenWidth ,height: screenHeight / 2 - 50)
            
            if(i == 5 || i == 6){
                dailyCounterViewDayTextArray[i].frame = CGRect(x: screenWidth * CGFloat(i)+(screenWidth/2 - 20) , y: 0, width: screenWidth, height: 50)
                dailyCounterViewDayTextArray[i].center.x = dailyCounterViewTextArray[i].center.x
                
            } else {
                dailyCounterViewDayTextArray[i].frame = CGRect(x: screenWidth * CGFloat(i)+(screenWidth/2 - 40) , y: 0, width: screenWidth, height: 50)
            //dailyCounterViewDayTextArray[i].center.x = self.view.center.x
                dailyCounterViewDayTextArray[i].center.x = dailyCounterViewTextArray[i].center.x
                
            }
            
            dailyCounterViewArray[i].backgroundColor = UIColor.clear
            dailyCounterViewDayTextArray[i].font = dailyCounterViewDayTextArray[i].font.withSize(30)
            dailyCounterViewDayTextArray[i].center.x = dailyCounterViewArray[i].center.x
            
        }
        
        for i in 0...6 {
            let centerY = dailyCounterViewArray[i].bounds.height / 2
            let valueGap = Int((self.lineGraphView.bounds.size.width) / 7)
            dailyCounterViewTextArray[i].frame = CGRect(x: screenWidth / 2 - 35 , y: centerY - 20 , width:screenWidth, height: 50 )
            
            dailyCounterViewTextArray[i].font = dailyCounterViewTextArray[i].font.withSize(30)
            dailyCounterViewTextArray[i].textColor = UIColor.white
            
            goalTextArray[i].frame = CGRect(x: screenWidth / 2 - 35  ,y:centerY + 50  ,width: screenWidth ,height: 50)
            
            dayTextArray[i].frame = CGRect(x: 23 + CGFloat(valueGap * i), y:screenHeight/2 + 85,width: 20 ,height: 20)
            dayTextArray[i].textColor = UIColor.white
            
            
        }
        
        
        for i in 0...6{
            dailyCounterViewArray[i].addSubview(dailyCounterViewTextArray[i])
            dailyCounterViewArray[i].addSubview(goalTextArray[i])
            
        }
        
        for i in 0...6{
            mainScrollView.addSubview(dailyCounterViewArray[i])
            mainScrollView.addSubview(dailyCounterViewDayTextArray[i])
            self.view.addSubview(dayTextArray[i])
        }
        
        mainScrollView.contentSize = CGSize(width: screenWidth * 7, height: screenHeight / 2)
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.isPagingEnabled = true
        mainScrollView.setContentOffset(CGPoint(x:screenWidth * 6, y: 0), animated: true)
        
        self.view.addSubview(mainScrollView)
        self.view.addSubview(lineGraphView)
        self.mainScrollView.delegate = self
        
        
        self.animation(value: currentValue)
        scrollViewDidEndDecelerating(mainScrollView)
        
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let point = touch.location(in:self.view)
        let pointX = point.x
        let pointY = point.y
        let gapValue = CGFloat(Int((view.frame.width - 60) / 6))/2
        
        if(pointY > view.frame.height / 2 + 110) {
            if(pointX < 30 + gapValue) {
                
                mainScrollView.setContentOffset(CGPoint(x:screenWidth * 0, y: 0), animated: false)
                lineGraphView.setSelectedDayLine(value: 0)
                animation(value: 0)
                lineGraphView.setNeedsDisplay()
                
            } else if(pointX < (30 + gapValue) + gapValue * 2) {
                
                mainScrollView.setContentOffset(CGPoint(x:screenWidth * 1, y: 0), animated: false)
                lineGraphView.setSelectedDayLine(value: 1)
                animation(value: 1)
                lineGraphView.setNeedsDisplay()
                
            } else if(pointX < (30 + gapValue) + gapValue * 4) {
                
                mainScrollView.setContentOffset(CGPoint(x:screenWidth * 2, y: 0), animated: false)
                lineGraphView.setSelectedDayLine(value: 2)
                animation(value: 2)
                lineGraphView.setNeedsDisplay()
                
            } else if(pointX < (30 + gapValue) + gapValue * 6) {
                
                mainScrollView.setContentOffset(CGPoint(x:screenWidth * 3, y: 0), animated: false)
                lineGraphView.setSelectedDayLine(value: 3)
                animation(value: 3)
                lineGraphView.setNeedsDisplay()
                
            } else if(pointX < (30 + gapValue) + gapValue * 8) {
                
                mainScrollView.setContentOffset(CGPoint(x:screenWidth * 4, y: 0), animated: false)
                lineGraphView.setSelectedDayLine(value: 4)
                animation(value: 4)
                lineGraphView.setNeedsDisplay()
                
            } else if(pointX < (30 + gapValue) + gapValue * 10) {
                
                mainScrollView.setContentOffset(CGPoint(x:screenWidth * 5, y: 0), animated: false)
                lineGraphView.setSelectedDayLine(value: 5)
                animation(value: 5)
                lineGraphView.setNeedsDisplay()
                
            } else {
                
                mainScrollView.setContentOffset(CGPoint(x:screenWidth * 6, y: 0), animated: false)
                lineGraphView.setSelectedDayLine(value: 6)
                animation(value: 6)
                lineGraphView.setNeedsDisplay()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let point = touch.location(in:self.view)
        let pointX = point.x
        let pointY = point.y
        let gapValue = (view.frame.width / 7) / 2
        
        if(pointY > view.frame.height / 2 + 110) {
            if(pointX < 30 + gapValue) {
                
                mainScrollView.setContentOffset(CGPoint(x:screenWidth * 0, y: 0), animated: false)
                lineGraphView.setSelectedDayLine(value: 0)
                animation(value: 0)
                lineGraphView.setNeedsDisplay()
                
            } else if(pointX < (30 + gapValue) + gapValue * 2) {
                
                mainScrollView.setContentOffset(CGPoint(x:screenWidth * 1, y: 0), animated: false)
                lineGraphView.setSelectedDayLine(value: 1)
                animation(value: 1)
                lineGraphView.setNeedsDisplay()
                
            } else if(pointX < (30 + gapValue) + gapValue * 4) {
                
                mainScrollView.setContentOffset(CGPoint(x:screenWidth * 2, y: 0), animated: false)
                lineGraphView.setSelectedDayLine(value: 2)
                animation(value: 2)
                lineGraphView.setNeedsDisplay()
                
            } else if(pointX < (30 + gapValue) + gapValue * 6) {
                
                mainScrollView.setContentOffset(CGPoint(x:screenWidth * 3, y: 0), animated: false)
                lineGraphView.setSelectedDayLine(value: 3)
                animation(value: 3)
                lineGraphView.setNeedsDisplay()
                
            } else if(pointX < (30 + gapValue) + gapValue * 8) {
                
                mainScrollView.setContentOffset(CGPoint(x:screenWidth * 4, y: 0), animated: false)
                lineGraphView.setSelectedDayLine(value: 4)
                animation(value: 4)
                lineGraphView.setNeedsDisplay()
                
            } else if(pointX < (30 + gapValue) + gapValue * 10) {
                
                mainScrollView.setContentOffset(CGPoint(x:screenWidth * 5, y: 0), animated: false)
                lineGraphView.setSelectedDayLine(value: 5)
                animation(value: 5)
                lineGraphView.setNeedsDisplay()
                
            } else {
                
                mainScrollView.setContentOffset(CGPoint(x:screenWidth * 6, y: 0), animated: false)
                lineGraphView.setSelectedDayLine(value: 6)
                animation(value: 6)
                lineGraphView.setNeedsDisplay()
            }
        }
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width: CGFloat = self.mainScrollView.frame.size.width
        let page: Int = Int(self.mainScrollView.contentOffset.x / width)
        
        if(page == 0) {
            lineGraphView.setSelectedDayLine(value: 0)
            animation(value: 0)
            lineGraphView.setNeedsDisplay()
        } else if(page == 1) {
            lineGraphView.setSelectedDayLine(value: 1)
            animation(value: 1)
            lineGraphView.setNeedsDisplay()
        } else if(page == 2) {
            lineGraphView.setSelectedDayLine(value: 2)
            animation(value: 2)
            lineGraphView.setNeedsDisplay()
        } else if(page == 3) {
            lineGraphView.setSelectedDayLine(value: 3)
            animation(value: 3)
            lineGraphView.setNeedsDisplay()
        } else if(page == 4) {
            lineGraphView.setSelectedDayLine(value: 4)
            animation(value: 4)
            lineGraphView.setNeedsDisplay()
        } else if(page == 5) {
            lineGraphView.setSelectedDayLine(value: 5)
            animation(value: 5)
            lineGraphView.setNeedsDisplay()
        } else if(page == 6) {
            lineGraphView.setSelectedDayLine(value: 6)
            animation(value: 6)
            lineGraphView.setNeedsDisplay()
        }
    }
    
    func draw() {
        print("draw")
        for index in 0...6 {
            self.goalTextArray[index].textColor = UIColor.white
            self.goalTextArray[index].textAlignment = .left
            self.dailyCounterViewArray[index].counterColor = UIColor.white
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
    
    func animation(value: Int) {
        for index in 0...6 {
            
            if(value == index) {
                self.dayTextArray[index].textColor = .white
                
            } else {

                self.dayTextArray[index].textColor = .black
            }
        }
    }
    
    
}

