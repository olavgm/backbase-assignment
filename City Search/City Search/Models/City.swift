//
//  City.swift
//  City Search
//
//  Created by Olav Gausaker on 24/03/2018.
//  Copyright © 2018 Olav Gausaker. All rights reserved.
//

import UIKit
import MapKit

struct City: Decodable {

    private enum CodingKeys: String, CodingKey { case country, name, coord }

    let country: String
    let name: String
    let coord: Coordinates

    // Lowercased nameAndCountry to use for sorting and searching
    var searchValue = ""
    
    var nameAndCountry: String {
        get {
            return "\(name), \(country)"
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(coord.lat, coord.lon)
        }
    }

}
