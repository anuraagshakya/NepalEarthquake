//
//  EarthquakesProvider.swift
//  NepalEarthquake
//
//  Created by Anuraag Shakya on 24.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import Foundation

protocol EarthquakesProviderDelegate: NSObject {
    func earthquakeProviderDidLoad(_ earthquakes: [Earthquake])
    func earthquakeProviderDidError(_ error: Error)
}

class EarthquakesProvider {
    weak var delegate: EarthquakesProviderDelegate?
    
    func fetchAllEarthquakes() {
        fetchEarthquakes(withURL: "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2010-01-01&minlatitude=23&maxlatitude=32&minlongitude=74&maxlongitude=94")
    }
    
    func fetchSignificantEarthquakes() {
        fetchEarthquakes(withURL: "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2010-01-01&minmagnitude=5&minlatitude=23&maxlatitude=32&minlongitude=74&maxlongitude=94")
    }

    private func fetchEarthquakes(withURL urlString: String) {
        // Create URL from urlString and asynchonously dispatch in a background
        //  queue the fetching of the string contents of the URL. If the status
        //  of the returned data is OK, call the 'parse' method.
        if let url = URL(string: urlString) {
            DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
                if let data = try? String(contentsOf: url) {
                    do {
                        let earthQuakes = try self.parse(data: data.data(using: .utf8)!)
                        DispatchQueue.main.async {
                            self.delegate?.earthquakeProviderDidLoad(earthQuakes)
                        }
                    } catch(let error) {
                        DispatchQueue.main.async {
                            self.delegate?.earthquakeProviderDidError(error)
                        }
                    }

                } else {
                    assertionFailure("Could not read contents of file")
                }
            }
        } else {
            assertionFailure("Could not valid URL from urlString")
        }
    }
    
    private func parse(data: Data) throws -> [Earthquake] {
        let decoder = JSONDecoder()
        let response = try decoder.decode(EarthquakesList.self, from: data)
        return response.features
    }
}
