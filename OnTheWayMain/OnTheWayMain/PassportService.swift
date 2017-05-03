//
//  loginService.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 3..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation
import Alamofire

struct PassportService {
    
    static func logout() {
        let urlString = "http://localhost:3000/ontheway/logout"
        
        Alamofire.request(urlString)
    }

    
    //서버야 포스트 다 가져와봐
    static func getSession(completion: @escaping(String) -> Void) {
        let urlString = "http://localhost:3000/ontheway/main"
        
        Alamofire.request(urlString)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                print("3333333333333333")
                if let json = response.result.value as? [String: String] {
                    //서버에 요청 성공하면 id를 completion handler 에 투입하기
                    print("44444444444444444444")
                    completion(json["id"]!)
                }
                
                if (response.error != nil) {
                    print("5555555555555555555")
                }
        }
    }

    
    
    static func requestLogin(email: String, password: String, completion: @escaping (String) -> Void) {
        let urlString = "http://localhost:3000/ontheway/login"
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            ]
        let parameters: [String:Any] = [
            "email" : email,
            "password" : password
        ]
        print("2222222222222222")
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                print("3333333333333333")
                if let json = response.result.value as? [String: String] {
                    //서버에 요청 성공하면 id를 completion handler 에 투입하기
                    print("44444444444444444444")
                    completion(json["id"]!)
                }
                
                if (response.error != nil) {
                    print("5555555555555555555")
                }
        }
    }
    
    static func requestRegister(username: String, email: String, password: String, completion: @escaping (String) -> Void) {
        let urlString = "http://localhost:3000/ontheway/register"
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            ]
        let parameters: [String:Any] = [
            "username": username,
            "email" : email,
            "password" : password
        ]
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                print(response)
                if let json = response.result.value as? [String: String] {
                    //서버에 요청 성공하면 id를 completion handler 에 투입하기
                    print(json)
                    completion(json["id"]!)
                }
                
                if (response.error != nil) {
                    print(response.error)
                }
        }
    }

    

    
}
