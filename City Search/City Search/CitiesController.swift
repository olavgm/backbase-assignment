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
    
    var items = [City]()
    
    override init() {
        super.init()
        
        loadData()
    }
    
    func loadData() {
        guard let path = Bundle.main.path(forResource: "cities1000", ofType: "json") else { return }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            items = try JSONDecoder().decode([City].self, from: data)
            sortItems()
        }
        catch {
            debugPrint("Could not load JSON file.")
        }
    }

    func sortItems() {
        items = items.sorted {
            $0.name < $1.name
        }
    }
    
}
