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

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        configureView()
    }

    func configureView() {
        definesPresentationContext = true
        automaticallyAdjustsScrollViewInsets = false

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
        }
        else {
            tableView.tableHeaderView = searchController.searchBar
        }

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search cities"
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapSegue" {
            guard let city = sender as? City else { return }
            guard let destinationViewController = segue.destination as? MapViewController else { return }
            
            destinationViewController.city = city
        }
    }
    
    // MARK: - Keyboard hide/show methods
    
    @objc func keyboardWillShow(_ notification: Foundation.Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let edgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
            tableView.contentInset = edgeInsets
            tableView.scrollIndicatorInsets = edgeInsets
        }
    }
    
    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }

}

// MARK: - UITableViewDataSource

extension CitiesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CitiesController.shared.resultsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)

        let city = CitiesController.shared.itemWithOffset(offset: indexPath.row)
        cell.textLabel?.text = city.nameAndCountry
        cell.detailTextLabel?.text = city.coord.description
        
        return cell
    }

}

// MARK: - UITableViewDelegate

extension CitiesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let city = CitiesController.shared.itemWithOffset(offset: indexPath.row)

        performSegue(withIdentifier: "MapSegue", sender: city)
    }
    
}

// MARK: - UISearchResultsUpdating

extension CitiesViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        CitiesController.shared.filter(search: searchController.searchBar.text!)

        tableView.reloadData()
    }

}
