//
//  MapViewController.swift
//  NepalEarthquake
//
//  Created by Anuraag Shakya on 20.04.20.
//  Copyright © 2020 Bhunte. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    let mapView = MapView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view = mapView

        let kathmanduCoordinate = CLLocationCoordinate2D(latitude: 28.33, longitude: 84.00)
        let nepalRegion = MKCoordinateRegion(center: kathmanduCoordinate, span: MKCoordinateSpan(latitudeDelta: 4.6, longitudeDelta: 10.0))
        mapView.setRegion(nepalRegion, animated: false)
        mapView.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.region)
    }

}
