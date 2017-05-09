//
//  MyPathViewController.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 5..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit
import Mapbox
import RealmSwift

class MyPathViewController: UIViewController, MGLMapViewDelegate {
    var calenderManager = CalenderManager()
    var items = List<Location>()
    var notificationToken: NotificationToken!
    var realm: Realm!
    var locationList = LocationList()
    


    @IBOutlet weak var mapView: MGLMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //showing userlocation
        mapView.userTrackingMode = .follow
        
        mapView.delegate = self
        
        let userTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.getUserLocation), userInfo: nil, repeats: true)
        //userTimer.invalidate()
        
    }
    
    
    
    // Or, if you’re using Swift 3 in Xcode 8.0, be sure to add an underscore before the method parameters:
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }

    
    // Return `nil` here to use the default marker.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    
    
    func cameraAnimation() {
        let coordinate = CLLocationCoordinate2D(latitude: 35.5494, longitude: 139.77765)
        
        let camera = MGLMapCamera(lookingAtCenter: coordinate, fromDistance: 5000, pitch: 40, heading: 90)
        
        mapView.fly(to: camera, completionHandler: nil)
    }
    
    func setBound() {
        // Set the map bounds to Portland, Oregon
        let bounds = MGLCoordinateBounds(
            sw: CLLocationCoordinate2D(latitude: 45.5087, longitude: -122.69),
            ne: CLLocationCoordinate2D(latitude: 45.5245, longitude: -122.65))
        
        mapView.setVisibleCoordinateBounds(bounds, animated: false)
    }
    
    func zoomLocation() {
        let center = CLLocationCoordinate2D(latitude: 38.894368, longitude: -77.036487)
        mapView.setCenter(center, zoomLevel: 15, animated: true)
    }
    
    func getUserLocation() {
        
        let userLocation = CLLocationManager()
        guard let testLatitude = userLocation.location?.coordinate.latitude
            else {
                return
        }
        guard let testLongitude = userLocation.location?.coordinate.longitude
            else {
                return
        }
        
        print("lat: \(testLatitude), long: \(testLongitude)")
        
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: testLatitude, longitude: testLongitude)
        point.title = "samchon"
        point.subtitle = "\(Date())"
        mapView.addAnnotation(point)
        
        let realm = try? Realm() // Create realm pointing to default file
        realm?.beginWrite()
        var location = Location()
        location.latitude = testLatitude
        location.date = calenderManager.getKoreanStr(todayDate: Date())
        location.longtitude = testLongitude
        locationList.email = "testemail"
        locationList.items.append(location)
        
        realm?.add(location)
        realm?.add(locationList)
        try! realm?.commitWrite()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    
}
