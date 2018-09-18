//
//  MapViewController.swift
//  
//
//  Created by Максим on 14.09.2018.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var marker: GMSMarker?
    var locationManager: CLLocationManager?
    var geocoder = CLGeocoder()
    var isChecked = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()
        configureLocationManager()
    }
    
    func configureMap() {
        let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 4)
        mapView.camera = camera
    }

    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.distanceFilter = 2
    }
    
    @IBAction func updateLocation(_ sender: Any) {
        isChecked = !isChecked
        if isChecked {
            locationManager?.stopUpdatingLocation()
        } else {
            locationManager?.startUpdatingLocation()
        }
    }
    
    @IBAction func currentLocation(_ sender: Any) {
        locationManager?.requestLocation()
    }
    
    func addMarker(center: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: center)
        marker.title = "Привет"
        marker.snippet = "Мое текущее метостоположение"
        marker.map = mapView
        self.marker = marker
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        geocoder.reverseGeocodeLocation(location) { places, error in
             print(places?.first)
        }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withTarget: center, zoom: 17)
        mapView.camera = camera
        
        addMarker(center: center)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}















