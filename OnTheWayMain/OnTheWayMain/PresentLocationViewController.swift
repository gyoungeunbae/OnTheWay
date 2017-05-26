import UIKit
import Mapbox


class PresentLocationViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var mapView: MGLMapView!
    var sortedFriendsArr = [Friends]()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.userTrackingMode = .follow
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        sortedFriendsArr = FriendsManager.sharedInstance.getFriends().sorted{$0.steps > $1.steps}
        print("table = \(sortedFriendsArr)")
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
