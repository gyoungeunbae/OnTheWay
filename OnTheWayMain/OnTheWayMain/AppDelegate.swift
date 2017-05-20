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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var serverManager = ServerManager()
    
    var userSettingManager = UserSettingManager.sharedInstance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().barTintColor = UIColor.clear
        UINavigationBar.appearance().tintColor = UIColor.white

        NotificationCenter.default.addObserver(self, selector: #selector(scheduleNotification), name: Notification.Name("notificationOn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeNotification), name: Notification.Name("notificationOff"), object: nil)
        
        let center = UNUserNotificationCenter.current()
        
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
            
            UserManager.sharedInstance.addUser(user)
            print("session is \(user)")
            
            //로그인한 유저의 세팅을 realm에서 불러와서 넣어놓기
            let realm = try! Realm()
            let results = realm.objects(SettingList.self).filter("email == '\(user.email)'")
            if results.count != 0 {
                self.userSettingManager.updateUserSetting(user: user, dailyGoal: (results.last?.items.last?.dailyGoal)!, notification: (results.last?.items.last?.notification)!)
            }
            let storyboard: UIStoryboard = UIStoryboard(name: "connect", bundle: nil)
            let tabBarVC = storyboard.instantiateViewController(withIdentifier: "tabBarVC")
            self.window?.rootViewController?.present(tabBarVC, animated: true, completion: nil)
        }

        return true
    }
    
    func removeNotification() {
        print("notification Off")
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    func scheduleNotification() {
        print("notification On")
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Don't be late Thomas!"
        content.body = "smith is waiting for you!"
        
        
        var dateComponents = DateComponents()
        dateComponents.hour = 14
        dateComponents.minute = 37
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
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)

        return handled
    }

}
