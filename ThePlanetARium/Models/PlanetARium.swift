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
    private var sun: Planet?
    private var moon: Planet?
    private var planets: [String: Planet] = [:]
    
    //Don't touch these values!!
    private let scaleFactor: Float = 3
    private let scaleMinimum: Float = 0.123
    private let scaleMaximum: Float = 1
    
    
    // MARK: - Add/Remove Planets to Scene
    
    /**
     Adds the solar system to the sceneView, and animates them in an intuitive way with respect to size, scale, and speed.
     - parameters:
        - scale: solar system scale with respect to size and orbital distance; works well with values between 0 to 1, i.e. slider values
        - topSpeed: max speed of the animation
        - toNode: the scene view to add the solar system to
     - The higher the topSpeed, the faster the animation. Suggested values: 2, 4, 8, 16, 32, 64, 128, 256
     */
    mutating func addPlanets(scale: Float, topSpeed speed: TimeInterval = 128, toNode sceneView: ARSCNView) {
        let adjustedScale = pow(min(scaleMaximum, max(scaleMinimum, scale)), scaleFactor)
                
        self.addPlanets(earthRadius: adjustedScale * 3,
                        earthDistance: adjustedScale * -20,
                        earthDay: 1 / speed,
                        earthYear: 365 / speed,
                        toNode: sceneView)
        
        setSpeed(to: scale)
    }

    /**
     Adds the solar system to the sceneView, and animates them.
     - parameters:
        - earthRadius: size of the Earth, in meters
        - earthDistance: distance from the Earth to the sun's center, in meters
        - earthYear: length of time it takes for the Earth to make one revolution around the sun, in seconds
        - sceneView: the scene view to add the solar system to
     - This function allows for more independent customization regarding size of planets, orbital distances, and speed of animation.
     */
    mutating func addPlanets(earthRadius: Float, earthDistance: Float, earthDay: TimeInterval, earthYear: TimeInterval, toNode sceneView: ARSCNView) {
        /**
         Helper function converts degrees value to radians.
         - parameter degrees: The degree value
         - returns: The degree value as a radian value
         */
        func toRadians(_ degrees: Float) -> Float {
            return Float.pi / (180 / degrees)
        }
        
        //Clears the scene view before setting up the solar system.
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        
        //Set up the solar system
        sun = Planet(name: "Sun",
                     radius: min(max(0.008, abs(earthDistance) * 0.2), 0.02),
                     tilt: SCNVector3(x: 0, y: 0, z: 0),
                     position: SCNVector3(0, 0, -0.2),
                     rotationSpeed: earthDay * 27)
        
        guard let sun = sun else {
            print("Sun was nil (this should not happen).")
            return
        }
        
        planets["Mercury"] = Planet(name: "Mercury",
                                    radius: earthRadius * 0.38,
                                    tilt: SCNVector3(x: 0, y: 0, z: 0),
                                    aPosition: (toRadians(5), earthDistance * 0.39),
                                    rotationSpeed: earthDay * 58,
                                    orbitalCenterTilt: SCNVector3(x: 0, y: 0, z: 0),
                                    orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                    orbitalCenterRotationSpeed: earthYear * 0.24)
        
        planets["Venus"] = Planet(name: "Venus",
                                  radius: earthRadius * 0.95,
                                  tilt: SCNVector3(x: 0, y: 0, z: toRadians(177)),
                                  aPosition: (toRadians(25), earthDistance * 0.72),
                                  rotationSpeed: earthDay * 243,
                                  orbitalCenterTilt: SCNVector3(x: 0, y: 0, z: 0),
                                  orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                  orbitalCenterRotationSpeed: earthYear * 0.62)
        
        //easter egg nested Venus surface skin
        if let venus = planets["Venus"] {
            planets["Venus_Surface"] = Planet(name: "Venus_Surface",
                                              radius: venus.getRadius() * 0.25,
                                              tilt: venus.getTilt(),
                                              position: venus.getNode().position,
                                              rotationSpeed: venus.getRotationSpeed(),
                                              orbitalCenterTilt: venus.getOrbitalCenterTilt(),
                                              orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                              orbitalCenterRotationSpeed: venus.getOrbitalCenterRotationSpeed())
        }
        
        planets["Earth"] = Planet(name: "Earth",
                                  radius: earthRadius,
                                  tilt: SCNVector3(x: 0, y: 0, z: toRadians(23)),
                                  aPosition: (toRadians(50), earthDistance),
                                  rotationSpeed: earthDay,
                                  orbitalCenterTilt: SCNVector3(x: 0, y: 0, z: 0),
                                  orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                  orbitalCenterRotationSpeed: earthYear)
        
        //Add earth's moon.
        if let earth = planets["Earth"] {
            moon = Planet(name: "Moon",
                          radius: earthRadius * 0.25,
                          tilt: SCNVector3(x: 0, y: .pi, z: toRadians(6.9)),
                          position: SCNVector3(0, 0, earthRadius + earthRadius * 0.5),
                          rotationSpeed: 9999,
                          orbitalCenterTilt: SCNVector3(x: 0, y: 0, z: toRadians(5.1)),
                          orbitalCenterPosition: earth.getNode().position,
                          orbitalCenterRotationSpeed: earthDay * 27)

            if let moon = moon {
                earth.addSatellite(moon)
            }
        }
                
        planets["Mars"] = Planet(name: "Mars",
                                 radius: earthRadius * 0.53,
                                 tilt: SCNVector3(x: 0, y: 0, z: toRadians(25)),
                                 aPosition: (toRadians(70), earthDistance * 1.52),
                                 rotationSpeed: earthDay * 1.04,
                                 orbitalCenterTilt: SCNVector3(x: 0, y: 0, z: 0),
                                 orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                 orbitalCenterRotationSpeed: earthYear * 1.88)
        
        planets["Jupiter"] = Planet(name: "Jupiter",
                                    radius: earthRadius * 11.21,
                                    tilt: SCNVector3(x: 0, y: 0, z: toRadians(3)),
                                    aPosition: (toRadians(100), earthDistance * 5.2),
                                    rotationSpeed: earthDay * 0.42,
                                    orbitalCenterTilt: SCNVector3(x: 0, y: 0, z: 0),
                                    orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                    orbitalCenterRotationSpeed: earthYear * 11.87)
        
        planets["Saturn"] = Planet(name: "Saturn",
                                   radius: earthRadius * 9.45,
                                   tilt: SCNVector3(x: 0, y: 0, z: toRadians(27)),
                                   aPosition: (toRadians(150), earthDistance * 9.58),
                                   rotationSpeed: earthDay * 0.46,
                                   orbitalCenterTilt: SCNVector3(x: 0, y: 0, z: 0),
                                   orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                   orbitalCenterRotationSpeed: earthYear * 29.44)
        
        if let saturn = planets["Saturn"] {
            saturn.addRings(name: "saturn_rings", innerRadius: saturn.getRadius() * 1.1, outerRadius: saturn.getRadius() * 2.2)
        }
        
        planets["Uranus"] = Planet(name: "Uranus",
                                   radius: earthRadius * 4.01,
                                   tilt: SCNVector3(x: 0, y: 0, z: toRadians(98)),
                                   aPosition: (toRadians(180), earthDistance * 19.18),
                                   rotationSpeed: earthDay * 0.71,
                                   orbitalCenterTilt: SCNVector3(x: 0, y: 0, z: 0),
                                   orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                   orbitalCenterRotationSpeed: earthYear * 83.81)
        
        planets["Neptune"] = Planet(name: "Neptune",
                                    radius: earthRadius * 3.88,
                                    tilt: SCNVector3(x: 0, y: 0, z: toRadians(23)),
                                    aPosition: (toRadians(195), earthDistance * 30.03),
                                    rotationSpeed: earthDay * 0.67,
                                    orbitalCenterTilt: SCNVector3(x: 0, y: 0, z: 0),
                                    orbitalCenterPosition: sun.getOrbitalCenterNode().position,
                                    orbitalCenterRotationSpeed: earthYear * 163.84)
        
        
        //Animate the solar system!
        if let moon = moon {
            moon.animate()
        }
        
        for (_, planet) in planets {
            planet.animate()
            sun.addSatellite(planet)
            
            planet.addOrbitPath()
        }
        
        sun.animate()
        
        sceneView.scene.rootNode.addChildNode(sun.getOrbitalCenterNode())
    }
    
    
    // MARK: - Speed controls
    
    /**
     Is this what I was trying to solve???????????????????????????????????????????
     */
    func scalePlanets(to scale: Float) {
        let adjustedScale = pow(min(scaleMaximum, max(scaleMinimum, scale)), scaleFactor)

        for (_, planet) in planets {
            let node = planet.getNode()
            
            node.simdScale = SIMD3(x: adjustedScale, y: adjustedScale, z: adjustedScale)
//            node.simdWorldPosition = simd_float3(x: adjustedScale, y: adjustedScale, z: adjustedScale)
        }
        
        if let moon = moon {
            let node = moon.getNode()
            
            node.simdScale = SIMD3(x: adjustedScale, y: adjustedScale, z: adjustedScale)
//            node.simdPosition = SIMD3(x: adjustedScale * node.position.x, y: adjustedScale * node.position.y, z: adjustedScale * node.position.z)
        }
        
        setSpeed(to: scale)
    }
    
    /**
     Sets the speed of the animation to the given input value.
     - parameter speed: range from 0 to 1, with 1 being actual speed
     */
    func setSpeed(to speed: Float) {
        let adjustedSpeed = pow(min(scaleMaximum, max(scaleMinimum, 1 - speed)), scaleFactor)
        
        for action in getAllActions() {
            action.speed = CGFloat(adjustedSpeed)
        }
    }

    /**
     Pauses all animations.
     */
    func pauseAnimation() {
        for action in getAllActions() {
            action.speed = CGFloat(pow(scaleMinimum, scaleFactor + 1))
        }
    }
    
    
    // MARK: - Helper Functions
    
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
        
        if let moon = moon {
            for action in moon.getAllPlanetActions() {
                actions.append(action)
            }
        }
        
        return actions
    }
}
