//
//  EarthquakesProvider.swift
//  NepalEarthquake
//
//  Created by Anuraag Shakya on 24.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import Foundation

class EarthquakesProvider {
    var earthQuakes: [Earthquake]?
    
    func fetchAllEarthquakes() -> [Earthquake]? {
        fetchEarthquakes(withURL: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")
    }
    
    func fetchSignificantEarthquakes() -> [Earthquake]? {
        return fetchEarthquakes(withURL: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_day.geojson")
    }

    private func fetchEarthquakes(withURL urlString: String) -> [Earthquake]? {
        // Create URL from urlString and asynchonously dispatch in a background
        //  queue the fetching of the string contents of the URL. If the status
        //  of the returned data is OK, call the 'parse' method.
        if let url = URL(string: urlString) {
            DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
                if let data = try? String(contentsOf: url) {
                    self.earthQuakes = self.parse(data: data.data(using: .utf8)!)
                } else {
                    assertionFailure("Could not read contents of file")
                }
            }
        } else {
            assertionFailure("Could not valid URL from urlString")
        }
        return nil
    }
    
    private func parse(data: Data) -> [Earthquake]? {
        let decoder = JSONDecoder()
        var earthQuakes = [Earthquake]()
        do {
            earthQuakes = try decoder.decode([Earthquake].self, from: data)
        } catch {
            assertionFailure("Could not decode JSON")
        }

        return earthQuakes
    }
}
