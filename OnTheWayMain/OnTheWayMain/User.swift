//
//  User.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 8..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation

struct User {
    
    var id: String!
    var email: String!
    var password: String!
    var username: String!
    var image: String!
    
    mutating func updateUsername(username: String) {
        self.username = username
    }
}
