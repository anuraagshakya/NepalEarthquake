//
//  Earthquake.swift
//  NepalEarthquake
//
//  Created by Anuraag Shakya on 24.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import Foundation

// Model for Earthquake data derived from GeoJSON format defined by the USGS
// here: https://earthquake.usgs.gov/earthquakes/feed/v1.0/geojson.php

struct Earthquake {
    var title: String
    var place: String
    var time: UInt64
    var mag: Float
    var urlString: String
    var location: Coordinates
}

struct Coordinates {
    var longitude: Float
    var latitude: Float
    var depth: Float
}
