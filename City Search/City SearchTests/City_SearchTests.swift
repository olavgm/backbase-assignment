//
//  City_SearchTests.swift
//  City SearchTests
//
//  Created by Olav Gausaker on 24/03/2018.
//  Copyright © 2018 Olav Gausaker. All rights reserved.
//

import XCTest
@testable import City_Search

class City_SearchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidSearches() {
        let searches = ["Marbella", "Kiev", "Oslo", "New York", "San Francisco", "Miami", "Lviv", "Beijing"]

        for search in searches {
            CitiesController.shared.filter(search: search)

            for index in CitiesController.shared.resultsIndex.first..<CitiesController.shared.resultsIndex.last {
                let city = CitiesController.shared.items[index]

                if !city.name.starts(with: search) {
                    XCTFail("The result \"\(city.name)\" does not match the search query \"\(search)\".")
                }
            }
        }

        XCTAssert(true, "Searches \(searches) found their respective results.")
    }

    func testInvalidSearches() {
        let searches = ["asdf", "Kieva", "Oslu", "New Yorks", "Sanfrancisco", "Miamii", "Lbiv", "Beiging"]
        
        for search in searches {
            CitiesController.shared.filter(search: search)
            
            for index in CitiesController.shared.resultsIndex.first..<CitiesController.shared.resultsIndex.last {
                let city = CitiesController.shared.items[index]

                XCTFail("The search \"\(search)\" wrongfully found a match on \"\(city.name)\".")
            }
        }
        
        XCTAssert(true)
    }
    
}
