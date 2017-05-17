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
    var serverManager = ServerManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailTextField.delegate = self
        self.pwdTextField.delegate = self
        self.emailTextField.becomeFirstResponder()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardUP(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDown(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let accountVC = storyboard.instantiateViewController(withIdentifier: "accountVC")

        if ((FBSDKAccessToken.current()) != nil) {
            self.present(accountVC, animated: false, completion: nil)
        }

    }

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

    @IBAction func registerButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Register", bundle: nil)
        let registerVC = storyboard.instantiateViewController(withIdentifier: "registerVC")

        self.present(registerVC, animated: true, completion: nil)

    }

    //페이스북 로그인 버튼
    @IBAction func loginWithFacebookButton(_ sender: Any) {
        let readPermissions = ["public_profile"]
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: readPermissions, from: self) { (result, error) in
            if ((error) != nil) {
                
            } else if (result?.isCancelled)! {
                
            } else {
                //present the account view controller
                let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                let accountVC = storyboard.instantiateViewController(withIdentifier: "accountVC")
                self.present(accountVC, animated: false, completion: nil)
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if(textField.isEqual(self.emailTextField)) {
            self.pwdTextField.becomeFirstResponder() //다음 텍스트 필드로 포커스 이동
        }
        return true
    }

    @IBAction func loginButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "mainVC")
        let alert = UIAlertController(title: "Alert", message: "이메일이나 비밀번호를 확인해주세요", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))

        serverManager.loginReq(email: emailTextField.text!, password: pwdTextField.text!) { (isUser) in
            if isUser == true {
                self.present(mainVC, animated: true, completion: nil)
            } else {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    //비밀번호 잊었을때 ForgetPassword View로 이동
    @IBAction func forgetPasswordButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let forgetPasswordVC = storyboard.instantiateViewController(withIdentifier: "forgetPasswordVC")
        self.present(forgetPasswordVC, animated: false, completion: nil)

    }

}
