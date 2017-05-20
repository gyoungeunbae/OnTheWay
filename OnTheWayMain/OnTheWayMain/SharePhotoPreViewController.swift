//
//  SharePhotoPreViewController.swift
//  OnTheWayMain
//
//  Created by nueola on 5/20/17.
//  Copyright © 2017 junwoo. All rights reserved.
//

import UIKit
import Foundation
class SharePhotoPreViewController: UIViewController {
    var capturedImage : UIImage?
    @IBOutlet weak var imageView: UIImageView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = capturedImage
    
    }

}
