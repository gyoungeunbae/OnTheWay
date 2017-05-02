//
//  PresentLocationViewController.swift
//  OnTheWayMain
//
//  Created by nueola on 4/29/17.
//  Copyright © 2017 junwoo. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class PresentLocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var myView: UIView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //myView = GMSMapView()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
        self.locationManager.stopUpdatingLocation()
        
    }
    func showCurrentLocationOnMap() {
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 14)
        let mapView = GMSMapView.map(withFrame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.myView.frame.size.width, height: self.myView.frame.size.height)) , camera: camera)
        
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        let marker = GMSMarker()
        marker.position=camera.target
        marker.snippet = "Current loaction"
        marker.appearAnimation =  GMSMarkerAnimation.pop
        marker.map = mapView
        self.myView?.addSubview(mapView)
    }

}
