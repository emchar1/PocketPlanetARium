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
    private let scaleFactor: Float = 3
    private let scaleMinimum: Float = 0.123
    private var sun: Planet?
    private var planets: [String: Planet] = [:]
    
    
    // MARK: - Add/Remove Planets to Scene
    
    /**
     Convenience method(?) that calls addPlanets but normalizes the input parameters in a range of (0, 1]
     */
    mutating func addPlanets(scale: Float, toNode sceneView: ARSCNView) {
        let adjustedScale = scale < scaleMinimum ? pow(scaleMinimum, scaleFactor) : pow(scale, scaleFactor)
                
        self.addPlanets(earthRadius: adjustedScale * 3,
                        earthDistance: adjustedScale * -20,
                        earthYear: 365 / 64,
                        toNode: sceneView)
    }

    /**
     Adds the sun and planets to the sceneView, and animates them.
     - parameters:
        - earthRadius: size of the Earth, in meters
        - earthDistance: distance from the Earth to the sun's center, in meters
        - earthYear: length of time it takes for the Earth to make one revolution around the sun, in seconds
        - sceneView: the scene view to add the sun and planets to
     */
    mutating func addPlanets(earthRadius: Float, earthDistance: Float, earthYear: TimeInterval, toNode sceneView: ARSCNView) {
        /**
         Helper function converts degrees value to radians.
         - parameter degrees: The degree value
         - returns: The degree value as a radian value
         */
        func toRadians(_ degrees: Float) -> Float {
            return Float.pi / (180 / degrees)
        }
        
        
        //Set up the sun and planets
        sun = Planet(name: "Sun",
                     radius: 0.008,
                     tilt: 0,
                     position: SCNVector3(0, 0, -0.2),
                     rotationSpeed: (earthYear / 365) * 27)
        guard let sun = sun else {
            print("Sun was nil (this should not happen).")
            return
        }
        
        planets["Mercury"] = Planet(name: "Mercury",
                                    radius: earthRadius * 0.38,
                                    tilt: 0,
                                    aPosition: (toRadians(5), earthDistance * 0.39),
                                    rotationSpeed: (earthYear / 365) * 58,
                                    orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                    orbitalCenterRotationSpeed: earthYear * 0.24)
        
        planets["Venus"] = Planet(name: "Venus",
                                  radius: earthRadius * 0.95,
                                  tilt: toRadians(177),
                                  aPosition: (toRadians(25), earthDistance * 0.72),
                                  rotationSpeed: (earthYear / 365) * 243,
                                  orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                  orbitalCenterRotationSpeed: earthYear * 0.62)
        
        planets["Earth"] = Planet(name: "Earth",
                                  radius: earthRadius,
                                  tilt: toRadians(23),
                                  aPosition: (toRadians(50), earthDistance),
                                  rotationSpeed: (earthYear / 365),
                                  orbitalCenterPosition: sun.getOrbitalCenterNode().position,
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
                                 aPosition: (toRadians(70), earthDistance * 1.52),
                                 rotationSpeed: (earthYear / 365) * 1.04,
                                 orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                 orbitalCenterRotationSpeed: earthYear * 1.88)
        
        planets["Jupiter"] = Planet(name: "Jupiter",
                                    radius: earthRadius * 11.21,
                                    tilt: toRadians(3),
                                    aPosition: (toRadians(100), earthDistance * 5.2),
                                    rotationSpeed: (earthYear / 365) * 0.42,
                                    orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                    orbitalCenterRotationSpeed: earthYear * 11.87)
        
        planets["Saturn"] = Planet(name: "Saturn",
                                   radius: earthRadius * 9.45,
                                   tilt: toRadians(27),
                                   aPosition: (toRadians(150), earthDistance * 9.58),
                                   rotationSpeed: (earthYear / 365) * 0.46,
                                   orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                   orbitalCenterRotationSpeed: earthYear * 29.44)
        
        planets["Uranus"] = Planet(name: "Uranus",
                                   radius: earthRadius * 4.01,
                                   tilt: toRadians(98),
                                   aPosition: (toRadians(180), earthDistance * 19.18),
                                   rotationSpeed: (earthYear / 365) * 0.71,
                                   orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                   orbitalCenterRotationSpeed: earthYear * 83.81)
        
        planets["Neptune"] = Planet(name: "Neptune",
                                    radius: earthRadius * 3.88,
                                    tilt: toRadians(23),
                                    aPosition: (toRadians(195), earthDistance * 30.03),
                                    rotationSpeed: (earthYear / 365) * 0.67,
                                    orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                    orbitalCenterRotationSpeed: earthYear * 163.84)
        
        sun.animate()
        sceneView.scene.rootNode.addChildNode(sun.getOrbitalCenterNode())
        
        for (_, planet) in planets {
            planet.animate()
            sun.addSatellite(planet)
        }
    }

    /**
     Removes the sun and planets from the scene view.
     - parameter sceneView: the ARSCNView from which to remove all child nodes
     */
    func removePlanets(from sceneView: ARSCNView) {
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
    }
    
    
    // MARK: - Adjust Actions
    
    /**
     Resumes any SCNActions at the given speed.
     - parameter speed: the speed setting of the SCNActions
     */
    func resumeActions(for speed: Float = 1) {
        for action in getAllActions() {
            action.speed = CGFloat(pow(speed, scaleFactor))
        }
    }
    
    /**
     Pauses all SCNActions, i.e. sets speed to 0.
     */
    func pauseActions() {
        for action in getAllActions() {
            action.speed = 0
        }
    }
    
    /**
     Iterates through all planet objects and returns all current SCNActions.
     */
    private func getAllActions() -> [SCNAction] {
        var actions = [SCNAction]()
        
        if let sun = sun {
            for action in sun.getAllPlanetActions() {
                actions.append(action)
            }
        }
        
        for (_, planet) in planets {
            for action in planet.getAllPlanetActions() {
                actions.append(action)
            }
        }
        
        return actions
    }
}
