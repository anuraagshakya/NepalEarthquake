//
//  EarthquakeListViewModel.swift
//  NepalEarthquake
//
//  Created by Anuraag Shakya on 24.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import Foundation
import SwiftyJSON

class EarthquakeListViewModel {
    var dataSource: EarthquakeListDataSource

    init(withDataSource dataSource: EarthquakeListDataSource) {
        self.dataSource = dataSource
    }

    func fetchEarthquakes() {
        // Initialise urlString with API url
        let urlString = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"
        
        // Create URL from urlString and asynchonously dispatch in a background
        //  queue the fetching of the string contents of the URL. If the status
        //  of the returned data is OK, call the 'parse' method.
        if let url = URL(string: urlString) {
            DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
                if let data = try? String(contentsOf: url) {
                    let json = JSON(parseJSON: data)
                    
                    if json["metadata"]["status"].intValue == 200  {
                        self.parse(json: json)
                        return
                    } else {
                        print("JSON status not OK")
                    }
                } else {
                    print("Could not read contents of file")
                }
            }
        } else {
            print("Could not valid URL from urlString")
        }
    }
    
    private func parse(json: JSON) {
        var data = [Earthquake]()
        for dataPoint in json["features"].arrayValue {
            let title = dataPoint["properties"]["title"].stringValue
            let place = dataPoint["properties"]["place"].stringValue
            let time = dataPoint["properties"]["time"].uInt64Value
            let mag = dataPoint["properties"]["mag"].floatValue
            let urlString = dataPoint["properties"]["url"].stringValue
            let coordinatesArray = dataPoint["geometry"]["coordinates"].arrayValue
            let coordinates = Coordinates(
                longitude: coordinatesArray[0].floatValue,
                latitude: coordinatesArray[1].floatValue,
                depth: coordinatesArray[2].floatValue)
            
            let earthquake = Earthquake(title: title, place: place, time: time, mag: mag, urlString: urlString, location: coordinates)
            data.append(earthquake)
        }
        self.dataSource.data = data
    }
}
