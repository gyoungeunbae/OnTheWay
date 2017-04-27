//
//  FBLoginViewController.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 4. 27..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FBLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func facebookLoginBtn(_ sender: Any) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
            if (error == nil) {
                let fbLoginResult : FBSDKLoginManagerLoginResult = result!
                if (fbLoginResult.grantedPermissions.contains("email")) {
                    self.getFBUserData()
                }
            }
        }
        
    }
    
    func getFBUserData() {
        if((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    print(result)
                    //self.performSegue(withIdentifier: "ToSettings", sender: self)
                    let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "mainVC") as! MainViewController
                    self.present(mainVC, animated: true, completion: nil)}
                })
        }
    }
    
}
