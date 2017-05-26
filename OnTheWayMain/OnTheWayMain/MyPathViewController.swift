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

class MyPathViewController: UIViewController, MGLMapViewDelegate {
    var calenderManager = CalenderManager()
    var realm: Realm!
    var today = String()
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        addPointsOnTheMap()
        NotificationCenter.default.addObserver(self, selector: #selector(addPointsOnTheMap), name: Notification.Name("locationDraw"), object: nil)
    }
    
    
    //realm에 저장된 데이터 가져와서 지도에 표시하기
    func addPointsOnTheMap() {
        
        let realm = try! Realm()
        let results = realm.objects(LocationRealm.self).filter("date == '\(self.today)'")
        
        if results.count != 0 {
            var pointAnnotations = [MGLPointAnnotation]()
            for coordinate in results {
                let point = MGLPointAnnotation()
                point.coordinate.latitude = coordinate.latitude
                point.coordinate.longitude = coordinate.longitude
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
    
    //지도에 마커 표시
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    @IBAction func zoomToUserLocation(_ sender: Any) {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    //사용자 승인시 위치추적
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .authorizedAlways)
    }
    
    
    
}

