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
