import UIKit
import Mapbox

class PresentLocationViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    var serverManager = ServerManager()
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.userTrackingMode = .follow
        guard let testLatitude: Double = self.locationManager.location?.coordinate.latitude
            else {
                return
        }
        guard let testLongitude: Double = self.locationManager.location?.coordinate.longitude
            else {
                return
        }
        let user = UserManager.sharedInstance.getUser()
        print("id = \(user[0].id!)")
        
        serverManager.coordinatesUpdate(userId: user[0].id!, latitude: testLatitude, longitude: testLongitude)
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
