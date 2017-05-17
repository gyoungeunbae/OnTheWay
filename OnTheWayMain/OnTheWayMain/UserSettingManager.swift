//
//  UserSettingManager.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 16..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation

struct UserSettingManager {
    
    //싱글톤
    static var sharedInstance = UserSettingManager()
    private var settingList = SettingList()
    
    func updateUserSetting(user: User, dailyGoal: String, notification: String) {
        self.settingList.email = user.email
        self.settingList.items.last?.dailyGoal = dailyGoal
        self.settingList.items.last?.notification = notification
    }
    
    //내정보 가져오기
    func getUserSetting() -> SettingList {
        return self.settingList
    }
    
}
