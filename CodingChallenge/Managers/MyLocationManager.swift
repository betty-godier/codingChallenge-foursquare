//
//      2022  Betty Godier
//      Coding challenge
//

import CoreLocation

final class MyLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var actualLocation: String = ""
    private let manager = CLLocationManager()
    var userLocation: CLLocation?
    static let shared = MyLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func requestAllowOnceLocationPermission() {
        manager.requestLocation()
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first?.coordinate
        DispatchQueue.main.async {
            if let location = location {
                let latitude = String(format: "%.4f", location.latitude)
                let longitude = String(format: "%.4f", location.longitude)
                self.actualLocation = "\(latitude),\(longitude)"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
}
