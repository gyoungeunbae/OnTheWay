import UIKit
import Mapbox
import RealmSwift

class MyPathViewController: UIViewController, MGLMapViewDelegate {
    var calenderManager = CalenderManager()
    var realm: Realm!
    var today = String()
    var locations = [MGLPointAnnotation]()
    var currentIndex = 1
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        today = calenderManager.getWeekArrStr()[6]
        mapView.delegate = self
        mapView.setUserTrackingMode(.follow, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(drawPolyline), name: Notification.Name("locationDraw"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        PointManager.sharedInstance.removeArr()
        let realm = try! Realm()
        let results = realm.objects(LocationRealm.self).filter("date == '\(self.today)'")
        if results.count != 0 {
            
            for coordinate in results {
                let coordiPoint = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                let cgPoint: CGPoint = mapView.convert(coordiPoint, toPointTo: mapView)
                PointManager.sharedInstance.addTodayCGPoints(point: cgPoint)
            }
            
        }
    }
    
    func drawPolyline() {
        //오늘 날짜의 좌표를 realm에서 가져오기
        let realm = try! Realm()
        let results = realm.objects(LocationRealm.self).filter("date == '\(self.today)'")
        
        //가져온 좌표를 배열에 넣기
        var coordinates = [CLLocationCoordinate2D]()
        
        if results.count != 0 {
            var line = MGLPolyline()
            for index in 0..<results.count {
                var coordinate = CLLocationCoordinate2D()
                coordinate.latitude = results[index].latitude
                coordinate.longitude = results[index].longitude
                coordinates.append(coordinate)
            }
            
            //선 그리기
            DispatchQueue.global(qos: .background).async(execute: {
                [unowned self] in
                self.mapView.addAnnotation(line)
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
            return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
        } else {
            return .red
        }
    }
    
    // Or, if you’re using Swift 3 in Xcode 8.0, be sure to add an underscore before the method parameters:
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    // Return `nil` here to use the default marker.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    //사용자 승인시 위치추적
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .authorizedAlways)
    }
    
}
