//
//  EarthquakeListViewModel.swift
//  NepalEarthquake
//
//  Created by Anuraag Shakya on 24.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import Foundation

class EarthquakeListViewModel {
    var dataSource: EarthquakeListDataSource

    init(withDataSource dataSource: EarthquakeListDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchAllEarthquakes() {
        fetchEarthquakes(withURL: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")
    }
    
    func fetchSignificantEarthquakes() {
        fetchEarthquakes(withURL: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_day.geojson")
    }

    private func fetchEarthquakes(withURL urlString: String) {
        // Create URL from urlString and asynchonously dispatch in a background
        //  queue the fetching of the string contents of the URL. If the status
        //  of the returned data is OK, call the 'parse' method.
        if let url = URL(string: urlString) {
            DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
                if let data = try? String(contentsOf: url) {
                    self.parse(data: data.data(using: .utf8)!)
                } else {
                    print("Could not read contents of file")
                }
            }
        } else {
            print("Could not valid URL from urlString")
        }
    }
    
    private func parse(data: Data) {
        let decoder = JSONDecoder()
        var earthQuakes = [Earthquake]()
        do {
            earthQuakes = try decoder.decode([Earthquake].self, from: data)
        } catch {
            assertionFailure("Could not decode JSON")
        }

        self.dataSource.data = earthQuakes
    }
}
