import UIKit
import Mapbox
import RealmSwift

class MyPathViewController: UIViewController, MGLMapViewDelegate {
    var calenderManager = CalenderManager()
    var realm: Realm!
    var today = String()
    var timer: Timer?
    var polylineSource: MGLShapeSource?
    var currentIndex = 1
    var allCoordinates: [CLLocationCoordinate2D]!
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        today = calenderManager.getWeekArrStr()[5]
        mapView.delegate = self
        mapView.setUserTrackingMode(.follow, animated: true)
        allCoordinates = addPointsOnTheMap()
        NotificationCenter.default.addObserver(self, selector: #selector(addPointsOnTheMap), name: Notification.Name("locationDraw"), object: nil)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        addLayer(to: style)
        animatePolyline()
    }
    
    func addLayer(to style: MGLStyle) {
        
        let source = MGLShapeSource(identifier: "polyline", shape: nil, options: nil)
        style.addSource(source)
        polylineSource = source
        
        let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
        layer.lineJoin = MGLStyleValue(rawValue: NSValue(mglLineJoin: .round))
        layer.lineCap = MGLStyleValue(rawValue: NSValue(mglLineCap: .round))
        layer.lineColor = MGLStyleValue(rawValue: UIColor.red)
        layer.lineWidth = MGLStyleFunction(interpolationMode: .exponential,
                                           cameraStops: [14: MGLConstantStyleValue<NSNumber>(rawValue: 5),
                                                         18: MGLConstantStyleValue<NSNumber>(rawValue: 20)],
                                           options: [.defaultValue : MGLConstantStyleValue<NSNumber>(rawValue: 1.5)])
        style.addLayer(layer)
    }
    
    func animatePolyline() {
        currentIndex = 1
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    func tick() {
        if currentIndex > allCoordinates.count {
            timer?.invalidate()
            timer = nil
            return
        }
        
        // Create a subarray of locations up to the current index.
        let coordinates = Array(allCoordinates[0..<currentIndex])
        
        // Update our MGLShapeSource with the current locations.
        updatePolylineWithCoordinates(coordinates: coordinates)
        
        currentIndex += 1
    }

    func updatePolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        var mutableCoordinates = coordinates
        
        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
        
        // Updating the MGLShapeSource’s shape will have the map redraw our polyline with the current coordinates.
        polylineSource?.shape = polyline
    }
    
    //realm에 저장된 데이터 가져와서 지도에 표시하기
    func addPointsOnTheMap() -> [CLLocationCoordinate2D] {
        let realm = try! Realm()
        let results = realm.objects(LocationRealm.self).filter("date == '\(self.today)'")
        var coordinates = [CLLocationCoordinate2D]()
        if results.count != 0 {
            
            for coordinate in results {
                let point = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                coordinates.append(point)
            }
            
            
        }
        return coordinates
    }
    
    //사용자 승인시 위치추적
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .authorizedAlways)
    }
    
}
