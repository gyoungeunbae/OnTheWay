//
//  RegisterManger.swift
//  OnTheWayMain
//
//  Created by lee on 2017. 5. 1..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation
import Alamofire

class ServerManager{

    func registerReq(email: String, password: String, username:String,  callback: @escaping (_ isUser: Bool) -> Void) {
        
        var isUser = Bool()
        
        let url = URL(string: "http://localhost:8000/ontheway/user/register")
        
        
        let parameters: Parameters = [
            "email" : email,
            "password" : password,
            "username" : username
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
}
