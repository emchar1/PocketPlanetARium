//
//  PlanetDetails.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/4/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import Foundation

struct PlanetDetails {
    let stats: [Int : String]
    let details: String
}

enum PlanetStats: Int {
    case order = 0, distance, mass, radius, day, year, gravity, moons
}
