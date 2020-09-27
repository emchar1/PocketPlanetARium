//
//  PlanetGroup.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 9/26/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import Foundation

struct PlanetGroup {
    private var planets: [String: Planet] = [:]
    
    mutating func addPlanet(_ planet: Planet) {
        planets[planet.getName()] = planet
    }
    
    func getPlanet(withName planetName: String) -> Planet? {
        return planets[planetName]
    }
    
    func getPlanets(withType type: PlanetType) -> [Planet] {
        var planets = [Planet]()
        
        for (_, planet) in self.planets {
            if planet.getType() == type {
                planets.append(planet)
            }
        }
        
        return planets
    }
    
    func getAllPlanets() -> [Planet] {
        var planets = [Planet]()
        
        for (_, planet) in self.planets {
            planets.append(planet)
        }
        
        return planets
    }
}

