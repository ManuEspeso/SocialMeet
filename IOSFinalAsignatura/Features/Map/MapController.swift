//
//  MapController.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 16/02/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import AMTabView
import GoogleMaps
import GooglePlaces

class MapController: UIViewController, TabItem  {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    var tabImage: UIImage? {
        return UIImage(named: "mapIcon")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAlertFirstTime()
        setUpLocationManager()
        placesClient = GMSPlacesClient.shared()
        
    }
    
    func showAlertFirstTime() {
        if isFirstLaunch() {
             self.showAlert(alertText: "Welcome to our Map Advise", alertMessage: "In this map you can find some interesting places for meet and visit if you don`t have any idea or place to meet ")
        }
    }
    
    func isFirstLaunch() -> Bool {

        if (!UserDefaults.standard.bool(forKey: "launched_before")) {
            UserDefaults.standard.set(true, forKey: "launched_before")
            return true
        }
        return false
    }
    
    func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    
    override func loadView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 40.4165000, longitude: -3.7025600, zoom: 14.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        //creates a marker
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: 40.413543, longitude: -3.685525)
        marker2.title = "El retiro de Madrid"
        marker2.snippet = "Spain"
        marker2.map = mapView
        
        
        let marker3 = GMSMarker()
        marker3.position = CLLocationCoordinate2D(latitude: 40.423964, longitude: -3.717833)
        marker3.title = "Templo de debod / Madrid"
        marker3.snippet = "Spain"
        marker3.map = mapView
        
        
        let marker4 = GMSMarker()
        marker4.position = CLLocationCoordinate2D(latitude: 40.418647, longitude: -3.731009)
        marker4.title = "Lago casa de campo / Madrid"
        marker4.snippet = "Spain"
        marker4.map = mapView
        
        
        
        let marker5 = GMSMarker()
        marker5.position = CLLocationCoordinate2D(latitude: 40.419964, longitude: -3.701269)
        marker5.title = "Gran Vía / Madrid"
        marker5.snippet = "Spain"
        marker5.map = mapView
        
        
        let marker6 = GMSMarker()
        marker6.position = CLLocationCoordinate2D(latitude: 40.443292, longitude: -3.726965)
        marker6.title = "Plaza de ramón y cajal / Madrid"
        marker6.snippet = "Spain"
        marker6.map = mapView
        
        
        let marker7 = GMSMarker()
        marker7.position = CLLocationCoordinate2D(latitude: 40.408708, longitude: -3.693884)
        marker7.title = "Museo de arte Reina Sofía/ Madrid"
        marker7.snippet = "Spain"
        marker7.map = mapView
        
        let marker8 = GMSMarker()
        marker8.position = CLLocationCoordinate2D(latitude: 40.411266, longitude: -3.708314)
        marker8.title = "Plaza de la Cebada / Madrid"
        marker8.snippet = "Spain"
        marker8.map = mapView
    }
    
}

extension MapController: CLLocationManagerDelegate {
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
}

