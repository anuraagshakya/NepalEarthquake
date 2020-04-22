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
    let listButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .cyan
        button.setTitle("🍔", for: .normal)
        button.addTarget(self, action: #selector(showEarthquakesList), for: .touchUpInside)
        return button
    }()
    let earthquakesProvider = EarthquakesProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        view = mapView
        view.addSubview(listButton)
        NSLayoutConstraint.activate([
            listButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            listButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
        ])

        let kathmanduCoordinate = CLLocationCoordinate2D(latitude: 28.33, longitude: 84.00)
        let nepalRegion = MKCoordinateRegion(center: kathmanduCoordinate, span: MKCoordinateSpan(latitudeDelta: 4.6, longitudeDelta: 10.0))
        mapView.setRegion(nepalRegion, animated: false)
        earthquakesProvider.delegate = self
        earthquakesProvider.fetchSignificantEarthquakes()
        mapView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @objc private func showEarthquakesList() {
        navigationController?.pushViewController(EarthquakeListViewController(), animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        true
    }

    override var childViewControllerForStatusBarHidden: UIViewController? {
        nil
    }

}

extension MapViewController: EarthquakesProviderDelegate {
    func earthquakeProviderDidLoad(_ earthquakes: [Earthquake]) {
        for earthquake in earthquakes {
            mapView.addAnnotation(earthquake)
        }
    }

    func earthquakeProviderDidError(_ error: Error) {
        // fail silently
    }


}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? Earthquake else {
      return nil
    }
    let identifier = "earthquake"
    var view: MKMarkerAnnotationView
    if let dequeuedView = mapView.dequeueReusableAnnotationView(
      withIdentifier: identifier) as? MKMarkerAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {
      view = MKMarkerAnnotationView(
        annotation: annotation,
        reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    return view
  }
}

extension Earthquake: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude),
                               longitude: CLLocationDegrees(location.longitude))
    }
}


