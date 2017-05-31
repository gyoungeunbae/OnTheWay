//
//  StaticMapViewController.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 29..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit
import CoreLocation
import MapboxStatic
import RealmSwift

class StaticMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: UIImageView!
    let accessToken = "pk.eyJ1Ijoic2FtY2hvbiIsImEiOiJjajJiYzFrNXkwMGx2MzRudnNkbHptMTN5In0.aenVwqUxhFT1-bwk48svNg"
    var calenderManager = CalenderManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let results = realm.objects(LocationRealm.self).filter("date == '\(self.accessibilityHint!)'")
        
        if results.count != 0 {
            var coordinates = [CLLocationCoordinate2D]()
            
            
            for coordinate in results {
                let point = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                coordinates.append(point)
                
            }
            
            
            let path = Path(coordinates: coordinates)
            path.fillColor = UIColor.init(red: 27.0/255.0, green: 235.0/255.0, blue: 141.0/255.0, alpha: 1).withAlphaComponent(0.5)
            path.strokeColor = UIColor.init(red: 27.0/255.0, green: 235.0/255.0, blue: 141.0/255.0, alpha: 1).withAlphaComponent(0.5)
            
            
            let options = SnapshotOptions(
                styleURL: URL(string: "mapbox://styles/mapbox/dark-v9")!,
                size: mapView.bounds.size)
            
            options.overlays.append(path)
            
            _ = Snapshot(options: options, accessToken: accessToken).image { [weak self] (image, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                self?.mapView.image = image
            }
        } else {
            let options = SnapshotOptions(
                styleURL: URL(string: "mapbox://styles/mapbox/dark-v9")!,
                size: mapView.bounds.size)
            
            _ = Snapshot(options: options, accessToken: accessToken).image { [weak self] (image, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                self?.mapView.image = image
            }
        }
        
        
    }
}
