import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import RealmSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    var serverManager = ServerManager()
    var settingList = SettingList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.pwdTextField.delegate = self
        self.emailTextField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardUP(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDown(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
                //로그인 성공시 탭바로 들어가서 페이스북 정보 가져오기
                let storyboard: UIStoryboard = UIStoryboard(name: "connect", bundle: nil)
                let tabBarVC = storyboard.instantiateViewController(withIdentifier: "tabBarVC")
                self.present(tabBarVC, animated: true)
                self.getFacebookUserInfo()
                
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
        let storyboard: UIStoryboard = UIStoryboard(name: "connect", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(withIdentifier: "tabBarVC")
        let alert = UIAlertController(title: "Alert", message: "이메일이나 비밀번호를 확인해주세요", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        serverManager.loginReq(email: emailTextField.text!, password: pwdTextField.text!) { (isUser) in
            if isUser == true {
                self.serverManager.getSession { (user) in
                    
                    UserManager.sharedInstance.addUser(user)
                    print("session is \(user)")
                    
                    //로그인한 유저의 세팅을 realm에서 불러와서 넣어놓기
                    let realm = try! Realm()
                    let results = realm.objects(SettingList.self).filter("email == '\(user.email)'")
                    if results.count != 0 {
                        UserSettingManager.sharedInstance.updateUserSetting(user: user, dailyGoal: (results.last?.items.last?.dailyGoal)!, notification: (results.last?.items.last?.notification)!)
                        print("realm results = \(results)")
                    } else {
                        let realm = try! Realm()
                        realm.beginWrite()
                        var setting = Setting()
                        setting.dailyGoal = "10000"
                        setting.notification = "On"
                        self.settingList.items.append(setting)
                        self.settingList.email = user.email
                        realm.add(setting)
                        realm.add(self.settingList)
                        try! realm.commitWrite()
                        print("save setting into realm")
                    }
                    self.present(tabBarVC, animated: true)
                }
                
            } else {
                self.present(alert, animated: true)
            }
        }
        
    }
    
    //비밀번호 잊었을때 ForgetPassword View로 이동
    @IBAction func forgetPasswordButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let forgetPasswordVC = storyboard.instantiateViewController(withIdentifier: "forgetPasswordVC")
        self.present(forgetPasswordVC, animated: true)
        
    }
    
    
    
    func getFacebookUserInfo() {
        
        //페이스북에서 이메일, 이름 가져오기
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "email, name"])
            .start(completionHandler:  { (connection, result, error) in
                guard let result = result as? NSDictionary,
                    let email = result["email"] as? String,
                    let username = result["name"] as? String else {
                        return
                }
                
                //앱에 회원가입여부 확인해서 없으면 가입시키기
                self.serverManager.registerReq(email: email, password: "password", username: username, callback: { (isUser) in
                    if isUser == true {
                        print("already existing facebook user")
                    } else {
                        print("new facebook user")
                    }
                })
                
                //세션 로그인
                self.serverManager.loginReq(email: email, password: "password") { (isUser) in
                    if isUser == true {
                        print("facebook user login success")
                    } else {
                        print("facebook user login fail")
                    }
                }
                
                self.serverManager.getSession { (user) in
                    
                    //UserManager에 넣기
                    UserManager.sharedInstance.addUser(user)
                    print("session is \(user)")
                    
                    //로그인한 유저의 세팅을 realm에서 불러와서 넣어놓기
                    let realm = try! Realm()
                    let results = realm.objects(SettingList.self).filter("email == '\(user.email)'")
                    if results.count != 0 {
                        //UserSettingManager에 넣기
                        UserSettingManager.sharedInstance.updateUserSetting(user: user, dailyGoal: (results.last?.items.last?.dailyGoal)!, notification: (results.last?.items.last?.notification)!)
                    } else {
                        let realm = try! Realm()
                        realm.beginWrite()
                        let setting = Setting()
                        setting.dailyGoal = "10000"
                        setting.notification = "On"
                        self.settingList.items.append(setting)
                        self.settingList.email = email
                        realm.add(setting)
                        realm.add(self.settingList)
                        try! realm.commitWrite()
                        print("save setting into realm")
                    }
                    
                }
                
            })
        
    }
    
}
