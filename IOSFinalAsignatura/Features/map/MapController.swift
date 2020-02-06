//
//  MapController.swift
//  IOSFinalAsignatura
//
//  Created by alvaro on 27/01/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import AMTabView
import GoogleMaps
import GooglePlaces

class MapController: UIViewController, TabItem  {
    //clav api AIzaSyANZ93XULMTaSF-_oPHkgGdPgxGVUtKKvs
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    //google map stuff
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []

    // The currently selected place.
    var selectedPlace: GMSPlace?


    
    
    
    var tabImage: UIImage? {
           return UIImage(named: "mapIcon")
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        placesClient = GMSPlacesClient.shared()
        
        
        //my map
        


           	
       }
    override func loadView() {
     // Create a GMSCameraPosition that tells the map to display the
      // coordinate -33.86,151.20 at zoom level 6.
      let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 134.20, zoom: 6.0)
      let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
      view = mapView
      
       // Creates a marker in the center of the map.
       let marker = GMSMarker()
        let house = UIImage(named: "mapIcon")!.withRenderingMode(.alwaysTemplate)
        let makerView = UIImageView(image: house)
       marker.position = CLLocationCoordinate2D(latitude: -38.86, longitude: 167.20)
       marker.title = "Sydney"
       marker.snippet = "Australia"
        marker.iconView = makerView
       marker.map = mapView
        
        // Creates a marker in the center of the map.
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: -41.86, longitude: 191.20)
        marker2.title = "Sydney"
        marker2.snippet = "Australia"
        marker2.map = mapView
        
        // Creates a marker in the center of the map.
        let marker3 = GMSMarker()
        marker3.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker3.title = "Sydney"
        marker3.snippet = "Australia"
        marker3.map = mapView
        
	

    }
    
}

extension MapController: CLLocationManagerDelegate {
    
    
    
    

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")

    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude,
                                          zoom: zoomLevel)

    if mapView.isHidden {
      mapView.isHidden = false
      mapView.camera = camera
    } else {
      mapView.animate(to: camera)
    }

    //listLikelyPlaces()
  }

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

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
}

