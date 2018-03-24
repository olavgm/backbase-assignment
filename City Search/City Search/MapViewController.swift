//
//  MapViewController.swift
//  City Search
//
//  Created by Olav Gausaker on 24/03/2018.
//  Copyright © 2018 Olav Gausaker. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var city: City? {
        didSet {
            title = city!.nameAndCountry
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let city = city else { return }

        mapView.region = MKCoordinateRegion(center: city.coordinate, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    }
    
}
