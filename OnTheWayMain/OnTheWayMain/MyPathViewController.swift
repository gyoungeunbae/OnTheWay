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


class MyPathViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    var calenderManager = CalenderManager()
    var items = List<Location>()
    var realm: Realm!
    var locationList = LocationList()
    var locations = [MGLPointAnnotation]()
    var today = String()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    @IBOutlet weak var mapView: MGLMapView!
    
    @IBAction func enableSwitch(_ sender: UISwitch) {
        if sender.isOn {
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //showing userlocation
        mapView.userTrackingMode = .follow
        
        mapView.delegate = self
        
    }
    
    func drawPolyline() {
        //오늘 날짜의 좌표를 realm에서 가져오기
        let realm = try! Realm()
        let results = realm.objects(Location.self).filter("date == '\(today)'")
        print(results)
        
        //가져온 좌표를 배열에 넣기
        var coordinates = [CLLocationCoordinate2D]()
        
        if results != nil {
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
                print(line)
            })

        } else {
            print("results error")
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
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let testLatitude = locationManager.location?.coordinate.latitude
            else {
                return
        }
        guard let testLongitude = locationManager.location?.coordinate.longitude
            else {
                return
        }
        
        print("lat: \(testLatitude), long: \(testLongitude)")
        
        // Add another annotation to the map.
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: testLatitude, longitude: testLongitude)
        //mapView.addAnnotation(point)
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
        
        if UIApplication.shared.applicationState == .active {
            
            self.drawPolyline()
            print("그리기")
        } else {
            print("App is backgrounded. New location is \(locations.last)")
        }
    }

    
}

