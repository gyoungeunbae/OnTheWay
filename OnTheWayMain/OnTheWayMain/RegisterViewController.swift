//
//  RegisterViewController.swift
//  OnTheWayMain
//
//  Created by lee on 2017. 4. 26..
//  Copyright © 2017년 junwoo. All rights reserved.
//ster

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    //Label모음
    @IBOutlet weak var pwdColorLabel: UILabel!
    @IBOutlet weak var checkPwdLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var confirmPwdLabel: UILabel!
    @IBOutlet weak var pwdStrengthLabel: UILabel!
    
    //TextField모음
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPwdTextFiled: UITextField!
    @IBOutlet weak var userNameTextFiled: UITextField!
    @IBOutlet weak var pwdTextFiled: UITextField!
    
    var register = RegisterManager()
    var pushServerRegister = ServerManager()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.confirmPwdTextFiled.delegate = self
        self.userNameTextFiled.delegate = self
        self.pwdTextFiled.delegate = self
        self.userNameTextFiled.becomeFirstResponder() //텍스트필드에 포커스
        
        //키보드 올라 올라가고 내려갈 때 상태 확인
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardUP(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDown(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.endEditing(true)
        confirmPwdTextFiled.endEditing(true)
        userNameTextFiled.endEditing(true)
        pwdTextFiled.endEditing(true)
    }
    
    //키보드 올라오고 내려갈때 뷰 이동하는 func
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


    
    //TextField에서 리턴키를 눌렀을 때의 액션
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "mainVC")
        
        if(textField.isEqual(self.userNameTextFiled)){
            self.emailTextField.becomeFirstResponder() //다음 텍스트 필드로 포커스 이동
        } else if(textField.isEqual(self.emailTextField)){
            if((emailTextField.text?.characters.count)! < 1 || register.isValidEmailAddress(emailAddressString: emailTextField.text!) == false){
                emailLabel.text = "이메일을 적어주세요"
            } else {
                emailLabel.text = ""
            }
            self.pwdTextFiled.becomeFirstResponder()
        } else if(textField.isEqual(self.pwdTextFiled)) {
            self.checkPwdStrength()
            self.confirmPwdTextFiled.becomeFirstResponder()
        } else if(textField.isEqual(self.confirmPwdTextFiled)) {
            if((confirmPwdTextFiled.text! as NSString).isEqual(to: pwdTextFiled.text!) == false) {
                confirmPwdLabel.text = "불일치"
            } else {
                confirmPwdLabel.text = ""
            }
            if((userNameTextFiled.text?.characters.count)! > 0 && register.isValidEmailAddress(emailAddressString: emailTextField.text!) == true && (confirmPwdTextFiled.text! as NSString).isEqual(to: pwdTextFiled.text!) == true && (pwdTextFiled.text?.characters.count)! > 7) {
                self.present(mainVC, animated: true, completion: nil)
            }
            
        }
        return true
    }
    
    //패스워드 강도 체크
    func checkPwdStrength() {
        let checkedValue = register.isValidPwd(pwdString: pwdTextFiled.text!)
        switch(checkedValue){
        case 1:
            pwdStrengthLabel.text = "강함"
            pwdColorLabel.backgroundColor = UIColor.green
        case 2:
            pwdStrengthLabel.text = "보통"
            pwdColorLabel.backgroundColor = UIColor.yellow
        case 3:
            pwdStrengthLabel.text = "약함"
            pwdColorLabel.backgroundColor = UIColor.red
        case 4:
            pwdStrengthLabel.text = "8자리 이상 비밀번호"
            pwdColorLabel.backgroundColor = UIColor.red
        default:
            pwdStrengthLabel.text = ""
            pwdColorLabel.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func RegisterBnt(_ sender: Any) {

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "mainVC")
        let alert = UIAlertController(title: "Alert", message: "이미 가입된 이메일 입니다.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        

        
        if((userNameTextFiled.text?.characters.count)! < 1 ){
            userNameLabel.text = "이름을 적어주세요"
        } else {
            userNameLabel.text = ""
        }
        
        if((emailTextField.text?.characters.count)! < 1 || register.isValidEmailAddress(emailAddressString: emailTextField.text!) == false){
            emailLabel.text = "이메일을 적어주세요"
        } else {
            emailLabel.text = ""
        }
        
        if((confirmPwdTextFiled.text! as NSString).isEqual(to: pwdTextFiled.text!) == false) {
            confirmPwdLabel.text = "불일치"
        } else {
            confirmPwdLabel.text = ""
        }
        
        if((userNameTextFiled.text?.characters.count)! > 0 && register.isValidEmailAddress(emailAddressString: emailTextField.text!) == true && (confirmPwdTextFiled.text! as NSString).isEqual(to: pwdTextFiled.text!) == true && (pwdTextFiled.text?.characters.count)! > 7) {
            pushServerRegister.registerReq(email: emailTextField.text!, password: pwdTextFiled.text!, username: userNameTextFiled.text!,callback: { (isUser) in
                print(isUser)
                
                if isUser == true {
                    self.present(mainVC, animated: true, completion: nil)
                } else {
                    self.present(alert, animated: true, completion: nil)

                }
                
            })
        }
    }
}
