//
//  UserSetting.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 16..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation
import RealmSwift

class SettingList: Object {
    dynamic var email = ""
    var items = List<Setting>()
    
    //    override static func primaryKey() -> String? {
    //        return "email"
    //    }
}

class Setting: Object {
    dynamic var dailyGoal = String()
    dynamic var notification = String()
}

