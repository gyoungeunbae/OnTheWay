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
import Alamofire


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    var pushServerLogin = ServerManager()
    
    
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.pwdTextField.delegate = self
        self.emailTextField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardUP(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDown(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let accountVC = storyboard.instantiateViewController(withIdentifier: "accountVC")
        
        //최근 로그인 된 상태이면 accountView 뿌려주기
        if ((FBSDKAccessToken.current()) != nil) {
            self.present(accountVC, animated: false, completion: nil)
        }
   
    }
    

        
//    @IBAction func loginWithEmail(_ sender: Any) {
//        guard let email = emailTextField.text, !email.isEmpty else { return }
//        guard let password = passwordTextField.text, !password.isEmpty else { return }
//        
//        PassportService.requestLogin(email: email, password: password, completion: { idString in
//            print("11111111111111")
//            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let mainVC = storyboard.instantiateViewController(withIdentifier: "mainVC")
//            self.present(mainVC, animated: false, completion: nil)
//        })
//        
//    }

        
          

    func keyboardUP(notification: Notification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= 80
        }
    }
    
    func keyboardDown(notification: Notification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.view.frame.origin.y = 0
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.endEditing(true)
        pwdTextField.endEditing(true)
    }
    
    @IBAction func registerBnt(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Register", bundle: nil)
        let registerVC = storyboard.instantiateViewController(withIdentifier: "registerVC")
        
        self.present(registerVC, animated: true, completion: nil)
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField.isEqual(self.emailTextField)){
            self.pwdTextField.becomeFirstResponder() //다음 텍스트 필드로 포커스 이동
        }
        return true
    }
    
    
    @IBAction func loginBnt(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "mainVC")
        let alert = UIAlertController(title: "Alert", message: "이메일이나 비밀번호를 확인해주세요", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))

        pushServerLogin.loginReq(email: emailTextField.text!, password: pwdTextField.text!) { (isUser) in
            if isUser == true {
                self.present(mainVC, animated: true, completion: nil)
            } else {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func forgetPasswordButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let forgetPasswordVC = storyboard.instantiateViewController(withIdentifier: "forgetPasswordVC")
        self.present(forgetPasswordVC, animated: false, completion: nil)

    }
    
}

