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
    
    // Array containing all elements, reversed (for fast searching purposes)
    private var itemsReversed = [City]()

    // Indexes for first and last item to show on list, filtered or not
    var resultsIndex: (first: Int, last: Int) = (first: 0, last: 0)

    // Helper for numberOfRows
    var resultsCount: Int {
        get {
            return resultsIndex.last - resultsIndex.first
        }
    }
    
    // Helper for cellForRow
    func itemWithOffset(offset: Int) -> City {
        return items[resultsIndex.first + offset]
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
            parseSearchValues()
            sortItems()
            resultsIndex = (first: 0, last: items.count - 1)
        }
        catch {
            print("Could not load JSON file.")
        }
    }
    
    // Sets the value for all searchValue in the cities
    private func parseSearchValues() {
        for index in 0..<items.count {
            items[index].searchValue = items[index].nameAndCountry.lowercased()
        }
    }

    private func sortItems() {
        items = items.sorted {
            $0.searchValue < $1.searchValue
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

        print("time: \(Date().timeIntervalSince(startDate)) - filter: \(search)")
    }

    private func findRange(search: String) {
        let indexFirst = findFirstIndex(search: search)
        let indexLast = findLastIndex(search: search)

        resultsIndex = (first: indexFirst, last: indexLast)
    }
    
    private func findFirstIndex(search: String) -> Int {
        var startCursor = 0
        var endCursor = items.count - 1
        var currentCursor = (startCursor + endCursor) / 2

        let search = search.lowercased()

        while startCursor != currentCursor {
            if search <= items[currentCursor].searchValue {
                endCursor = currentCursor
            }
            else {
                startCursor = currentCursor
            }

            currentCursor = (startCursor + endCursor) / 2
        }

        return endCursor
    }

    private func findLastIndex(search: String) -> Int {
        var startCursor = 0
        var endCursor = items.count - 1
        var currentCursor = (startCursor + endCursor) / 2

        let search = search.lowercased()

        while startCursor != currentCursor {
            if itemsReversed[currentCursor].searchValue.starts(with: search) {
                endCursor = currentCursor
            }
            else {
                if search > itemsReversed[currentCursor].searchValue {
                    endCursor = currentCursor
                }
                else {
                    startCursor = currentCursor
                }
            }
            
            currentCursor = (startCursor + endCursor) / 2
        }
        
        return items.count - endCursor
    }

}
