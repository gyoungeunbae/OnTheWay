//
//  RegisterManger.swift
//  OnTheWayMain
//
//  Created by lee on 2017. 5. 1..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation
import Alamofire

class ServerManager {

    func registerReq(email: String, password: String, username: String, callback: @escaping (_ isUser: Bool) -> Void) {

        var isUser = Bool()

        let url = URL(string: "http://localhost:8080/ontheway/user/register")

        let parameters: Parameters = [
            "email": email,
            "password": password,
            "username": username
        ]

        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            print(response)
            if let res = response.result.value as? [String : Any] {
                if let value = res["message"] as? Bool {
                    isUser = value
                }
            }
            callback(isUser)
        }
    }

    func loginReq(email: String, password: String, callback: @escaping (_ isUser: Bool) -> Void) {

        var isUser = Bool()

        let url = URL(string: "http://localhost:8080/ontheway/user/login")

        let parameters: Parameters = [
            "email": email,
            "password": password
        ]

        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            if let res = response.result.value as? [String : Any] {
                if let value = res["message"] as? Bool {
                    isUser = value
                }
            }
            callback(isUser)
        }
    }

    func findPasswordByEmail(email: String, callback: @escaping (_ password: String) -> Void) {
        var password = String()

        let url = URL(string: "http://localhost:8080/ontheway/user/email")

        let parameters: Parameters = [
            "email": email
        ]

        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            if let res = response.result.value as? [String : Any] {
                if let value = res["password"] as? String {
                    password = value
                    callback(password)
                }
            }

            if response.error != nil {
                print(response.error)
            }

        }
    }

    func logout() {
        let urlString = "http://localhost:8080/ontheway/user/logout"
        Alamofire.request(urlString)

    }

    func getSession(completion: @escaping(User) -> Void) {
        print("aaa")
        let urlString = "http://localhost:8080/ontheway/user/login"

        Alamofire.request(urlString)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                print("response = \(response)")
                var user = User()
                if let json = response.result.value as? [String:Any] {
                    print("JSON: \(json)")
                    user = User(email: json["email"] as! String, password: json["password"] as! String, username: json["username"] as! String, image: json["image"] as! String)
                    completion(user)
                } else {
                    print("no server connection.")
                }
        }
    }
    
    static func uploadImage(email: String, password: String, username: String, image: String, completion: @escaping (User) -> Void) {
        let urlString = "http://localhost:8080/ontheway/user/upload" + username
        let headers = [
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "image": image,
            "username": username
        ]
        Alamofire.request(urlString, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                if let rawJSON = response.result.value as? [String: Any], let rawUser = rawJSON["user"] as? [String: Any] {
                    guard let username = rawUser["_username"] as? String, let image = rawUser["image"] as? String, let email = rawUser["email"] as? String, let password = rawUser["password"] as? String else { return }
                    let user = User(email: email, password: password, username: username, image: image)
                    completion(user)
                }
        }
        
    }

}
