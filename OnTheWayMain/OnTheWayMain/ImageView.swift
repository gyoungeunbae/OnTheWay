//
//  ImageView.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 18..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImage(with photoID: String?, placeholder: UIImage? = nil) {
        guard let photoID = photoID else {
            self.image = placeholder
            return
        }
        let url = URL(string: "http://localhost:8080/\(photoID)")
        self.kf.setImage(with: url, placeholder: placeholder)
    }
}
