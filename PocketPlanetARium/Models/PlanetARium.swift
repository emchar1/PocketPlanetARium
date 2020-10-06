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
    private let scaleSpeed: TimeInterval = 128

    //PlanetARium variables
    private var planets = PlanetGroup()
    private var labelsOn: Bool = false
    
        
    // MARK: - Animation Controls
    
    /**
     Adds the solar system to the sceneView, and animates them in an intuitive way with respect to size, scale, and speed.
     - parameters:
        - scale: solar system scale with respect to size and orbital distance; works well with values between 0 to 1, i.e. slider values
        - topSpeed: max speed of the animation
        - toNode: the scene view to add the solar system to
     - The higher the topSpeed, the faster the animation. Suggested values: 2, 4, 8, 16, 32, 64, 128, 256
     */
    mutating func beginAnimation(scale: Float, topSpeed speed: TimeInterval? = nil, toNode sceneView: ARSCNView) {
        let adjustedScale = pow(scale.clamp(min: scaleMinimum, max: scaleMaximum), scaleFactor)
        let adjustedSpeed = speed ?? scaleSpeed
        
        removePlanets(from: sceneView)
        
        addPlanets(earthRadius: adjustedScale * 3,
                   earthDistance: adjustedScale * -20,
                   earthDay: 8 / adjustedSpeed,
                   earthYear: 365 / adjustedSpeed)
        
        animatePlanets(to: sceneView)
        
        resumeAnimation(to: scale)
    }
        
    /**
     Sets the speed of the animation to the given input value.
     - parameter speed: range from 0 to 1, with 1 being actual speed
     */
    func resumeAnimation(to speed: Float) {
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
    
    /**
     Resets all planet positions by clearing the group and call update(scale:toNode:) to restart the animation.
     - parameters:
        - scale: solar system scale with respect to size and orbital distance; works well with values between 0 to 1, i.e. slider values
        - topSpeed: max speed of the animation
        - toNode: the scene view to add the solar system to
     */
    mutating func resetAnimation(withScale scale: Float, topSpeed speed: TimeInterval? = nil, toNode sceneView: ARSCNView) {
        let adjustedSpeed = speed ?? scaleSpeed

        planets = PlanetGroup()
        
        beginAnimation(scale: scale, topSpeed: adjustedSpeed, toNode: sceneView)
    }
        
    
    // MARK: - Customization
    
    /**
     Return the requested planet, sun, or moon. (This will grow inefficiently. Have a struct to house the planets? PlanetDirectory.
     - parameter planetName: name of the planet
     */
    func getPlanet(withName planetName: String) -> Planet? {
        return planets.getPlanet(withName: planetName)
    }
    
    /**
     Shows or hides the label for a particular Planet or all Planets.
     - parameters:
        - show: determines whether to show or hide the label, if nil, go with labelsOn value
        - planet: the Planet for which to show its label, if nil, show label for all planets
     */
    func showLabels(_ show: Bool? = nil, forPlanet planet: Planet? = nil) {
        if let planet = planet {
            var planetTemp = planet
            planetTemp.showLabel(show ?? labelsOn)
        }
        else {
            for planet in planets.getAllPlanets() {
                var planetTemp = planet
                planetTemp.showLabel(show ?? labelsOn)
            }
        }
    }
    
    /**
     Toggles the labelsOn, i.e. switch on and off, turn true or false, switch 1 and 0... you get it.
     */
    mutating func toggleLabels() {
        labelsOn = !labelsOn
    }
    
    /**
     Returns staus of labelsOn.
     */
    func areLabelsOn() -> Bool {
        return labelsOn
    }
        
    
    // MARK: - Helper Functions
    
    /**
     Adds the solar system to the sceneView.
     - parameters:
        - earthRadius: size of the Earth, in meters
        - earthDistance: distance from the Earth to the sun's center, in meters
        - earthYear: length of time it takes for the Earth to make one revolution around the sun, in seconds
     - This function allows for more independent customization regarding size of planets, orbital distances, and speed of animation.
     */
    mutating private func addPlanets(earthRadius: Float, earthDistance: Float, earthDay: TimeInterval, earthYear: TimeInterval) {
        addPlanetHelper(name: "Sun",
                        type: PlanetType.sun,
                        radius: (abs(earthDistance) * 0.2).clamp(min: 0.008, max: 0.02),
                        tilt: SCNVector3(x: 0, y: 0, z: 0),
                        position: SCNVector3(0, 0, -0.2),
                        rotationSpeed: earthDay * 27,
                        labelColor: #colorLiteral(red: 0.9960784314, green: 0.6784313725, blue: 0.4784313725, alpha: 1),
                        details: PlanetDetails(stats: [PlanetStats.day.rawValue : "648 hrs",
                                                       PlanetStats.distance.rawValue : "--",
                                                       PlanetStats.gravity.rawValue : "274 m/s2",
                                                       PlanetStats.mass.rawValue : "2.0x1030 kg",
                                                       PlanetStats.moons.rawValue : "0",
                                                       PlanetStats.order.rawValue : "--",
                                                       PlanetStats.radius.rawValue : "432,690 mi",
                                                       PlanetStats.year.rawValue : "--"],
                                               details: "The Sun is the star at the center of the Solar System. It is a nearly perfect sphere of hot plasma, heated to incandescence by nuclear fusion reactions in its core, radiating the energy mainly as light and infrared radiation. It is by far the most important source of energy for life on Earth. Its diameter is about 1.39 million kilometres (864,000 miles), or 109 times that of Earth, and its mass is about 330,000 times that of Earth. It accounts for about 99.86% of the total mass of the Solar System. Roughly three quarters of the Sun's mass consists of hydrogen (~73%); the rest is mostly helium (~25%), with much smaller quantities of heavier elements, including oxygen, carbon, neon, and iron.\n\n The Sun is a G-type main-sequence star (G2V) based on its spectral class. As such, it is informally and not completely accurately referred to as a yellow dwarf (its light is closer to white than yellow). It formed approximately 4.6 billion years ago from the gravitational collapse of matter within a region of a large molecular cloud. Most of this matter gathered in the center, whereas the rest flattened into an orbiting disk that became the Solar System. The central mass became so hot and dense that it eventually initiated nuclear fusion in its core. It is thought that almost all stars form by this process.\n\nIn its core the Sun currently fuses about 600 million tons of hydrogen into helium every second, converting 4 million tons of matter into energy every second as a result. This energy, which can take between 10,000 and 170,000 years to escape the core, is the source of the Sun's light and heat. When hydrogen fusion in its core has diminished to the point at which the Sun is no longer in hydrostatic equilibrium, its core will undergo a marked increase in density and temperature while its outer layers expand, eventually transforming the Sun into a red giant. It is calculated that the Sun will become sufficiently large to engulf the current orbits of Mercury and Venus, and render Earth uninhabitable – but not for about five billion years. After this, it will shed its outer layers and become a dense type of cooling star known as a white dwarf, and no longer produce energy by fusion, but still glow and give off heat from its previous fusion.\n\nThe enormous effect of the Sun on Earth has been recognized since prehistoric times. The Sun has been regarded by some cultures as a deity. The synodic rotation of Earth and its orbit around the Sun are the basis of solar calendars, one of which is the predominant calendar in use today."))

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
                        labelColor: #colorLiteral(red: 0.7803640962, green: 0.7803606391, blue: 0.7846102715, alpha: 1),
                        details: PlanetDetails(stats: [PlanetStats.day.rawValue : "1,408 hrs",
                                                       PlanetStats.distance.rawValue : "36M mi",
                                                       PlanetStats.gravity.rawValue : "3.7 m/s2",
                                                       PlanetStats.mass.rawValue : "3.3x1023 kg",
                                                       PlanetStats.moons.rawValue : "0",
                                                       PlanetStats.order.rawValue : "1st",
                                                       PlanetStats.radius.rawValue : "1,516 mi",
                                                       PlanetStats.year.rawValue : "88 days"],
                                               details: "This planet is magnificent!"))
        
        addPlanetHelper(name: "Venus",
                        type: PlanetType.planet,
                        radius: earthRadius * 0.95,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(177)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 0.72),
                        rotationSpeed: earthDay * 243,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(25), z: K.degToRad(3.4)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 0.62,
                        labelColor: #colorLiteral(red: 0.9863802791, green: 0.8649248481, blue: 0.6479948163, alpha: 1),
                        details: PlanetDetails(stats: [PlanetStats.day.rawValue : "5,832 hrs",
                                                       PlanetStats.distance.rawValue : "67M mi",
                                                       PlanetStats.gravity.rawValue : "8.9 m/s2",
                                                       PlanetStats.mass.rawValue : "4.9x1024 kg",
                                                       PlanetStats.moons.rawValue : "0",
                                                       PlanetStats.order.rawValue : "2nd",
                                                       PlanetStats.radius.rawValue : "3,761 mi",
                                                       PlanetStats.year.rawValue : "225 days"],
                                               details: "This planet is magnificent!"))
        
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
                            labelColor: UIColor.clear,
                            details: venus.getDetails())
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
                        labelColor: #colorLiteral(red: 0.364506036, green: 0.4846500158, blue: 0.1734416783, alpha: 1),
                        details: PlanetDetails(stats: [PlanetStats.day.rawValue : "24 hrs",
                                                       PlanetStats.distance.rawValue : "93M mi",
                                                       PlanetStats.gravity.rawValue : "9.8 m/s2",
                                                       PlanetStats.mass.rawValue : "6.0x1024 kg",
                                                       PlanetStats.moons.rawValue : "1",
                                                       PlanetStats.order.rawValue : "3rd",
                                                       PlanetStats.radius.rawValue : "3,963 mi",
                                                       PlanetStats.year.rawValue : "365 days"],
                                               details: "This planet is magnificent!"))
        
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
                          labelColor: #colorLiteral(red: 0.7616128325, green: 0.7565351129, blue: 0.7696220279, alpha: 1),
                          details: PlanetDetails(stats: [PlanetStats.day.rawValue : "709 hrs",
                                                         PlanetStats.distance.rawValue : "238,900 mi",
                                                         PlanetStats.gravity.rawValue : "1.6 m/s2",
                                                         PlanetStats.mass.rawValue : "7.3x1022 kg",
                                                         PlanetStats.moons.rawValue : "--",
                                                         PlanetStats.order.rawValue : "--",
                                                         PlanetStats.radius.rawValue : "1,079 mi",
                                                         PlanetStats.year.rawValue : "27 days"],
                                                 details: "This planet is magnificent!"))

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
                        labelColor: #colorLiteral(red: 0.8029935956, green: 0.4123460054, blue: 0.2786666751, alpha: 1),
                        details: PlanetDetails(stats: [PlanetStats.day.rawValue : "25 hrs",
                                                       PlanetStats.distance.rawValue : "141M mi",
                                                       PlanetStats.gravity.rawValue : "3.7 m/s2",
                                                       PlanetStats.mass.rawValue : "6.4x1023 kg",
                                                       PlanetStats.moons.rawValue : "2",
                                                       PlanetStats.order.rawValue : "4th",
                                                       PlanetStats.radius.rawValue : "2,111 mi",
                                                       PlanetStats.year.rawValue : "686 days"],
                                               details: "This planet is magnificent!"))
        
        addPlanetHelper(name: "Jupiter",
                        type: PlanetType.planet,
                        radius: earthRadius * 11.21,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(3)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 5.2),
                        rotationSpeed: earthDay * 0.42,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(100), z: K.degToRad(1.3)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 11.87,
                        labelColor: #colorLiteral(red: 0.6988996863, green: 0.6137880087, blue: 0.5267551541, alpha: 1),
                        details: PlanetDetails(stats: [PlanetStats.day.rawValue : "10 hrs",
                                                       PlanetStats.distance.rawValue : "484M mi",
                                                       PlanetStats.gravity.rawValue : "24.8 m/s2",
                                                       PlanetStats.mass.rawValue : "2.0x1027 kg",
                                                       PlanetStats.moons.rawValue : "79",
                                                       PlanetStats.order.rawValue : "5th",
                                                       PlanetStats.radius.rawValue : "44,423 mi",
                                                       PlanetStats.year.rawValue : "4,331 days"],
                                               details: "This planet is magnificent!"))
        
        addPlanetHelper(name: "Saturn",
                        type: PlanetType.planet,
                        radius: earthRadius * 9.45,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(27)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 9.58),
                        rotationSpeed: earthDay * 0.46,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(150), z: K.degToRad(2.5)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 29.44,
                        labelColor: #colorLiteral(red: 0.6580071449, green: 0.6360285878, blue: 0.521181643, alpha: 1),
                        details: PlanetDetails(stats: [PlanetStats.day.rawValue : "11 hrs",
                                                       PlanetStats.distance.rawValue : "891M mi",
                                                       PlanetStats.gravity.rawValue : "10.4 m/s2",
                                                       PlanetStats.mass.rawValue : "5.7x1026 kg",
                                                       PlanetStats.moons.rawValue : "82",
                                                       PlanetStats.order.rawValue : "6th",
                                                       PlanetStats.radius.rawValue : "37,448 mi",
                                                       PlanetStats.year.rawValue : "10,747 days"],
                                               details: "This planet is magnificent!"))
        
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
                        labelColor: #colorLiteral(red: 0.6661632061, green: 0.8760991096, blue: 0.9032817483, alpha: 1),
                        details: PlanetDetails(stats: [PlanetStats.day.rawValue : "17 hrs",
                                                       PlanetStats.distance.rawValue : "1,784M mi",
                                                       PlanetStats.gravity.rawValue : "8.9 m/s2",
                                                       PlanetStats.mass.rawValue : "8.7x1025 kg",
                                                       PlanetStats.moons.rawValue : "27",
                                                       PlanetStats.order.rawValue : "7th",
                                                       PlanetStats.radius.rawValue : "15,882 mi",
                                                       PlanetStats.year.rawValue : "30,589 days"],
                                               details: "This planet is magnificent!"))
        
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
                        labelColor: #colorLiteral(red: 0.2331839204, green: 0.4608405828, blue: 0.8007237315, alpha: 1),
                        details: PlanetDetails(stats: [PlanetStats.day.rawValue : "16 hrs",
                                                       PlanetStats.distance.rawValue : "2,793M mi",
                                                       PlanetStats.gravity.rawValue : "11.2 m/s2",
                                                       PlanetStats.mass.rawValue : "1.0x1026 kg",
                                                       PlanetStats.moons.rawValue : "14",
                                                       PlanetStats.order.rawValue : "8th",
                                                       PlanetStats.radius.rawValue : "15,338 mi",
                                                       PlanetStats.year.rawValue : "59,800 days"],
                                               details: "This planet is magnificent!"))
        
        addPlanetHelper(name: "Pluto",
                        type: PlanetType.planet,
                        radius: earthRadius,
                        tilt: SCNVector3(x: 0, y: 0, z: K.degToRad(122)),
                        position: SCNVector3(x: 0, y: 0, z: earthDistance * 39.48),
                        rotationSpeed: earthDay * 6.38,
                        orbitalCenterTilt: SCNVector3(x: 0, y: -K.degToRad(200), z: K.degToRad(17.2)),
                        orbitalCenterPosition: sun.getNode().position,
                        orbitalCenterRotationSpeed: earthYear * 248.1,
                        labelColor: #colorLiteral(red: 0.8180410266, green: 0.6948351264, blue: 0.5951495767, alpha: 1),
                        details: PlanetDetails(stats: [PlanetStats.day.rawValue : "153 hrs",
                                                       PlanetStats.distance.rawValue : "3,670M mi",
                                                       PlanetStats.gravity.rawValue : "0.62 m/s2",
                                                       PlanetStats.mass.rawValue : "1.3x1022 kg",
                                                       PlanetStats.moons.rawValue : "5",
                                                       PlanetStats.order.rawValue : "9th",
                                                       PlanetStats.radius.rawValue : "738 mi",
                                                       PlanetStats.year.rawValue : "90,520 days"],
                                               details: "This planet is magnificent!"))
        
        showLabels(labelsOn)
    }
    
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
    private mutating func addPlanetHelper(name: String, type: PlanetType, radius: Float, tilt: SCNVector3, position: SCNVector3, rotationSpeed: TimeInterval, orbitalCenterTilt: SCNVector3, orbitalCenterPosition: SCNVector3, orbitalCenterRotationSpeed: TimeInterval?, labelColor: UIColor, details: PlanetDetails) {
        
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
                                       labelColor: labelColor,
                                       details: details))
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
    private mutating func addPlanetHelper(name: String, type: PlanetType, radius: Float, tilt: SCNVector3, position: SCNVector3, rotationSpeed: TimeInterval, labelColor: UIColor, details: PlanetDetails) {
        
        let planet = planets.getPlanet(withName: name)
        let lastTilt = planet == nil ? tilt : planet!.getNode().eulerAngles

        planets.addPlanet(Planet(name: name,
                                       type: type,
                                       radius: radius,
                                       tilt: lastTilt,
                                       position: position,
                                       rotationSpeed: rotationSpeed,
                                       labelColor: labelColor,
                                       details: details))
    }
    
    /**
     Removes all the Planet object nodes, i.e. wipes the scene view. Should be called before adding the solar system to the scene view.
     - parameter sceneView: the scene view to remove the solar system from
     */
    private func removePlanets(from sceneView: ARSCNView) {
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
    }
    
    /**
     Adds all the planet nodes and animates them to the scene view.
     - parameter sceneView: the scene view to add the solar system to
     */
    private func animatePlanets(to sceneView: ARSCNView) {
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
