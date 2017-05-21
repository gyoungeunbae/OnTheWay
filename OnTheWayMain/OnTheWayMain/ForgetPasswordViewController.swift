//
//  ForgetPasswordViewController.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 4..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var serverManager = ServerManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //이메일 입력했을 때 데이터베이스의 비밀번호 요청
    @IBAction func submitEmailButton(_ sender: Any) {

        if (self.emailTextField.text != nil) {
            serverManager.findPasswordByEmail(email: self.emailTextField.text!) { (password) in
                self.passwordTextField.text = password
            }
        }

    }

    //뒤로가기 버튼
    @IBAction func backButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")

        self.dismiss(animated: true, completion: {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(loginVC, animated: true, completion: nil)
        })
    }
}
