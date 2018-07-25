//
//  EarthquakeListDataSource.swift
//  NepalEarthquake
//
//  Created by Anuraag Shakya on 24.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit

class EarthquakeListDataSource: NSObject, UITableViewDataSource {
    var data = [Earthquake]() {
        didSet {
            // Invoke on data updated closure every time data is set
            onDataUpdated()
        }
    }
    var onDataUpdated: () -> Void = {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "earthquakeCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].title
        return cell
    }
    
    
}
