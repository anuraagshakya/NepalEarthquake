//
//  ViewController.swift
//  NepalEarthquake
//
//  Created by Anuraag Shakya on 24.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit

class EarthquakeListViewController: UITableViewController {
    var viewModel: EarthquakesProvider!
    let dataSource = EarthquakeListDataSource()
    var magnitudePicker: UIPickerView!
    var filterMagnitudeBarItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavagationBar()
        setupToolbar()
        
        // Instantiate the view model and pass it a reference to the data source
        viewModel = EarthquakesProvider()
        
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
        self.dataSource.data = viewModel.fetchAllEarthquakes() ?? []
    }
    
    @objc func presentFilterOptions() {
        magnitudePicker.reloadAllComponents()
        magnitudePicker.isHidden = false
    }
    
    @objc private func showFilterOptions() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "All", style: .default, handler: filterAllEarthquakes))
        ac.addAction(UIAlertAction(title: "Significant", style: .default, handler: filterSignificantEarthquakes))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    private func setupNavagationBar() {
        title = "Earthquakes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupToolbar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        filterMagnitudeBarItem = UIBarButtonItem(title: "Showing: All", style: .plain, target: self, action: #selector(showFilterOptions))

        toolbarItems = [spacer, filterMagnitudeBarItem]
        navigationController?.isToolbarHidden = false
    }
    
    private func filterAllEarthquakes(action: UIAlertAction) {
        filterMagnitudeBarItem.title = "Showing: All"
        self.dataSource.data = viewModel.fetchAllEarthquakes() ?? []
    }
    
    private func filterSignificantEarthquakes(action: UIAlertAction) {
        filterMagnitudeBarItem.title = "Showing: Significant"
        self.dataSource.data = viewModel.fetchSignificantEarthquakes() ?? []
    }
    
}

