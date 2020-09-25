//
//  PlanetARium.swift
//  PocketPlanetARium
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
    var planets: [String: Planet] = [:]
    var showLabels: Bool = false
    
    //Don't touch these values!
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
    mutating func update(scale: Float, topSpeed speed: TimeInterval = 128, toNode sceneView: ARSCNView) {
        let adjustedScale = pow(scale.clamp(min: scaleMinimum, max: scaleMaximum), scaleFactor)
        
        removeAllPlanetNodes(from: sceneView)
        
        addPlanets(earthRadius: adjustedScale * 3,
                   earthDistance: adjustedScale * -20,
                   earthDay: 8 / speed,
                   earthYear: 365 / speed)
        
        animatePlanets(to: sceneView)
        
        setSpeed(to: scale)
    }
    
    /**
     Adds the solar system to the sceneView.
     - parameters:
        - earthRadius: size of the Earth, in meters
        - earthDistance: distance from the Earth to the sun's center, in meters
        - earthYear: length of time it takes for the Earth to make one revolution around the sun, in seconds
     - This function allows for more independent customization regarding size of planets, orbital distances, and speed of animation.
     */
    mutating func addPlanets(earthRadius: Float, earthDistance: Float, earthDay: TimeInterval, earthYear: TimeInterval) {
        
        sun = Planet(name: "Sun",
                     radius: (abs(earthDistance) * 0.2).clamp(min: 0.008, max: 0.02),
                     tilt: SCNVector3(x: 0, y: 0, z: 0),
                     position: SCNVector3(0, 0, -0.2),
                     rotationSpeed: earthDay * 27,
                     labelColor: #colorLiteral(red: 0.9911546111, green: 1, blue: 0.6582027078, alpha: 1))
        
        guard let sun = sun else {
            print("Sun object not found (this should not happen).")
            return
        }
        
        sun.addParticles()
        
        addPlanetHelper(name: "Mercury",
                        radius: earthRadius * 0.38,
                        tilt: SCNVector3(x: 0, y: 0, z: 0),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 0.39),
                        rotationSpeed: earthDay * 58,
                        orbitalCenterTilt: SCNVector3(x: 0, y: 0, z: K.degToRad(7)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 0.24,
                        labelColor: #colorLiteral(red: 0.7803640962, green: 0.7803606391, blue: 0.7846102715, alpha: 1))
        
        addPlanetHelper(name: "Venus",
                        radius: earthRadius * 0.95,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(177)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 0.72),
                        rotationSpeed: earthDay * 243,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(25), z: K.degToRad(3.4)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 0.62,
                        labelColor: #colorLiteral(red: 0.9863802791, green: 0.8649248481, blue: 0.6479948163, alpha: 1))
        
        //easter egg nested Venus surface skin
        if let venus = planets["Venus"] {
            planets["Venus_Surface"] = Planet(name: "Venus_Surface",
                                              radius: venus.getRadius() * 0.25,
                                              tilt: venus.getTilt(),
                                              position: venus.getNode().position,
                                              rotationSpeed: venus.getRotationSpeed(),
                                              orbitalCenterTilt: venus.getOrbitalCenterTilt(),
                                              orbitalCenterPosition: sun.getNode().position,
                                              orbitalCenterRotationSpeed: venus.getOrbitalCenterRotationSpeed(),
                                              labelColor: UIColor.clear)
        }
        
        addPlanetHelper(name: "Earth",
                        radius: earthRadius,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(23)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance),
                        rotationSpeed: earthDay,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(50), z: 0),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear,
                        labelColor: #colorLiteral(red: 0.364506036, green: 0.4846500158, blue: 0.1734416783, alpha: 1))
        
        //Add earth's moon.
        if let earth = planets["Earth"] {
            moon = Planet(name: "Moon",
                          radius: earthRadius * 0.25,
                          tilt: moon == nil ? SCNVector3(x: 0, y: .pi, z: K.degToRad(5.9)) : moon!.getNode().eulerAngles,
                          position: SCNVector3(0, 0, earthRadius + earthRadius * 0.5),
                          rotationSpeed: 9999,
                          orbitalCenterTilt: moon == nil ? SCNVector3(x: 0, y:0, z: K.degToRad(5.1)) : moon!.getOrbitalCenterNode().eulerAngles,
                          orbitalCenterPosition: earth.getNode().position,
                          orbitalCenterRotationSpeed: earthDay * 27,
                          labelColor: #colorLiteral(red: 0.7616128325, green: 0.7565351129, blue: 0.7696220279, alpha: 1))
            
            if let moon = moon {
                earth.addSatellite(moon)
            }
        }
        
        addPlanetHelper(name: "Mars",
                        radius: earthRadius * 0.53,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(25)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 1.52),
                        rotationSpeed: earthDay * 1.04,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(70), z: K.degToRad(1.9)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 1.88,
                        labelColor: #colorLiteral(red: 0.8029935956, green: 0.4123460054, blue: 0.2786666751, alpha: 1))
        
        addPlanetHelper(name: "Jupiter",
                        radius: earthRadius * 11.21,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(3)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 5.2),
                        rotationSpeed: earthDay * 0.42,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(100), z: K.degToRad(1.3)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 11.87,
                        labelColor: #colorLiteral(red: 0.6988996863, green: 0.6137880087, blue: 0.5267551541, alpha: 1))
        
        addPlanetHelper(name: "Saturn",
                        radius: earthRadius * 9.45,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(27)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 9.58),
                        rotationSpeed: earthDay * 0.46,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(150), z: K.degToRad(2.5)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 29.44,
                        labelColor: #colorLiteral(red: 0.6580071449, green: 0.6360285878, blue: 0.521181643, alpha: 1))
        
        if let saturn = planets["Saturn"] {
            saturn.addRings(imageFileName: "saturn_rings2", innerRadius: saturn.getRadius() * 1.1, outerRadius: saturn.getRadius() * 2.3)
        }
        
        addPlanetHelper(name: "Uranus",
                        radius: earthRadius * 4.01,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(98)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 19.18),
                        rotationSpeed: earthDay * 0.71,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(180), z: K.degToRad(0.8)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 83.81,
                        labelColor: #colorLiteral(red: 0.6661632061, green: 0.8760991096, blue: 0.9032817483, alpha: 1))
        
        if let uranus = planets["Uranus"] {
            uranus.addRings(imageFileName: "noimg", innerRadius: uranus.getRadius() * 2, outerRadius: uranus.getRadius() * 2)
        }
        
        addPlanetHelper(name: "Neptune",
                        radius: earthRadius * 3.88,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(23)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 30.03),
                        rotationSpeed: earthDay * 0.67,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(195), z: K.degToRad(1.8)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 163.84,
                        labelColor: #colorLiteral(red: 0.2331839204, green: 0.4608405828, blue: 0.8007237315, alpha: 1))
        
        addPlanetHelper(name: "Pluto",
                        radius: earthRadius,// * 0.19,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(122)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 39.48),
                        rotationSpeed: earthDay * 6.38,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(200), z: K.degToRad(17.2)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 248.1,
                        labelColor: #colorLiteral(red: 0.8180410266, green: 0.6948351264, blue: 0.5951495767, alpha: 1))
        
        showLabels(showLabels)
    }
    
    /**
     Clears the scene view. Should be called before adding the solar system to the scene view.
     - parameter sceneView: the scene view to remove the solar system from
     */
    func removeAllPlanetNodes(from sceneView: ARSCNView) {
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
    }
    
    /**
     Adds all the planet nodes and animates them to the scene view.
     - parameter sceneView: the scene view to add the solar system to
     */
    func animatePlanets(to sceneView: ARSCNView) {
        guard let sun = sun else {
            print("Sun object not found.")
            return
        }
        
        if let moon = moon {
            moon.animate()
        }
        
        for (_, planet) in planets {
            planet.animate()
            planet.addOrbitPath()

            sun.addSatellite(planet)
        }
        
        sun.animate()
        sun.addLightSource(omniLumens: 1000, ambientLumens: 250)
        
        sceneView.scene.rootNode.addChildNode(sun.getOrbitalCenterNode())
    }
    
    mutating func showLabels(_ show: Bool) {
        self.showLabels = show
        
        if var sun = sun {
            sun.showLabel(show)
        }
        
        if var moon = moon {
            moon.showLabel(show)
        }
        
        for (_, planet) in planets {
            var planetTemp = planet
            planetTemp.showLabel(show)
        }
    }
    
    
    // MARK: - Speed controls
    
    /**
     Sets the speed of the animation to the given input value.
     - parameter speed: range from 0 to 1, with 1 being actual speed
     */
    func setSpeed(to speed: Float) {
        let adjustedSpeed = pow((1 - speed).clamp(min: scaleMinimum, max: scaleMaximum), scaleFactor)
        
        for action in getAllActions() {
            action.speed = CGFloat(adjustedSpeed)
        }
    }
    
    /**
     Pauses all animations.
     */
    func pauseAnimation() {
        for action in getAllActions() {
            action.speed = CGFloat(pow(scaleMinimum, scaleFactor))
        }
    }
    
    
    // MARK: - Helper Functions
    
    /**
     Adds a planet to the dictionary. This allows for preservation of the last animated planet tilt and orbital center tilt angles.
     */
    private mutating func addPlanetHelper(name: String, radius: Float, tilt: SCNVector3, position: SCNVector3, rotationSpeed: TimeInterval, orbitalCenterTilt: SCNVector3, orbitalCenterPosition: SCNVector3, orbitalCenterRotationSpeed: TimeInterval, labelColor: UIColor) {
        
        let lastTilt = planets[name] == nil ? tilt : planets[name]!.getNode().eulerAngles
        let lastOrbitalCenterTilt = planets[name] == nil ? orbitalCenterTilt : planets[name]!.getOrbitalCenterNode().eulerAngles
        
        planets[name] = Planet(name: name,
                               radius: radius,
                               tilt: lastTilt,
                               position: position,
                               rotationSpeed: rotationSpeed,
                               orbitalCenterTilt: lastOrbitalCenterTilt,
                               orbitalCenterPosition: orbitalCenterPosition,
                               orbitalCenterRotationSpeed: orbitalCenterRotationSpeed,
                               labelColor: labelColor)
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
        
        if let moon = moon {
            for action in moon.getAllPlanetActions() {
                actions.append(action)
            }
        }
        
        return actions
    }
}
