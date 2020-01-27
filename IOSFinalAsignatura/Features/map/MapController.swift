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

class MapController: UIViewController, TabItem {
    //clav api AIzaSyANZ93XULMTaSF-_oPHkgGdPgxGVUtKKvs
    var tabImage: UIImage? {
           return UIImage(named: "mapIcon")
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
       }
    override func loadView() {
      // Create a GMSCameraPosition that tells the map to display the
      // coordinate -33.86,151.20 at zoom level 6.
      let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
      let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
      view = mapView

      // Creates a marker in the center of the map.
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
      marker.title = "Sydney"
      marker.snippet = "Australia"
      marker.map = mapView
    }
    
}
