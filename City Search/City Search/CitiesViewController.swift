//
//  CitiesViewController.swift
//  City Search
//
//  Created by Olav Gausaker on 24/03/2018.
//  Copyright © 2018 Olav Gausaker. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    func configureView() {
        navigationController?.navigationBar.prefersLargeTitles = true

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search cities"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapSegue" {
            guard let city = sender as? City else { return }
            guard let destinationViewController = segue.destination as? MapViewController else { return }
            
            destinationViewController.city = city
        }
    }
    
}

extension CitiesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CitiesController.shared.resultsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)

        let city = CitiesController.shared.items[CitiesController.shared.resultsIndex.first + indexPath.row]
        cell.textLabel?.text = city.nameAndCountry

        return cell
    }

}

extension CitiesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let city = CitiesController.shared.items[CitiesController.shared.resultsIndex.first + indexPath.row]

        performSegue(withIdentifier: "MapSegue", sender: city)
    }
    
}

extension CitiesViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text!)

        CitiesController.shared.filter(search: searchController.searchBar.text!)

        tableView.reloadData()
    }

}
