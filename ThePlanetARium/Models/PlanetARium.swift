//
//  PlanetARium.swift
//  ThePlanetARium
//
//  Created by Eddie Char on 9/18/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

struct PlanetARium {
    var sun = Planet(name: "Sun", radius: 0.008, tilt: 0, position: SCNVector3(0, 0, -0.1), rotationSpeed: 81)
    var planets: [String: Planet] = [:]
    

    mutating func addPlanets(earthRadius: Float, earthDistance: Float, earthDay: TimeInterval, earthYear: TimeInterval, toNode sceneView: ARSCNView) {
        
        func sind(_ degrees: Float) -> Float {
            return sin(toRadians(degrees))
        }
        
        func cosd(_ degrees: Float) -> Float {
            return cos(toRadians(degrees))
        }
        
        func toRadians(_ degrees: Float) -> Float {
            return Float.pi / (180 / degrees)
        }
        
        //Set up the sun and planets
        sun.setRotationSpeed(to: earthDay * 27)
        
        
        planets["Mercury"] = Planet(name: "Mercury",
                                    radius: earthRadius * 0.38,
                                    tilt: 0,
                                    positionAngle: (0, earthDistance * 0.39),
                                    rotationSpeed: earthDay * 58,
                                    orbitalCenterPosition: sun.getPosition(),
                                    orbitalCenterRotationSpeed: earthYear * 0.24)
        
        planets["Venus"] = Planet(name: "Venus",
                                  radius: earthRadius * 0.95,
                                  tilt: toRadians(177),
                                  positionAngle: (toRadians(0.8), earthDistance * 0.72),
                                  rotationSpeed: earthDay * 243,
                                  orbitalCenterPosition: sun.getPosition(),
                                  orbitalCenterRotationSpeed: earthYear * 0.62)
        
        planets["Earth"] = Planet(name: "Earth",
                                  radius: earthRadius,
                                  tilt: toRadians(23),
                                  positionAngle: (toRadians(2), earthDistance),
                                  rotationSpeed: earthDay,
                                  orbitalCenterPosition: sun.getPosition(),
                                  orbitalCenterRotationSpeed: earthYear)
        
        //        planets["Moon"] = Planet(name: "Moon",
        //                                 radius: 0.05,
        //                                 tilt: 0,
        //                                 position: SCNVector3(0, 0, -5.5),
        //                                 rotationSpeed: 8,
        //                                 orbitalCenterPosition: SCNVector3(0, 0, -5),
        //                                 orbitalCenterRotationSpeed: 5)
        
        planets["Mars"] = Planet(name: "Mars",
                                 radius: earthRadius * 0.53,
                                 tilt: toRadians(25),
                                 positionAngle: (toRadians(2.8), earthDistance * 1.52),
                                 rotationSpeed: earthDay * 1.04,
                                 orbitalCenterPosition: sun.getPosition(),
                                 orbitalCenterRotationSpeed: earthYear * 1.88)
        
        planets["Jupiter"] = Planet(name: "Jupiter",
                                    radius: earthRadius * 11.21,
                                    tilt: toRadians(3),
                                    positionAngle: (toRadians(4.7), earthDistance * 5.2),
                                    rotationSpeed: earthDay * 0.42,
                                    orbitalCenterPosition: sun.getPosition(),
                                    orbitalCenterRotationSpeed: earthYear * 11.87)
        
        planets["Saturn"] = Planet(name: "Saturn",
                                   radius: earthRadius * 9.45,
                                   tilt: toRadians(27),
                                   positionAngle: (toRadians(13), earthDistance * 9.58),
                                   rotationSpeed: earthDay * 0.46,
                                   orbitalCenterPosition: sun.getPosition(),
                                   orbitalCenterRotationSpeed: earthYear * 29.44)
        
        planets["Uranus"] = Planet(name: "Uranus",
                                   radius: earthRadius * 4.01,
                                   tilt: toRadians(98),
                                   positionAngle: (toRadians(21), earthDistance * 19.18),
                                   rotationSpeed: earthDay * 0.71,
                                   orbitalCenterPosition: sun.getPosition(),
                                   orbitalCenterRotationSpeed: earthYear * 83.81)
        
        planets["Neptune"] = Planet(name: "Neptune",
                                    radius: earthRadius * 3.88,
                                    tilt: toRadians(23),
                                    positionAngle: (toRadians(29), earthDistance * 30.03),
                                    rotationSpeed: earthDay * 0.67,
                                    orbitalCenterPosition: sun.getPosition(),
                                    orbitalCenterRotationSpeed: earthYear * 163.84)
        
        sun.animate()
        sceneView.scene.rootNode.addChildNode(sun.getNode())
        
        for (_, planet) in planets {
            planet.animate()
            sun.addChildNode(planet.getNode())
        }
        
    }
}
