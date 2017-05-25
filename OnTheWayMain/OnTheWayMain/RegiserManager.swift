    import Foundation

class RegisterManager {

    //이메일 유효값 체크하는 함수
    func isValidEmailAddress(_ emailAddressString: String) -> Bool {

        var returnValue = true

        //이메일 유효값 검사를 위한 정규식표현
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"

        do {

            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))

            if results.count == 0 {
                returnValue = false
            }

        } catch _ as NSError {
            returnValue = false
        }
        return  returnValue
    }

    //패스워드 강도 체크하는 함수
    func isValidPassword(_ passwordString: String) -> Int {
        let strongPassword = "(?=.+[!A-Z])(?=.+[0-9])[a-z.-_]{8,12}"
        let normalPassword = "(?=.+[A-Z]|.+[0-9])[a-z.-_]{8,12}"
        let weakPassword = "[a-z.-_.+[0-9]]{8,12}"

        var checkPassword = 0

        do {
            let regexStrong = try NSRegularExpression(pattern: strongPassword)
            let regexNormal = try NSRegularExpression(pattern: normalPassword)
            let regexWeak = try NSRegularExpression(pattern: weakPassword)

            let nsString = passwordString as NSString

            let resultsStrong = regexStrong.matches(in: passwordString, range: NSRange(location: 0, length: nsString.length))

            let resultsNormal = regexNormal.matches(in: passwordString, range: NSRange(location: 0, length: nsString.length))

            let resultsWeak = regexWeak.matches(in: passwordString, range: NSRange(location: 0, length: nsString.length))

            if(resultsStrong.count != 0) {
                checkPassword = 1
            } else if(resultsNormal.count != 0) {
                checkPassword = 2
            } else if(resultsWeak.count != 0) {
                checkPassword = 3
            } else if(passwordString.characters.count < 7) {
                checkPassword = 4
            }

        } catch let error as NSError {
            checkPassword = 0
        }

        return  checkPassword
    }
    
    func checkLength(_ string: String) -> Bool {
        var checkLength: Bool
        
        if(string.characters.count > 0) {
            checkLength = true
        } else {
            checkLength = false
        }
        return checkLength
    }
    
   // 정규식표현 참고
//    ^                         Start anchor
//    (?=.*[A-Z].*[A-Z])        Ensure string has two uppercase letters.
//    (?=.*[!@#$&*])            Ensure string has one special case letter.
//    (?=.*[0-9].*[0-9])        Ensure string has two digits.
//    (?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
//    .{8}                      Ensure string is of length 8.
//    $                         End anchor.

}
