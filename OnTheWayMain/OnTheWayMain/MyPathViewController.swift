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
    var realm: Realm!
    var today = String()
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.setUserTrackingMode(.follow, animated: true)
        addPointsOnTheMap()
        NotificationCenter.default.addObserver(self, selector: #selector(addPointsOnTheMap), name: Notification.Name("locationDraw"), object: nil)
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            
            // Set the annotation view’s background color to a value determined by its longitude.
            let hue = CGFloat(annotation.coordinate.longitude) / 100
            annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
        }
        
        return annotationView
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    //realm에 저장된 데이터 가져와서 지도에 표시하기
    func addPointsOnTheMap() {
        
        let realm = try! Realm()
        let results = realm.objects(LocationRealm.self).filter("date == '\(self.today)'")
        
        if results.count != 0 {
            var pointAnnotations = [MGLPointAnnotation]()
            for coordinate in results {
                let point = MGLPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
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
    
    //사용자 승인시 위치추적
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .authorizedAlways)
    }
    
}

