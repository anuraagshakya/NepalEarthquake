//
//  ViewController.swift
//  NepalEarthquake
//
//  Created by Anuraag Shakya on 24.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit

class EarthquakeListViewController: UITableViewController {
    let earthquakeProvider = EarthquakesProvider()
    var filterMagnitudeBarItem: UIBarButtonItem?
    var earthquakes = [Earthquake]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavagationBar()
        earthquakeProvider.fetchAllEarthquakes()
        filterMagnitudeBarItem = UIBarButtonItem(title: "All", style: .plain, target: self, action: #selector(showFilterOptions))
        navigationItem.rightBarButtonItem  = filterMagnitudeBarItem
        earthquakeProvider.delegate = self
        tableView.register(EarthquakeTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(EarthquakeTableViewCell.self))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        navigationItem.rightBarButtonItem = filterMagnitudeBarItem
    }
    
    private func filterAllEarthquakes(action: UIAlertAction) {
        filterMagnitudeBarItem?.title = "All"
        earthquakeProvider.fetchAllEarthquakes()
    }
    
    private func filterSignificantEarthquakes(action: UIAlertAction) {
        filterMagnitudeBarItem?.title = "Significant"
        earthquakeProvider.fetchSignificantEarthquakes()
    }
    
}

extension EarthquakeListViewController: EarthquakesProviderDelegate {

    func earthquakeProviderDidLoad(_ earthquakes: [Earthquake]) {
        self.earthquakes = earthquakes
        tableView.reloadData()
    }

    func earthquakeProviderDidError(_ error: Error) {
        print("EarthquakeProvider did report error: \(error)")
    }

}

extension EarthquakeListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(EarthquakeTableViewCell.self), for: indexPath)
        cell.textLabel?.text = earthquakes[indexPath.row].title
        return cell
    }

}
