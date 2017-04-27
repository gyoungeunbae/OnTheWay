//
//  RegisterViewController.swift
//  OnTheWayMain
//
//  Created by lee on 2017. 4. 26..
//  Copyright © 2017년 junwoo. All rights reserved.
//ster

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var checkPwdLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var pwdLabel: UILabel!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPwdTextFiled: UITextField!
    @IBOutlet weak var userNameTextFiled: UITextField!
    @IBOutlet weak var pwdTextFiled: UITextField!
    
    var regiser = RegisterManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.confirmPwdTextFiled.delegate = self
        self.userNameTextFiled.delegate = self
        self.pwdTextFiled.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardUP(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDown(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.endEditing(true)
        confirmPwdTextFiled.endEditing(true)
        userNameTextFiled.endEditing(true)
        pwdTextFiled.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.userNameTextFiled.becomeFirstResponder() //텍스트필드에 포커스

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //TextField에서 리턴키를 누르면
        if(textField.isEqual(self.userNameTextFiled)){
            self.emailTextField.becomeFirstResponder() //다음 텍스트 필드로 포커스 이동
        } else if(textField.isEqual(self.emailTextField)){
            self.pwdTextFiled.becomeFirstResponder()
        } else if(textField.isEqual(self.pwdTextFiled)) {
            self.confirmPwdTextFiled.becomeFirstResponder()
        } else if(textField.isEqual(self.confirmPwdTextFiled)) {
            textField.resignFirstResponder()
        }
        return true
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
    @IBAction func RegisterBnt(_ sender: Any) {
        let mainVc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! MainViewController
        
        if((userNameTextFiled.text?.characters.count)! < 1 ){
            userNameLabel.text = "이름을 적어주세요"
        } else {
            userNameLabel.text = ""
        }
        
        if((emailTextField.text?.characters.count)! < 1 || regiser.isValidEmailAddress(emailAddressString: emailTextField.text!) == false){
            emailLabel.text = "이메일을 적어주세요"
        } else {
            emailLabel.text = ""
        }
        
        if((pwdTextFiled.text?.characters.count)! < 1 || regiser.isPasswordValid(pwdTextFiled.text!)){
            pwdLabel.text = "비밀번호를 적어주세요"
        } else {
            pwdLabel.text = ""
        }
        
        if((userNameTextFiled.text?.characters.count)! > 0 && regiser.isValidEmailAddress(emailAddressString: emailTextField.text!) == true && (pwdTextFiled.text?.characters.count)! > 0) {
        self.present(mainVc, animated: true, completion: nil)
        }
        
        
    }
}
