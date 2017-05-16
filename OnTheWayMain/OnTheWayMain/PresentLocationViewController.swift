//
//  PresentLocationViewController.swift
//  OnTheWayMain
//
//  Created by nueola on 4/29/17.
//  Copyright © 2017 junwoo. All rights reserved.
//

import UIKit
import Mapbox
class PresentLocationViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    let userLocation = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.userTrackingMode = .follow
        guard let testLatitude = userLocation.location?.coordinate.latitude
            else {
                return
        }
        guard let testLongitude = userLocation.location?.coordinate.longitude
            else {
                return
        }
        print("****\(testLatitude)")
        print("****\(testLongitude)")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PresentLocationTableViewCell
        cell.userName.text = "park"
        cell.userPicture.image = #imageLiteral(resourceName: "park")
        cell.howmanySteps.text = "9999"
        return (cell)
    }

}
