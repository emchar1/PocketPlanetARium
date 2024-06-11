//
//  PlanetGroup.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 9/26/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import Foundation

struct PlanetGroup {
    /**
     Dictionary of planets comprising of the planet group.
     */
    private var planets: [String : Planet] = [:]
    
    /**
     Adds a planet to the dictionary.
     - parameter planet: the Planet object to add
     */
    mutating func addPlanet(_ planet: Planet) {
        planets[planet.getName()] = planet
    }
    
    /**
     Returns a planet with the given name from the dictionary.
     - parameter planetName: String name of the planet to try to retrieve
     */
    func getPlanet(withName planetName: String) -> Planet? {
        return planets[planetName]
    }
    
    /**
     Returns an array of planets with the given PlanetType.
     - parameter type: PlanetType to try and retrieve
     */
    func getPlanets(withType type: PlanetType) -> [Planet] {
        var planets = [Planet]()
        
        for (_, planet) in self.planets {
            if planet.getType() == type {
                planets.append(planet)
            }
        }
        
        return planets
    }
    
    /**
     Returns all planets from the dictionary, as a 1D array.
     */
    func getAllPlanets() -> [Planet] {
        var planets = [Planet]()
        
        for (_, planet) in self.planets {
            planets.append(planet)
        }
        
        return planets
    }
}

