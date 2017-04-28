//
//  AccountViewController.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 4. 28..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /// 페이스북 토큰 유무
    fileprivate let isFacebookLogin: Bool = {
        return FBSDKAccessToken.current() != nil
    }()

    
    @IBAction func goToMainBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "mainVC")
        self.present(mainVC, animated: false, completion: nil)
        
    }

    @IBAction func logoutBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        self.present(loginVC, animated: false, completion: nil)
    }

}
