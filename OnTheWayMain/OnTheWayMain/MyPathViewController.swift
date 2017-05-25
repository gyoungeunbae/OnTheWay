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
import CoreLocation
import CoreMotion

class MyPathViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    var calenderManager = CalenderManager()
    var realm: Realm!
    var motionActivityManager = CMMotionActivityManager()
    var today = String()
    
    @IBAction func traceButton(_ sender: UISwitch) {
        if sender.isOn {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
        
    }
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.userTrackingMode = .follow
        self.mapView.delegate = self
    }
    
    func addPointsOnTheMap() {
        //오늘 날짜의 좌표를 realm에서 가져오기
        
        let realm = try! Realm()
        let results = realm.objects(LocationRealm.self).filter("date == '\(self.today)'")
        
        if results.count != 0 {
            var pointAnnotations = [MGLPointAnnotation]()
            for coordinate in results {
                let point = MGLPointAnnotation()
                point.coordinate.latitude = coordinate.latitude
                point.coordinate.longitude = coordinate.longtitude
                pointAnnotations.append(point)
            }
            
            //선 그리기
            DispatchQueue.global(qos: .background).async(execute: {
                [unowned self] in
                self.mapView.addAnnotations(pointAnnotations)
                print("draw")
            })
            
            
        }
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    
    
//    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
//        // Set the alpha for all shape annotations to 1 (full opacity)
//        return 1
//    }
//    
//    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
//        // Set the line width for polyline annotations
//        return 2.0
//    }
//    
//    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
//        // Give our polyline a unique color by checking for its `title` property
//        if (annotation.title == "Crema to Council Crest" && annotation is MGLPolyline) {
//            // Mapbox cyan
//            return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
//        } else {
//            return .red
//        }
//    }
//    
//    // Or, if you’re using Swift 3 in Xcode 8.0, be sure to add an underscore before the method parameters:
//    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
//        // Always try to show a callout when an annotation is tapped.
//        return true
//    }
//    
//    // Return `nil` here to use the default marker.
//    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
//        return nil
//    }
    
    //location manager에서 정보 받기
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let testLatitude: Double = locationManager.location?.coordinate.latitude
            else {
                return
        }
        guard let testLongitude: Double = locationManager.location?.coordinate.longitude
            else {
                return
        }

        if CMMotionActivityManager.isActivityAvailable() {
            motionActivityManager.startActivityUpdates(to: OperationQueue.current!, withHandler: { activityData in
                if activityData!.walking == true || activityData!.running == true {
                    // Add another annotation to the map.
                    
                    let realm = try? Realm()
                    realm?.beginWrite()
                    let locationRealm = LocationRealm()
                    locationRealm.latitude = testLatitude
                    locationRealm.longtitude = testLongitude
                    locationRealm.date = self.calenderManager.getKoreanStr(todayDate: Date())
                    realm?.add(locationRealm)
                    try! realm?.commitWrite()
                    print("save into realm")
                    
                    if UIApplication.shared.applicationState == .active {
                        print("app is active")
                        self.addPointsOnTheMap()
                    } else {
                        print("app is not active")
                    }
                } else {
                    print("not walking")
                }
            })
        }

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationmanager error")
    }


}
