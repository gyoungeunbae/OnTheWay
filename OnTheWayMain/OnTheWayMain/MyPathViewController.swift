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
        
        drawPolyline()
    }
    
    func drawPolyline() {
        
        var coordinates: [CLLocationCoordinate2D] = []
        let line = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        
        DispatchQueue.global(qos: .background).async(execute: {
            [unowned self] in
            self.mapView.addAnnotation(line)
            print(line)
        })
        
    }
    
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        // Set the alpha for all shape annotations to 1 (full opacity)
        return 1
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        return 2.0
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        // Give our polyline a unique color by checking for its `title` property
        if (annotation.title == "Crema to Council Crest" && annotation is MGLPolyline) {
            // Mapbox cyan
            return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
        }
        else
        {
            return .red
        }
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
