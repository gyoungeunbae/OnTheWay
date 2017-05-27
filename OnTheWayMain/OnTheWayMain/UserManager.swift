//
//  UserManager.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 16..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation

struct UserManager {
    //싱글톤
    static var sharedInstance = UserManager()
    private var users = [User]()
    
    //로그인시 내 정보 넣기
    mutating func addUser(_ newUser: User) {
        self.users.append(newUser)
    }
    
    //내정보 가져오기
    func getUser() -> [User] {
        return self.users
    }
    
    mutating func removeUser() {
        self.users.removeAll()
    }
    
    mutating func updateUsername(username: String) {
        self.users[0].updateUsername(username: username)
    }
}
