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

class Earthquake: NSObject, Decodable {
    var title: String?
    var place: String
    var time: UInt64
    var mag: Float
    var urlString: String
    var location: Coordinates

    init(title: String,
         place: String,
         time: UInt64,
         mag: Float,
         urlString: String,
         location: Coordinates) {
        self.title = title
        self.place = place
        self.time = time
        self.mag = mag
        self.urlString = urlString
        self.location = location
    }

    enum CodingKeys: String, CodingKey {
        case properties
        case geometry
    }

    enum PropertiesCodingKeys: String, CodingKey, Encodable {
        case title
        case place
        case time
        case mag
        case urlString = "url"
    }

    enum GeometryCodingKeys: String, CodingKey {
        case coordinates
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let properties = try container.nestedContainer(keyedBy: PropertiesCodingKeys.self, forKey: .properties)
        let geometry = try container.nestedContainer(keyedBy: GeometryCodingKeys.self, forKey: .geometry)

        title = try properties.decode(String.self, forKey: .title)
        place = try properties.decode(String.self, forKey: .place)
        time = try properties.decode(UInt64.self, forKey: .time)
        mag = try properties.decode(Float.self, forKey: .mag)
        urlString = try properties.decode(String.self, forKey: .urlString)
        let coordinates = try geometry.decode([Float].self, forKey: .coordinates)
        location = Coordinates(longitude: coordinates[0], latitude: coordinates[1], depth: coordinates[2])
    }
}

struct Coordinates: Codable {
    var longitude: Float
    var latitude: Float
    var depth: Float
}

struct EarthquakesList: Decodable {
    let features: [Earthquake]

    enum CodingKeys: String, CodingKey {
        case features
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        features = try container.decode([Earthquake].self, forKey: .features)
    }
}
