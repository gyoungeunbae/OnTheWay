//
//  RegisterViewController.swift
//  OnTheWayMain
//
//  Created by lee on 2017. 4. 26..
//  Copyright © 2017년 junwoo. All rights reserved.
//ster

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPwdTextFiled: UITextField!
    @IBOutlet weak var userNameTextFiled: UITextField!
    @IBOutlet weak var pwdTextFiled: UITextField!
    
    var regiser = RegisterManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.userNameTextFiled.delegate = self
        self.pwdTextFiled.delegate = self
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.endEditing(true)
        confirmPwdTextFiled.endEditing(true)
        userNameTextFiled.endEditing(true)
        pwdTextFiled.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.userNameTextFiled.becomeFirstResponder() //텍스트필드에 포커스
        print("--------")
        print(regiser.isValidEmailAddress(emailAddressString: emailTextField.text!))
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.isEqual(self.userNameTextFiled)){ //유저네임필드에서 리턴키를 누르면
            self.emailTextField.becomeFirstResponder() //이메일필드로 포커스 이동
        } else if(textField.isEqual(self.emailTextField)){
            if(regiser.isValidEmailAddress(emailAddressString: emailTextField.text!) == false){
                emailLabel.text = "이메일 입력해"
            } else {
                emailLabel.text = "확인"
            }
            self.pwdTextFiled.becomeFirstResponder()
        } else if(textField.isEqual(self.pwdTextFiled)){
            self.confirmPwdTextFiled.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
