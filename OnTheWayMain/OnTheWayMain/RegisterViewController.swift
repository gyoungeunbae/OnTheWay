import UIKit
import RealmSwift

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordColorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextFiled: UITextField!
    @IBOutlet weak var userNameTextFiled: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    
    var register = RegisterManager()
    var serverManager = ServerManager()
    var settingList = SettingList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextFiled.delegate = self
        emailTextField.delegate = self
        confirmPasswordTextFiled.delegate = self
        passwordTextFiled.delegate = self
        
        userNameTextFiled.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardUP(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDown(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.endEditing(true)
        confirmPasswordTextFiled.endEditing(true)
        userNameTextFiled.endEditing(true)
        passwordTextFiled.endEditing(true)
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let username = userNameTextFiled
        let email = emailTextField

        if(textField.isEqual(username)) {
            if(emailTextField.text == ""){
                emailTextField.becomeFirstResponder()
            }
            if(checkRegisterCondition()) {
                NotificationCenter.default.post(name: Notification.Name("presentTabBarVC"), object: nil)
            }
            

            
        } else if(textField.isEqual(email)) {
            
            if(passwordTextFiled.text == ""){
                passwordTextFiled.becomeFirstResponder()
            }
            if(checkRegisterCondition()) {
                NotificationCenter.default.post(name: Notification.Name("presentTabBarVC"), object: nil)
            }
            
        } else if(textField.isEqual(passwordTextFiled)) {
            
            if(confirmPasswordTextFiled.text == ""){
                confirmPasswordTextFiled.becomeFirstResponder()
            }
            if(checkRegisterCondition()) {
                NotificationCenter.default.post(name: Notification.Name("presentTabBarVC"), object: nil)
            }
            
        } else if(textField.isEqual(confirmPasswordTextFiled)) {
            
            if(checkRegisterCondition()) {
                NotificationCenter.default.post(name: Notification.Name("presentTabBarVC"), object: nil)
            }
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if(textField.isEqual(userNameTextFiled)) {
            
            userNameTextFiled.text = ""
            
        } else if(textField.isEqual(emailTextField)) {
            
            emailTextField.text = ""
            
        } else if(textField.isEqual(passwordTextFiled)) {
            
            passwordTextFiled.text = ""
            
        } else if(textField.isEqual(confirmPasswordTextFiled)) {
            
            confirmPasswordTextFiled.text = ""
        }
        return true
    }
    
    func checkRegisterCondition() -> Bool {
        
        let username = userNameTextFiled
        let email = emailTextField
        let password = passwordTextFiled
        let confirmPassword = confirmPasswordTextFiled
        
        let checkValue = true
        
        if(!(register.checkLength((username?.text)!))) {
            username?.placeholder = "유저네임을 입력하세요"
            return false
        }
        
        if(!(register.checkLength((email?.text)!))) {
            email?.placeholder = "이메일을 입력하세요"
            return false
        }
        
        if(!(register.checkLength((password?.text)!))) {
            password?.placeholder = "패스워드를 입력하세요 "
            return false
        }
        
        if(!(register.checkLength((confirmPassword?.text)!))) {
            password?.placeholder = "패스워드를 입력하세요"
            return false
        }
        
        if(!(register.isValidEmailAddress((email?.text)!))) {
            email?.text = ""
            email?.placeholder = "이메일을 확인하세요"
            return false
        }
        
        if((password?.text?.characters.count)! < 8 || (password?.text?.characters.count)! > 12) {
            password?.text = ""
            password?.placeholder = "8자리 이상 12자리 이하"
            return false
        }
        
        if(!(confirmPassword?.text! as! NSString).isEqual(to: (password?.text)!)) {
            confirmPassword?.text = ""
            confirmPassword?.placeholder = "비밀번호가 다릅니다"
            return false
        }
        
        return checkValue
    }
    
    //패스워드 강도 체크
    func checkPasswordStrength() {
        let checkedValue = register.isValidPassword(passwordTextFiled.text!)
        switch(checkedValue) {
        case 1:
            passwordColorLabel.backgroundColor = UIColor.green
        case 2:
            passwordColorLabel.backgroundColor = UIColor.yellow
        case 3:
            passwordColorLabel.backgroundColor = UIColor.red
        default:
            passwordColorLabel.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func editPasswordTextFieldAction(_ sender: Any) {
        checkPasswordStrength()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func RegisterButton(_ sender: Any) {

        let username = userNameTextFiled.text
        let email = emailTextField.text
        let password = passwordTextFiled.text
        
        let storyboard: UIStoryboard = UIStoryboard(name: "connect", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(withIdentifier: "tabBarVC")
        
        let alert = UIAlertController(title: "Alert", message: "이미 가입된 이메일 입니다.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))

        
        
       if(checkRegisterCondition()) {
    
            serverManager.registerReq(email: email!, password: password!, username: username!, callback: { (isUser) in
                
                if isUser == true {
                    NotificationCenter.default.post(name: Notification.Name("presentTabBarVC"), object: nil)
                    
                    self.serverManager.loginReq(email: email!, password: password!) { (isUser) in
                        if isUser == true {
                            self.serverManager.getSession { (user) in
            
                            UserManager.sharedInstance.addUser(user)
                            print("session is \(user)")
        
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
                        }
                    }
                } else {
                    
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
}
