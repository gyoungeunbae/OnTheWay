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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func submitEmailButton(_ sender: Any) {
        
        if (self.emailTextField.text != nil) {
            serverManager.findPasswordByEmail(email: self.emailTextField.text!) { (password) in
                
                if (self.emailTextField.text == nil) {
                    self.passwordTextField.text = "이메일을 입력하세요"
                } else {
                    self.passwordTextField.text = password
                }
            }
        }
        
    }

    @IBAction func backButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
        //         self.present(loginVC, animated: true, completion: nil)
        
        self.dismiss(animated: true, completion: {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(loginVC, animated: true, completion: nil)
        })
    }
}
