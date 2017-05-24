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
    var locations = [MGLPointAnnotation]()
    var motionActivityManager = CMMotionActivityManager()
    var today = String()
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = 5.0
        manager.delegate = self
        return manager
    }()
    
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.startUpdatingLocation()
        mapView.userTrackingMode = .follow
        mapView.delegate = self
    }
    
    func drawPolyline() {
        //오늘 날짜의 좌표를 realm에서 가져오기
        var weekArrStr = calenderManager.getWeekArrStr()
        let realm = try! Realm()
        let results = realm.objects(Location.self).filter("date == '\(self.today)'")
        
        //가져온 좌표를 배열에 넣기
        var coordinates = [CLLocationCoordinate2D]()
        if results.count != 0 {
            print("today = \(self.today)")
            for index in 0..<results.count {
                var coordinate = CLLocationCoordinate2D()
                coordinate.latitude = results[index].latitude
                coordinate.longitude = results[index].longtitude
                coordinates.append(coordinate)
            }
            let line = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
            
            //선 그리기
            DispatchQueue.global(qos: .background).async(execute: {
                [unowned self] in
                self.mapView.addAnnotation(line)
                print("draw path")
            })
            
        } else {
            print("result is nil")
        }
        
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
        } else {
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
        print("check location at \(Date())")

        if CMMotionActivityManager.isActivityAvailable() {
            motionActivityManager.startActivityUpdates(to: OperationQueue.current!, withHandler: { activityData in
                if activityData!.walking == true || activityData!.running == true {
                    print("save location to realm at \(Date())")
                    
                    let realm = try? Realm() // Create realm pointing to default file
                    realm?.beginWrite()
                    let location = Location()
                    location.latitude = testLatitude
                    location.longtitude = testLongitude
                    location.date = self.calenderManager.getKoreanStr(todayDate: Date())
                    
                    realm?.add(location)
                    try! realm?.commitWrite()
                    
                    if UIApplication.shared.applicationState == .active {
                        print("app is active")
                        self.drawPolyline()
                    } else {
                        print("app is not active")
                    }

                
                }
            })
        }

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationmanager error")
    }
    
}
