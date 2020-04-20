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

struct Earthquake: Decodable {
    enum CodingKeys: String, CodingKey {
        case features
    }

    enum FeaturesCodingKeys: String, CodingKey {
        case properties
        case geometry
    }

    enum PropertiesCodingKeys: String, CodingKey, Encodable {
        case title
        case place
        case time
        case mag
        case urlString
    }

    enum GeometryCodingKeys: String, CodingKey {
        case coordinates
    }

    var title: String
    var place: String
    var time: UInt64
    var mag: Float
    var urlString: String
    var location: Coordinates

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let features = try container.nestedContainer(keyedBy: FeaturesCodingKeys.self, forKey: .features)

        let properties = try features.nestedContainer(keyedBy: PropertiesCodingKeys.self, forKey: .properties)
        let geometry = try features.nestedContainer(keyedBy: GeometryCodingKeys.self, forKey: .geometry)

        title = try properties.decode(String.self, forKey: .title)
        place = try properties.decode(String.self, forKey: .place)
        time = try properties.decode(UInt64.self, forKey: .time)
        mag = try properties.decode(Float.self, forKey: .mag)
        urlString = try properties.decode(String.self, forKey: .urlString)
        location = try geometry.decode(Coordinates.self, forKey: .coordinates)
    }
}

struct Coordinates: Codable {
    var longitude: Float
    var latitude: Float
    var depth: Float
}
