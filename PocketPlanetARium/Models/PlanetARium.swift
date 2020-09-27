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
    //Don't touch these values!
    private let scaleFactor: Float = 3
    private let scaleMinimum: Float = 0.123
    private let scaleMaximum: Float = 1

    //PlanetARium variables
    private var planets = PlanetGroup()
    private var showLabels: Bool = false
    
        
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
        addPlanetHelper(name: "Sun",
                        type: PlanetType.sun,
                        radius: (abs(earthDistance) * 0.2).clamp(min: 0.008, max: 0.02),
                        tilt: SCNVector3(x: 0, y: 0, z: 0),
                        position: SCNVector3(0, 0, -0.2),
                        rotationSpeed: earthDay * 27,
                        labelColor: #colorLiteral(red: 0.9911546111, green: 1, blue: 0.6582027078, alpha: 1))

        guard let sun = planets.getPlanet(withName: "Sun") else {
            print("Sun not found when trying to addPlanets")
            return
        }
        
        sun.addParticles()
        
        
        addPlanetHelper(name: "Mercury",
                        type: PlanetType.planet,
                        radius: earthRadius * 0.38,
                        tilt: SCNVector3(x: 0, y: 0, z: 0),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 0.39),
                        rotationSpeed: earthDay * 58,
                        orbitalCenterTilt: SCNVector3(x: 0, y: 0, z: K.degToRad(7)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 0.24,
                        labelColor: #colorLiteral(red: 0.7803640962, green: 0.7803606391, blue: 0.7846102715, alpha: 1))
        
        addPlanetHelper(name: "Venus",
                        type: PlanetType.planet,
                        radius: earthRadius * 0.95,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(177)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 0.72),
                        rotationSpeed: earthDay * 243,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(25), z: K.degToRad(3.4)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 0.62,
                        labelColor: #colorLiteral(red: 0.9863802791, green: 0.8649248481, blue: 0.6479948163, alpha: 1))
        
        //Easter egg nested Venus surface skin.
        if let venus = planets.getPlanet(withName: "Venus") {
            addPlanetHelper(name: "Venus_Surface",
                            type: PlanetType.planet,
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
                        type: PlanetType.planet,
                        radius: earthRadius,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(23)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance),
                        rotationSpeed: earthDay,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(50), z: 0),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear,
                        labelColor: #colorLiteral(red: 0.364506036, green: 0.4846500158, blue: 0.1734416783, alpha: 1))
        
        //Add earth's moon.
        if let earth = planets.getPlanet(withName: "Earth") {
            let moonCheck = planets.getPlanet(withName: "Moon")

            addPlanetHelper(name: "Moon",
                          type: PlanetType.moon,
                          radius: earthRadius * 0.25,
                          tilt: moonCheck == nil ? SCNVector3(x: 0, y: .pi, z: K.degToRad(5.9)) : moonCheck!.getNode().eulerAngles,
                          position: SCNVector3(0, 0, earthRadius + earthRadius * 0.5),
                          rotationSpeed: 9999,
                          orbitalCenterTilt: moonCheck == nil ? SCNVector3(x: 0, y:0, z: K.degToRad(5.1)) : moonCheck!.getOrbitalCenterNode().eulerAngles,
                          orbitalCenterPosition: earth.getNode().position,
                          orbitalCenterRotationSpeed: earthDay * 27,
                          labelColor: #colorLiteral(red: 0.7616128325, green: 0.7565351129, blue: 0.7696220279, alpha: 1))

            if let moon = planets.getPlanet(withName: "Moon") {
                earth.addSatellite(moon)
            }
        }
        
        addPlanetHelper(name: "Mars",
                        type: PlanetType.planet,
                        radius: earthRadius * 0.53,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(25)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 1.52),
                        rotationSpeed: earthDay * 1.04,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(70), z: K.degToRad(1.9)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 1.88,
                        labelColor: #colorLiteral(red: 0.8029935956, green: 0.4123460054, blue: 0.2786666751, alpha: 1))
        
        addPlanetHelper(name: "Jupiter",
                        type: PlanetType.planet,
                        radius: earthRadius * 11.21,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(3)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 5.2),
                        rotationSpeed: earthDay * 0.42,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(100), z: K.degToRad(1.3)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 11.87,
                        labelColor: #colorLiteral(red: 0.6988996863, green: 0.6137880087, blue: 0.5267551541, alpha: 1))
        
        addPlanetHelper(name: "Saturn",
                        type: PlanetType.planet,
                        radius: earthRadius * 9.45,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(27)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 9.58),
                        rotationSpeed: earthDay * 0.46,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(150), z: K.degToRad(2.5)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 29.44,
                        labelColor: #colorLiteral(red: 0.6580071449, green: 0.6360285878, blue: 0.521181643, alpha: 1))
        
        if let saturn = planets.getPlanet(withName: "Saturn") {
            saturn.addRings(imageFileName: "saturn_rings2", innerRadius: saturn.getRadius() * 1.1, outerRadius: saturn.getRadius() * 2.3)
        }
        
        addPlanetHelper(name: "Uranus",
                        type: PlanetType.planet,
                        radius: earthRadius * 4.01,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(98)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 19.18),
                        rotationSpeed: earthDay * 0.71,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(180), z: K.degToRad(0.8)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 83.81,
                        labelColor: #colorLiteral(red: 0.6661632061, green: 0.8760991096, blue: 0.9032817483, alpha: 1))
        
        if let uranus = planets.getPlanet(withName: "Uranus") {
            uranus.addRings(imageFileName: "noimg", innerRadius: uranus.getRadius() * 2, outerRadius: uranus.getRadius() * 2)
        }
            
        addPlanetHelper(name: "Neptune",
                        type: PlanetType.planet,
                        radius: earthRadius * 3.88,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(23)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 30.03),
                        rotationSpeed: earthDay * 0.67,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(195), z: K.degToRad(1.8)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 163.84,
                        labelColor: #colorLiteral(red: 0.2331839204, green: 0.4608405828, blue: 0.8007237315, alpha: 1))
        
        addPlanetHelper(name: "Pluto",
                        type: PlanetType.planet,
                        radius: earthRadius,// * 0.19,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(122)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 39.48),
                        rotationSpeed: earthDay * 6.38,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(200), z: K.degToRad(17.2)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 248.1,
                        labelColor: #colorLiteral(red: 0.8180410266, green: 0.6948351264, blue: 0.5951495767, alpha: 1))
        
        showAllLabels(showLabels)
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
        guard let sun = planets.getPlanets(withType: PlanetType.sun).first else {
            print("Sun not found.")
            return
        }

        for moon in planets.getPlanets(withType: PlanetType.moon) {
            moon.animate()
        }

        for planet in planets.getPlanets(withType: PlanetType.planet) {
            planet.animate()
            planet.addOrbitPath()

            sun.addSatellite(planet)
        }

        sun.animate()
        sun.addLightSource(omniLumens: 1000, ambientLumens: 250)

        sceneView.scene.rootNode.addChildNode(sun.getOrbitalCenterNode())
    }
    
    /**
     Shows or hides the label for all planets in the PlanetGroup.
     - parameter show: determines whether to show or hide the labels
     - This function also sets the showLabels property based on the value of show passed in, which is why this is a mutating function.
     */
    mutating func showAllLabels(_ show: Bool) {
        self.showLabels = show
                
        for planet in planets.getAllPlanets() {
            var planetTemp = planet
            planetTemp.showLabel(show)
        }
    }
    
    /**
     Shows or hides the label for a particular Planet.
     - parameters:
        - show: determines whether to show or hide the label
        - planet: the Planet for which to show its label
     */
    func showLabel(_ show: Bool, forPlanet planet: Planet) {
        var planetTemp = planet
        planetTemp.showLabel(show)
    }
    
    /**
     Resets all planet positions by clearing the group and call update(scale:toNode:) to restart the animation.
     - parameters:
        - scale: solar system scale with respect to size and orbital distance; works well with values between 0 to 1, i.e. slider values
        - topSpeed: max speed of the animation
        - toNode: the scene view to add the solar system to
     */
    mutating func resetPlanets(withScale scale: Float, topSpeed speed: TimeInterval = 128, toNode sceneView: ARSCNView) {
        planets = PlanetGroup()
        
        update(scale: scale, topSpeed: speed, toNode: sceneView)
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
    
    
    // MARK: - Getters
    
    /**
     Return the requested planet, sun, or moon. (This will grow inefficiently. Have a struct to house the planets? PlanetDirectory.
     - parameter planetName: name of the planet
     */
    func getPlanet(withName planetName: String) -> Planet? {
        return planets.getPlanet(withName: planetName)
    }
    
    
    // MARK: - Helper Functions
    
    /**
     Adds a planet to the dictionary. This allows for preservation of the last animated planet tilt and orbital center tilt angles.
     - parameters:
        - name: planet's name
        - radius: planet's radius in m
        - tilt: planet's axial tilt
        - position: planet's position with respect to its orbital center
        - rotationSpeed: time in seconds to complete one rotation around a planet's axis
        - orbitalCenterTilt: planet's orbital center's axial tilt
        - orbitalCenterPosition: position of a planet's orbital center in space
        - orbitalCenterRotationSpeed: time it takes planet to complete one revolution around its orbital center.
        - labelColor: color of the planet label
     */
    private mutating func addPlanetHelper(name: String, type: PlanetType, radius: Float, tilt: SCNVector3, position: SCNVector3, rotationSpeed: TimeInterval, orbitalCenterTilt: SCNVector3, orbitalCenterPosition: SCNVector3, orbitalCenterRotationSpeed: TimeInterval?, labelColor: UIColor) {
        
        let planet = planets.getPlanet(withName: name)
        let lastTilt = planet == nil ? tilt : planet!.getNode().eulerAngles
        let lastOrbitalCenterTilt = planet == nil ? orbitalCenterTilt : planet!.getOrbitalCenterNode().eulerAngles

        planets.addPlanet(Planet(name: name,
                                       type: type,
                                       radius: radius,
                                       tilt: lastTilt,
                                       position: position,
                                       rotationSpeed: rotationSpeed,
                                       orbitalCenterTilt: lastOrbitalCenterTilt,
                                       orbitalCenterPosition: orbitalCenterPosition,
                                       orbitalCenterRotationSpeed: orbitalCenterRotationSpeed,
                                       labelColor: labelColor))
    }
    
    /**
     Adds a planet to the dictionary, with no orbital center properties. This allows for preservation of the last animated planet tilt and orbital center tilt angles.
     - parameters:
        - name: planet's name
        - radius: planet's radius in m
        - tilt: planet's axial tilt
        - position: planet's position with respect to its orbital center
        - rotationSpeed: time in seconds to complete one rotation around a planet's axis
        - labelColor: color of the planet label
     */
    private mutating func addPlanetHelper(name: String, type: PlanetType, radius: Float, tilt: SCNVector3, position: SCNVector3, rotationSpeed: TimeInterval, labelColor: UIColor) {
        
        let planet = planets.getPlanet(withName: name)
        let lastTilt = planet == nil ? tilt : planet!.getNode().eulerAngles

        planets.addPlanet(Planet(name: name,
                                       type: type,
                                       radius: radius,
                                       tilt: lastTilt,
                                       position: position,
                                       rotationSpeed: rotationSpeed,
                                       labelColor: labelColor))
    }
    
    /**
     Iterates through all planet objects and returns all current SCNActions.
     */
    private func getAllActions() -> [SCNAction] {
        var actions = [SCNAction]()
        
        for planet in planets.getAllPlanets() {
            for action in planet.getAllPlanetActions() {
                actions.append(action)
            }
        }
        
        return actions
    }
}
