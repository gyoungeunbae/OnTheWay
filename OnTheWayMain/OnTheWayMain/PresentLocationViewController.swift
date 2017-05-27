import UIKit
import Mapbox


class PresentLocationViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var mapView: MGLMapView!
    var sortedFriendsArr = [Friends]()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.userTrackingMode = .follow
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        mapView.delegate = self
        sortedFriendsArr = FriendsManager.sharedInstance.getFriends().sorted{$0.steps > $1.steps}
        
        var pointAnnotations = [MGLPointAnnotation]()
        for friend in sortedFriendsArr {
            let user = MGLPointAnnotation()
            user.coordinate = CLLocationCoordinate2D(latitude: friend.coordinates[1], longitude: friend.coordinates[0])
            user.title = friend.username
            mapView.addAnnotation(user)
        }
        mapView.addAnnotations(pointAnnotations)
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedFriendsArr.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PresentLocationTableViewCell
        cell.userName.text = sortedFriendsArr[indexPath.row].username
        if sortedFriendsArr[indexPath.row].image != "image" {
            cell.userPicture.setImage(with: sortedFriendsArr[indexPath.row].image)
        }
        cell.howmanySteps.text = String(sortedFriendsArr[indexPath.row].steps)
        return (cell)
    }

}
