import UIKit
import HealthKit
import RealmSwift
import CoreLocation
import CoreMotion

class MainViewController: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var walkRecordLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var serverManager = ServerManager()
    var calenderManager = CalenderManager()
    var graphView = GraphView()
    var motionActivityManager = CMMotionActivityManager()
    var locationManager = CLLocationManager()
    let calendar = Calendar.current
    
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
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if CLLocationManager.authorizationStatus() == .denied {
            let alert = UIAlertController(title: "Alert", message: "Location services were previously denied. Please enable location services for this app in Settings.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        } else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        
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
                self.sendLocationToServer()
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
    
    //location manager에서 정보 받기
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let date = Date()
        if calendar.component(.hour, from: date) == 12 && calendar.component(.minute, from: date) == 30 {
            let ratioOfGoal:Double = Double(StepManager.sharedInstance.getWeeklyStepsDic()[6]!) / Double((UserSettingManager.sharedInstance.getUserSetting().items.last?.dailyGoal)!)!
            switch ratioOfGoal {
            case 0..<0.5:
                NotificationCenter.default.post(name: Notification.Name("starter"), object: nil)
            case 0.5..<0.9:
                NotificationCenter.default.post(name: Notification.Name("almost"), object: nil)
            default:
                NotificationCenter.default.post(name: Notification.Name("done"), object: nil)
            }
        }
        
        if CMMotionActivityManager.isActivityAvailable() {
            motionActivityManager.startActivityUpdates(to: OperationQueue.current!, withHandler: { activityData in
                if activityData!.walking == true || activityData!.running == true {
                    guard let testLatitude: Double = self.locationManager.location?.coordinate.latitude
                        else {
                            return
                    }
                    guard let testLongitude: Double = self.locationManager.location?.coordinate.longitude
                        else {
                            return
                    }
                    let realm = try? Realm()
                    realm?.beginWrite()
                    let locationRealm = LocationRealm()
                    locationRealm.latitude = testLatitude
                    locationRealm.longitude = testLongitude
                    locationRealm.date = self.calenderManager.getKoreanStr(todayDate: Date())
                    realm?.add(locationRealm)
                    try! realm?.commitWrite()
                    print("save into realm")
                    
                    if UIApplication.shared.applicationState == .active {
                        print("app is active")
                        NotificationCenter.default.post(name: Notification.Name("locationDraw"), object: nil)
                        //self.sendLocationToServer()
                    } else {
                        print("app is not active")
                    }
                } else {
                    print("not walking")
                }
            })
        }
        
    }
    
    //현재위치 좌표를 서버에 업데이트
    func sendLocationToServer() {
        guard let testLatitude: Double = self.locationManager.location?.coordinate.latitude
            else {
                return
        }
        guard let testLongitude: Double = self.locationManager.location?.coordinate.longitude
            else {
                return
        }
        let user = UserManager.sharedInstance.getUser()
        let steps = StepManager.sharedInstance.getWeeklyStepsDic()[6]
        
        serverManager.coordinatesUpdate(userId: user[0].id!, latitude: testLatitude, longitude: testLongitude, steps: steps!) { (friends) in
            for friend in friends {
                FriendsManager.sharedInstance.addFriends(friend)
            }
            print("coordinate update")
        }
    }
}

