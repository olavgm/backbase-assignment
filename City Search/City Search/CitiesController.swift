//
//  CitiesController.swift
//  City Search
//
//  Created by Olav Gausaker on 24/03/2018.
//  Copyright © 2018 Olav Gausaker. All rights reserved.
//

import UIKit

class CitiesController: NSObject {

    static let shared = CitiesController()

    // Array containing all elements
    var items = [City]()
    private var itemsReversed = [City]()

    // Indexes for first and last item to show on list, filtered or not
    var resultsIndex: (first: Int, last: Int) = (first: 0, last: 0)

    // Helper for numberOfRows
    var resultsCount: Int {
        get {
            return resultsIndex.last - resultsIndex.first
        }
    }
    
    override init() {
        super.init()
        
        loadData()
    }
    
    private func loadData() {
        guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else { return }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            items = try JSONDecoder().decode([City].self, from: data)
            sortItems()
            resultsIndex = (first: 0, last: items.count - 1)
        }
        catch {
            print("Could not load JSON file.")
        }
    }

    private func sortItems() {
        items = items.sorted {
            $0.name.lowercased() < $1.name.lowercased()
        }
        
        itemsReversed = items.reversed()
    }
    
    func filter(search: String) {
        let startDate = Date()
        
        if search.isEmpty {
            // If search is empty, all items are visible
            resultsIndex = (first: 0, last: items.count - 1)
        }
        else {
            findRange(search: search)
        }

        print("filter time: \(Date().timeIntervalSince(startDate))")
    }

    private func findRange(search: String) {
        guard let indexFirst = items.index(where: { $0.name.starts(with: search) }) else {
            resultsIndex = (first: 0, last: -1)
            return
        }

        guard let indexLast = itemsReversed.index(where: { $0.name.starts(with: search) }) else {
            return
        }

        print("first: \(indexFirst), last: \(items.count - indexLast)")

        resultsIndex = (first: indexFirst, last: items.count - indexLast)
    }

}
