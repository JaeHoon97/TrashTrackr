import UIKit
import NMapsMap
import LDSwiftEventSource
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate{
    
    var marker = [NMFMarker]()
    var binListArray: [BinList] = []
    var networkManager = NetworkManager.shared
    var locationManager = CLLocationManager()
    var naverMapView: NMFNaverMapView!
    var locationOverlay: NMFLocationOverlay!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naverMapView = NMFNaverMapView(frame: view.frame)
        naverMapView.showLocationButton = true
        naverMapView.mapView.positionMode = .normal
        locationOverlay = NMFLocationOverlay()
        locationOverlay.mapView = naverMapView.mapView
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        networkManager.fetchBin(type: "home") { [weak self] datas in
            guard let self = self, let binDatas = datas else { return }
            
            DispatchQueue.main.async {
                self.binListArray = binDatas
                print(binDatas)
                for i in 0..<self.binListArray.count {
                    let marker = NMFMarker(position: NMGLatLng(lat: self.binListArray[i].lat!, lng: self.binListArray[i].lon!), iconImage: NMFOverlayImage(name: "marker.png"))
                    marker.mapView = self.naverMapView.mapView
                    if(self.binListArray[i].amount! <= 40){
                        marker.iconTintColor = #colorLiteral(red: 0.2392156863, green: 0.5137254902, blue: 0.3803921569, alpha: 1)
                    } else if (self.binListArray[i].amount! <= 80) {
                        marker.iconTintColor = #colorLiteral(red: 1, green: 0.6039215686, blue: 0, alpha: 1)
                    } else {
                        marker.iconTintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                    }
                    marker.width = 45
                    marker.height = 45
                    
                    self.marker.append(marker)
                }
                
                
                self.view.addSubview(self.naverMapView)
                if let location = self.locationManager.location?.coordinate {
                    let myLocation = NMGLatLng(lat: location.latitude, lng: location.longitude)
                    self.naverMapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: myLocation))
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if locationOverlay == nil {
            locationOverlay = NMFLocationOverlay()
            locationOverlay.mapView = naverMapView.mapView
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let myLocation = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        
        if let locationOverlay = locationOverlay {
            locationOverlay.location = myLocation
        } else {
            print("Location overlay is nil.")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Error: \(error.localizedDescription)")
    }
}
