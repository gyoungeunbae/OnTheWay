//
//  PassportManager.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 3..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation

//싱글톤자판기
struct PassportManager {
    //싱글톤
    static var sharedInstance = PassportManager()
    private var passports = [Passport]()
    
    //1개 넣기
    mutating func addPassport(_ passport: Passport) {
        self.passports.insert(passport, at: 0)
        //넣으면 뷰에 알려주기
        print("user added : \(self.passports)" )
        NotificationCenter.default.post(name: Notification.Name("changed"), object: nil)
        
    }
    
    //통째로 가져오기
    func getPassports() -> [Passport] {
        return self.passports
    }
    
    //1개 변경
    mutating func updatePassports(_ index: Int, _ passport: Passport) {
        self.passports[index] = passport
        NotificationCenter.default.post(name: Notification.Name("changed"), object: nil)
    }
    
    //1개 삭제
    mutating func removePassport(_ index: Int) {
        self.passports.remove(at: index)
        NotificationCenter.default.post(name: Notification.Name("changed"), object: nil)
    }
    
    //통째로 넣기
    mutating func setPassports(_ passportsArray: [Passport]) {
        self.passports = passportsArray
    }
}
