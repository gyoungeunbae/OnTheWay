//
//  LoginViewController.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 4. 27..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let accountVC = storyboard.instantiateViewController(withIdentifier: "accountVC")
        
        //최근 로그인 된 상태이면 accountView 뿌려주기
        if ((FBSDKAccessToken.current()) != nil) {
            self.present(accountVC, animated: false, completion: nil)
        }
   
    }
    
        
    @IBAction func loginWithEmail(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        PassportService.requestLogin(email: email, password: password, completion: { idString in
            print("11111111111111")
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = storyboard.instantiateViewController(withIdentifier: "mainVC")
            self.present(mainVC, animated: false, completion: nil)
        })
        
    }

        
          
    //페이스북 로그인 버튼
    @IBAction func loginWithFacebook(_ sender: Any) {
        let readPermissions = ["public_profile"]
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: readPermissions, from: self) { (result, error) in
            if ((error) != nil){
                print("login failed with error: \(String(describing: error))")
            } else if (result?.isCancelled)! {
                print("login cancelled")
            } else {
                //present the account view controller
                let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                let accountVC = storyboard.instantiateViewController(withIdentifier: "accountVC")
                self.present(accountVC, animated: false, completion: nil)
            }
        }
    }
    
}

