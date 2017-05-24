//
//  AppDelegate.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 4. 22..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import RealmSwift
import Kingfisher
import UserNotifications
import HealthKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var serverManager = ServerManager()
    var calenderManager = CalenderManager()
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(UIApplication.shared.backgroundRefreshStatus == .available)
        
        //걸음수 요청
        requestHealthKitAuthorization()
        
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().barTintColor = UIColor.clear
        UINavigationBar.appearance().tintColor = UIColor.white

        NotificationCenter.default.addObserver(self, selector: #selector(scheduleNotification), name: Notification.Name("notificationOn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeNotification), name: Notification.Name("notificationOff"), object: nil)
        
        let center = UNUserNotificationCenter.current()
        
        //notification 승인 요청
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("granted")
                self.scheduleNotification()
            } else {
                print("notification reject")
            }
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        UITabBar.appearance().tintColor = UIColor.black

        //세션 유지

        serverManager.getSession { (user) in
            
            //UserManager에 넣기
            UserManager.sharedInstance.addUser(user)
            
            //로그인한 유저의 세팅을 realm에서 불러와서 넣어놓기
            let realm = try! Realm()
            let email = user.email!
            let results = realm.objects(SettingList.self).filter("email == '\(email)'")
            if results.count != 0 {
                //UserSettingManager 에 넣기
                UserSettingManager.sharedInstance.updateUserSetting(user: user, dailyGoal: (results.last?.items.last?.dailyGoal)!, notification: (results.last?.items.last?.notification)!)
                print("setting into usersettingmanager")
                
            } 
            let storyboard: UIStoryboard = UIStoryboard(name: "connect", bundle: nil)
            let tabBarVC = storyboard.instantiateViewController(withIdentifier: "tabBarVC")
            self.window?.rootViewController?.present(tabBarVC, animated: true, completion: nil)
        }

        return true
    }
    
    
    
    //건강데이터 요청 메소드
    func requestHealthKitAuthorization() {
        
        let dataTypesToRead = NSSet(objects: HealthKitManager.sharedInstance.stepsCount as Any)
        
        HealthKitManager.sharedInstance.healthStore?.requestAuthorization(toShare: nil, read: dataTypesToRead as? Set<HKObjectType>, completion: { [unowned self] (success, error) in
            if success {
                
                for i in 0...6 {
                    self.dailyStepQuery(indexOfDay: i)
                }
                
            } else {
                print("healthkit request fail")
            }
        })
    }
    
    //이번주 일주일 걸음수 요청
    func dailyStepQuery(indexOfDay: Int) {
        
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let weekArr = calenderManager.getLastWeekArr()
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
            
            StepManager.sharedInstance.updateWeeklySteps(indexOfDay: indexOfDay, steps: steps)
        }
        
        HealthKitManager.sharedInstance.healthStore?.execute(query)
        
    }

    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Don't be late Thomas!"
        content.body = "smith is waiting for you!"
        
        
        var dateComponents = DateComponents()
        dateComponents.hour = 08
        dateComponents.minute = 00
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "MorningAlarm", content: content, trigger: trigger)
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)

        return handled
    }
    
        

}
