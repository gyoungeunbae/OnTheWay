//
//  UserLocation.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 8..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation
import RealmSwift

class LocationList: Object {
    dynamic var email = ""
    let items = List<Location>()

//    override static func primaryKey() -> String? {
//        return "email"
//    }
}

class Location: Object {
    dynamic var date = String()
    dynamic var latitude = Double()
    dynamic var longtitude = Double() 
}
