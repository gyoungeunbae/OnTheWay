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
    private var user = User()
    
    //로그인시 내 정보 넣기
    mutating func updateUser(_ newUser: User) {
        self.user = newUser
    }
    
    //내정보 가져오기
    func getUser() -> User {
        return self.user
    }
    
}
