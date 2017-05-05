//
//  MyPathViewController.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 5..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit
import Mapbox

class MyPathViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.userTrackingMode = .follow
        mapView.delegate = self
        

    }
    
    
    
}
