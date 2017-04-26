//
//  RoundImageView.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 4. 24..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    class var sharedInstance: RoundImageView {
        struct Singleton {
            static let instance = RoundImageView()
        }
        return Singleton.instance
    }
    
    //요일 이미지뷰 원모양으로
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
    }

}
