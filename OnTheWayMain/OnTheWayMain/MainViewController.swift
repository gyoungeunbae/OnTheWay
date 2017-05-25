import UIKit
import HealthKit
import RealmSwift


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
    // 뷰 전체 폭 길이
    let screenWidth = UIScreen.main.bounds.size.width
    // 뷰 전체 높이 길이
    let screenHeight = UIScreen.main.bounds.size.height
    let weeklyStepsDic = StepManager.sharedInstance.getWeeklyStepsDic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(draw), name: Notification.Name("goalChanged"), object: nil)

        DispatchQueue.main.async {
            
            for indexOfDay in self.weeklyStepsDic.keys {
                
                let steps:Int = self.weeklyStepsDic[indexOfDay]!
                
                StepManager.sharedInstance.updateWeeklySteps(indexOfDay: indexOfDay, steps: steps)
                
                self.dailyCounterViewArray[indexOfDay].stepOfWalked = steps
                self.graphView.graphValues[indexOfDay] = CGFloat(steps)
                
                self.graphView.graphValues[indexOfDay] = CGFloat(steps)
                self.dailyCounterViewArray[indexOfDay].stepOfWalked = steps
                self.dailyCounterViewTextArray[indexOfDay].text = "\(steps)"
                
                self.graphView.setNeedsDisplay()
                self.dailyCounterViewArray[indexOfDay].setNeedsDisplay()
            }
        }
        
        print(weeklyStepsDic)

        
        for _ in 0...6 {
            dailyCounterViewArray.append(CounterView())
            dailyCounterViewTextArray.append(UILabel())
        }
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight / 2)
        
        graphView.frame = CGRect(x: 0, y: self.view.frame.height / 2 , width: self.view.frame.width, height: self.view.frame.height / 2)
        graphView.backgroundColor = UIColor.clear
    
        for i in 0...6 {
            dailyCounterViewArray[i].frame = CGRect(x: screenWidth * CGFloat(i)  ,y: 0 ,width: screenWidth ,height: screenHeight / 2)
            dailyCounterViewArray[i].backgroundColor = UIColor.clear
        }
        
        for i in 0...6 {
            dailyCounterViewTextArray[i].frame = CGRect(x: screenWidth / 2 - 30 , y: 0, width:screenWidth, height:screenHeight/2 )

            dailyCounterViewTextArray[i].font = dailyCounterViewTextArray[i].font.withSize(30)
        }
        
        for i in 0...6{
            dailyCounterViewArray[i].addSubview(dailyCounterViewTextArray[i])
        }
    
        for i in 0...6{
            mainScrollView.addSubview(dailyCounterViewArray[i])
        }
        
        mainScrollView.contentSize = CGSize(width: screenWidth * 7, height: screenHeight / 2)
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.isPagingEnabled = true



        mainScrollView.setContentOffset(CGPoint(x:screenWidth * 6, y: 0), animated: true)
        

        self.view.addSubview(mainScrollView)

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
    
            }
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width: CGFloat = self.mainScrollView.frame.size.width
        let page: Int = Int(self.mainScrollView.contentOffset.x / width)
    }
    

    func draw() {
        for counterView in self.dailyCounterViewArray {
            counterView.setNeedsDisplay()
        }
        
    }
}

