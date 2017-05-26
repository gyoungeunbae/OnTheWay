//
//  RegisterManger.swift
//  OnTheWayMain
//
//  Created by lee on 2017. 5. 1..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation
import Alamofire

struct ServerManager {

    func registerReq(email: String, password: String, username: String, callback: @escaping (_ isUser: Bool) -> Void) {

        var isUser = Bool()

        let url = URL(string: "http://localhost:8080/ontheway/register")

        let parameters: Parameters = [
            "email": email,
            "password": password,
            "username": username
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

    func loginReq(email: String, password: String, callback: @escaping (_ isUser: Bool) -> Void) {

        var isUser = Bool()

        let url = URL(string: "http://localhost:8080/ontheway/login")

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

        let url = URL(string: "http://localhost:8080/ontheway/email")

        let parameters: Parameters = [
            "email": email
        ]

        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            if let res = response.result.value as? [String : Any] {
                if let value = res["password"] as? String {
                    password = value
                    callback(password)
                } else {
                    password = res["message"] as! String
                    callback(password)
                }
            }
            
            if response.error != nil {
                print("error")
            }

        }
    }

    
    func logout() {
        let urlString = "http://localhost:8080/ontheway/logout"
        Alamofire.request(urlString)

    }

    func getSession(completion: @escaping(User) -> Void) {
        
        let urlString = "http://localhost:8080/ontheway/session"
        Alamofire.request(urlString)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                var user = User()
                if let json = response.result.value as? [String:Any] {
                    user = User(id: json["_id"] as! String, email: json["email"] as! String, password: json["password"] as! String, username: json["username"] as! String, image: json["image"] as! String)
                    completion(user)
                } else {
                    print("no server connection.")
                }
        }
    }
    
    //이미지를 업로드하고 이미지id를 user의 image에 업데이트
    func uploadImage(pickedImage:UIImage, userId: String, completion: @escaping (User) -> Void) {
        
        let url = "http://localhost:8080/ontheway/upload"
        
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            if let imageData = UIImageJPEGRepresentation(pickedImage, 0.6) {
                multipartFormData.append(imageData, withName: "image", fileName: "file.png", mimeType: "image/png")
            }
        }, to: url, method: .post, headers: nil, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    let dict = (response.result.value) as! NSDictionary
                    let path = dict["ok"]!
                    
                    // JSON Body
                    let body: [String : Any] = [
                    "image": "\(path)"
                    ]
                    
                    // Fetch Request
                    Alamofire.request("http://localhost:8080/ontheway/user/\(userId)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: nil)
                        .validate(statusCode: 200..<300)
                        .responseJSON { response in
                            var user = User()
                            if let json = response.result.value as? [String:Any] {
                                
                                user = User(id: json["_id"] as! String, email: json["email"] as! String, password: json["password"] as! String, username: json["username"] as! String, image: json["image"] as! String)
                                
                                completion(user)
                            } else {
                                print("no server connection.")
                            }
                    }
                }
            case .failure(let encodingError):
                print("encodingError")
            }
        })
    }
    
    
    
    func profileUpdate(userId: String, username: String, password: String, completion: @escaping (User) -> Void) {
        
        let body: [String : Any] = [
            "username": "\(username)",
            "password": "\(password)"
        ]
        
        // Fetch Request
        Alamofire.request("http://localhost:8080/ontheway/user/\(userId)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                var user = User()
                if let json = response.result.value as? [String:Any] {
                    
                    user = User(id: json["_id"] as! String, email: json["email"] as! String, password: json["password"] as! String, username: json["username"] as! String, image: json["image"] as! String)
                    
                    completion(user)
                } else {
                    print("no server connection.")
                }
        }
    }
       
    func coordinatesUpdate(userId: String, latitude: Double, longitude: Double, steps: Int, completion: @escaping ([Friends]) -> Void) {
        
        let body: [String : Any] = [
            "coordinates": [
                "\(longitude)",
                "\(latitude)"
            ],
            "steps": steps
        ]

        // Fetch Request
        Alamofire.request("http://localhost:8080/ontheway/user/\(userId)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error != nil) {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
                else {
                    debugPrint("HTTP Response Body: \(response.data)")
                    Alamofire.request("http://localhost:8080/ontheway/coordinates", method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                        .validate(statusCode: 200..<300)
                        .responseJSON { response in
                            var friends = Friends()
                            var friendsArr = [Friends]()
                            if let json = response.result.value as? [[String:Any]] {
                                for friend in json {
                                    friends = Friends(username: friend["username"] as! String, image: friend["image"] as! String, steps: friend["steps"] as! Int)
                                    friendsArr.append(friends)
                                }
                                completion(friendsArr)
                            } else {
                                print("no server connection.")
                            }

                    }
                }
        }
    
    }

}
