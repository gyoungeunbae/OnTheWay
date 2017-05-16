//
//  RegiserManager.swift
//  OnTheWayMain
//
//  Created by lee on 2017. 4. 26..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import Foundation

class RegisterManager {

    //이메일 유효값 체크하는 함수
    func isValidEmailAddress(emailAddressString: String) -> Bool {

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

        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }

    //패스워드 강도 체크하는 함수
    func isValidPwd(pwdString: String) -> Int {

        let strongPwd = "(?=.+[!A-Z])(?=.+[0-9])[a-z.-_]{8,12}"
        let normalPwd = "(?=.+[A-Z]|.+[0-9])[a-z.-_]{8,12}"
        let weakPwd = "[a-z.-_.+[0-9]]{8,12}"

        var checkPwd = 0

        do {
            let regexStrong = try NSRegularExpression(pattern: strongPwd)
            let regexNormal = try NSRegularExpression(pattern: normalPwd)
            let regexWeak = try NSRegularExpression(pattern: weakPwd)

            let nsString = pwdString as NSString

            let resultsStrong = regexStrong.matches(in: pwdString, range: NSRange(location: 0, length: nsString.length))

            let resultsNormal = regexNormal.matches(in: pwdString, range: NSRange(location: 0, length: nsString.length))

            let resultsWeak = regexWeak.matches(in: pwdString, range: NSRange(location: 0, length: nsString.length))

            if(resultsStrong.count != 0) {
                checkPwd = 1
            } else if(resultsNormal.count != 0) {
                checkPwd = 2
            } else if(resultsWeak.count != 0) {
                checkPwd = 3
            } else if(pwdString.characters.count < 7) {
                checkPwd = 4
            }

        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            checkPwd = 0
        }

        return  checkPwd
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
