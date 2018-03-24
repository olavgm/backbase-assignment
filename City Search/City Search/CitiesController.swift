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
        guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else { return }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            items = try JSONDecoder().decode([City].self, from: data)
            print("Items count: \(items.count)")
        }
        catch {
        }

    }
    
}
