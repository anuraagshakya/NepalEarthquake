//
//  ViewController.swift
//  NepalEarthquake
//
//  Created by Anuraag Shakya on 24.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit

class EarthquakeListViewController: UITableViewController {
    var viewModel: EarthquakeListViewModel!
    let dataSource = EarthquakeListDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title of the view
        self.title = "Earthquakes in the Last 24H"
        
        // Instantiate the view model and pass it a reference to the data source
        viewModel = EarthquakeListViewModel(withDataSource: dataSource)
        
        // EarthquakeListDataSource calls its onDataUpdated closure every time
        //  its data is updated. We use this closure to reload our table view in
        //  the event the data is changed.
        dataSource.onDataUpdated = { [unowned self] in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        tableView.dataSource = dataSource
        
        // Finally, we call the 'fetchEarthquakes' method of our view model
        //  which will query the API for data
        viewModel.fetchEarthquakes()
    }
}

