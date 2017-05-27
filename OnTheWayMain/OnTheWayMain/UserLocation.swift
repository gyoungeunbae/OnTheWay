//
//  UserLocation.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 8..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation
import RealmSwift

class LocationRealm: Object {
    dynamic var date = String()
    dynamic var latitude = Double()
    dynamic var longitude = Double()
}
