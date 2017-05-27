//
//  LocationService.swift
//  
//
//  Created by junwoo on 2017. 5. 27..
//
//

import Foundation
import CoreLocation
import RealmSwift
import CoreLocation
import CoreMotion

class LocationService: NSObject, CLLocationManagerDelegate {
    static let sharedInstance: LocationService = {
        let instance = LocationService()
        return instance
    }()
    
    var locationManager: CLLocationManager?
    var motionActivityManager = CMMotionActivityManager()
    var currentLocation: CLLocation?
    let calendar = Calendar.current
    var calenderManager = CalenderManager()
    var serverManager = ServerManager()
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //매일 12시30분에 걸음수 체크해서 알림 팝업
        let date = Date()
        if calendar.component(.hour, from: date) == 12 && calendar.component(.minute, from: date) == 30 {
            var ratioOfGoal = Double()
            if UserSettingManager.sharedInstance.getUserSetting().items.count != 0 {
                ratioOfGoal = Double(StepManager.sharedInstance.getWeeklyStepsDic()[6]!) / Double((UserSettingManager.sharedInstance.getUserSetting().items.last?.dailyGoal)!)!
            } else {
                ratioOfGoal = 0.5
            }
            
            switch ratioOfGoal {
            case 0..<0.5:
                NotificationCenter.default.post(name: Notification.Name("starter"), object: nil)
            case 0.5..<0.9:
                NotificationCenter.default.post(name: Notification.Name("almost"), object: nil)
            default:
                NotificationCenter.default.post(name: Notification.Name("done"), object: nil)
            }
        }
        
        //걷거나 뛸때에 좌표를 realm에 저장
        if CMMotionActivityManager.isActivityAvailable() {
            motionActivityManager.startActivityUpdates(to: OperationQueue.current!, withHandler: { activityData in
                if activityData!.walking == true || activityData!.running == true {
                    guard let testLatitude: Double = self.locationManager?.location?.coordinate.latitude
                        else {
                            return
                    }
                    guard let testLongitude: Double = self.locationManager?.location?.coordinate.longitude
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
        guard let testLatitude: Double = LocationService.sharedInstance.locationManager?.location?.coordinate.latitude
            else {
                return
        }
        guard let testLongitude: Double = LocationService.sharedInstance.locationManager?.location?.coordinate.longitude
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
