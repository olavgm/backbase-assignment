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

    // Array containing all items
    private var items = [City]()

    // Array containing all items, reversed for search of last item
    private var itemsReversed = [City]()

    // Items to be shown
    var filteredItems = [City]()

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

            filteredItems = items
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
        
        filteredItems = items.filter({(city: City) -> Bool in
            return city.name.lowercased().starts(with: search.lowercased())
        })
        
        print("filter time: \(Date().timeIntervalSince(startDate))")
    }

}
