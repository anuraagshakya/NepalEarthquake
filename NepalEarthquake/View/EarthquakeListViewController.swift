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
    var magnitudePicker: UIPickerView!
    let magnitudePickerDataSource = MagnitudePickerDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title of the view
        self.title = "Earthquakes in the Last 24H"
        
        // Instantiate the view model and pass it a reference to the data source
        viewModel = EarthquakeListViewModel(withDataSource: dataSource)
        
        // Show bottom toolbar and add a filter button to it
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(presentFilterOptions))
        
        toolbarItems = [spacer, filterButton]
        navigationController?.isToolbarHidden = false
        
        // EarthquakeListDataSource calls its onDataUpdated closure every time
        //  its data is updated. We use this closure to reload our table view in
        //  the event the data is changed.
        dataSource.onDataUpdated = { [unowned self] in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        tableView.dataSource = dataSource
        
        // pickerView
        magnitudePicker = UIPickerView()
        magnitudePicker.dataSource = magnitudePickerDataSource
        magnitudePicker.delegate = magnitudePickerDataSource
        
        magnitudePicker.translatesAutoresizingMaskIntoConstraints = false
        magnitudePicker.isHidden = true
        magnitudePicker.layer.borderWidth = 0.5
        magnitudePicker.layer.borderColor = UIColor.black.cgColor
        magnitudePicker.backgroundColor = UIColor.white
        view.addSubview(magnitudePicker)
        
        magnitudePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        magnitudePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        magnitudePicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        // Finally, we call the 'fetchEarthquakes' method of our view model
        //  which will query the API for data
        viewModel.fetchEarthquakes()
    }
    
    @objc func presentFilterOptions() {
        magnitudePicker.reloadAllComponents()
        magnitudePicker.isHidden = false
    }
}

