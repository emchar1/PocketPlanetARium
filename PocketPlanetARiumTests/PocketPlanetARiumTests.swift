//
//  PocketPlanetARiumTests.swift
//  PocketPlanetARiumTests
//
//  Created by Eddie Char on 10/29/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import XCTest
@testable import PocketPlanetARium

class PocketPlanetARiumTests: XCTestCase {
    var planet: PlanetARium!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        planet = PlanetARium()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        planet = nil
        
        super.tearDown()
    }

    func testLabelsPressed() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        planet.showLabels()
        XCTAssertFalse(planet.areLabelsOn())
        
        planet.toggleLabels()
        XCTAssertTrue(planet.areLabelsOn())

        planet.toggleLabels()
        XCTAssertFalse(planet.areLabelsOn())

        planet.toggleLabels()
        XCTAssertTrue(planet.areLabelsOn())

        planet.toggleLabels()
        XCTAssertFalse(planet.areLabelsOn())        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
