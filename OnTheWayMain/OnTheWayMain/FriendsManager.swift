//
//  FriendsManager.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 27..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation
struct FriendsManager {
    //싱글톤
    static var sharedInstance = FriendsManager()
    private var friends = [Friends]()
    
    //로그인시 내 정보 넣기
    mutating func addFriends(_ newFriends: Friends) {
        self.friends.append(newFriends)
    }
    
    //내정보 가져오기
    func getFriends() -> [Friends] {
        return self.friends
    }
    
    mutating func removeFriends() {
        self.friends.removeAll()
    }
    
}
