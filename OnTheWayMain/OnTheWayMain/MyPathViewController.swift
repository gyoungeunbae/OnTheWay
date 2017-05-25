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
    
    //위치추적 활성화버튼
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
        addPointsOnTheMap()
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
    
    
    //location manager에서 정보 받기
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if CMMotionActivityManager.isActivityAvailable() {
            motionActivityManager.startActivityUpdates(to: OperationQueue.current!, withHandler: { activityData in
                if activityData!.walking == true || activityData!.running == true {
                    guard let testLatitude: Double = self.locationManager.location?.coordinate.latitude
                        else {
                            return
                    }
                    guard let testLongitude: Double = self.locationManager.location?.coordinate.longitude
                        else {
                            return
                    }
                    let realm = try? Realm()
                    realm?.beginWrite()
                    let locationRealm = LocationRealm()
                    locationRealm.latitude = testLatitude
                    locationRealm.longitude = testLongitude
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

    
}
