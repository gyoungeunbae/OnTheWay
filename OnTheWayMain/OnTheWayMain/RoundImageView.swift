//
//  RoundImageView.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 4. 24..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {

    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

}
