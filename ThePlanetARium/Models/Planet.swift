//
//  Planet.swift
//  ThePlanetARium
//
//  Created by Eddie Char on 9/14/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import Foundation
import SceneKit

struct Planet {
    private let name: String
    private let radius: Float

    //Planet properties
    private let node: SCNNode
    private let tilt: SCNVector3
    private let rotationSpeed: TimeInterval

    //Orbital center properties
    private let orbitalCenterNode: SCNNode
    private let orbitalCenterTilt: SCNVector3
    private let orbitalCenterRotationSpeed: TimeInterval?
    
    static let coordinateAngles = 16    //A relic of past programming tribulations.
    static let revolution = 2 * Float.pi
    
    
    // MARK: - Initializers
    
    /**
     Creates a planet object and sets up the planet sphere, materials, node and orbital center nodes.
     - parameters:
        - name: planet's name
        - radius: planet's radius in m
        - tilt: planet's axial tilt
        - position: planet's position with respect to its orbital center
        - rotationSpeed: time in seconds to complete one rotation around a planet's axis
        - orbitalCenterTilt: planet's orbital center's axial tilt
        - orbitalCenterPosition: position of a planet's orbital center in space
        - orbitalCenterRotationSpeed: time it takes planet to complete one revolution around its orbital center.
     */
    init(name: String, radius: Float, tilt: SCNVector3, position: SCNVector3, rotationSpeed: TimeInterval, orbitalCenterTilt: SCNVector3, orbitalCenterPosition: SCNVector3, orbitalCenterRotationSpeed: TimeInterval?) {
        
        self.name = name
        self.radius = radius
        self.tilt = tilt
        self.rotationSpeed = rotationSpeed
        self.orbitalCenterTilt = orbitalCenterTilt
        self.orbitalCenterRotationSpeed = orbitalCenterRotationSpeed
        
        //Set up planet
        let planet = SCNSphere(radius: CGFloat(radius))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/" + name.lowercased() + ".jpg") ?? UIColor.white.withAlphaComponent(0.8)
        planet.materials = [material]
        
        //Set up planet node. Added a tilt to the y axis as well because of the stupid moon. The other alternative is to edit the moon image in GIMP/PSD.
        self.node = SCNNode()
        node.position = position
        node.geometry = planet
        node.runAction(SCNAction.rotateTo(x: CGFloat(tilt.x), y: CGFloat(tilt.y), z: CGFloat(tilt.z), duration: 0), forKey: "tiltPlanet")
        
        //Set up orbital center node
        self.orbitalCenterNode = SCNNode()
        orbitalCenterNode.position = orbitalCenterPosition
        orbitalCenterNode.runAction(SCNAction.rotateTo(x: CGFloat(orbitalCenterTilt.x), y: CGFloat(orbitalCenterTilt.y), z: CGFloat(orbitalCenterTilt.z), duration: 0))
        
        //Add the planet node to orbital center node
        orbitalCenterNode.addChildNode(node)
    }
    
    
    
    /**
     Convenience init that creates a planet where its node = orbital center.
     - parameters:
         - name: planet's name
         - radius: planet's radius in m
         - tilt: planet's axial tilt
         - position: planet's position with respect to its orbital center
         - rotationSpeed: time in seconds to complete one rotation around a planet's axis
     */
    init(name: String, radius: Float, tilt: SCNVector3, position: SCNVector3, rotationSpeed: TimeInterval) {
        self.init(name: name,
                  radius: radius,
                  tilt: tilt,
                  position: position,
                  rotationSpeed: rotationSpeed,
                  orbitalCenterTilt: SCNVector3(x: 0, y: 0, z: 0),
                  orbitalCenterPosition: position,
                  orbitalCenterRotationSpeed: nil)
    }
    
    /**
     Convenience init that sets the planet's position based on angular distance and hypotenuse.
     - parameters:
            - name: planet's name
            - radius: planet's radius in m
            - tilt: planet's axial tilt
            - aPosition: planet's position determined by angular distance and hypotenuse
            - rotationSpeed: time in seconds to complete one rotation around a planet's axis
            - orbitalCenterTilt: planet's orbital center's axial tilt
            - orbitalCenterPosition: position of a planet's orbital center in space
            - orbitalCenterRotationSpeed: time it takes planet to complete one revolution around its orbital center.
     */
    init(name: String, radius: Float, tilt: SCNVector3, aPosition: (angle: Float, hypotenuse: Float), rotationSpeed: TimeInterval, orbitalCenterTilt: SCNVector3, orbitalCenterPosition: SCNVector3, orbitalCenterRotationSpeed: TimeInterval?) {
        self.init(name: name,
                  radius: radius,
                  tilt: tilt,
                  position: SCNVector3(x: -sin(aPosition.angle) * aPosition.hypotenuse, y: 0, z: cos(aPosition.angle) * aPosition.hypotenuse),
                  rotationSpeed: rotationSpeed,
                  orbitalCenterTilt: orbitalCenterTilt,
                  orbitalCenterPosition: orbitalCenterPosition,
                  orbitalCenterRotationSpeed: orbitalCenterRotationSpeed)
    }
    
    
    // MARK: - Animation
    
    /**
     Animates a planet object by setting its rotation and revolution (orbital rotation) actions.
     */
    func animate() {
        let orbitalCenterRotationAction = SCNAction.rotateBy(x: 0,
                                                             y: orbitalCenterRotationSpeed == nil ? 0 : CGFloat(Planet.revolution),
                                                             z: 0,
                                                             duration: orbitalCenterRotationSpeed == nil ? 1 : orbitalCenterRotationSpeed!)
        orbitalCenterNode.runAction(SCNAction.repeatForever(orbitalCenterRotationAction), forKey: "revolvePlanet")
        
        let rotationAction = SCNAction.rotateBy(x: 0,
                                                y: CGFloat(Planet.revolution),
                                                z: 0,
                                                duration: rotationSpeed)
        node.runAction(SCNAction.repeatForever(rotationAction), forKey: "rotatePlanet")
    }
    
    
    // MARK: - Get Property Functions
    
    /**
     Returns the planet's name.
     */
    func getName() -> String {
        return name
    }
    
    /**
     Returns the planet's radius.
     */
    func getRadius() -> Float {
        return radius
    }
    
    /**
     Returns the node of the planet.
     */
    func getNode() -> SCNNode {
        return node
    }
    
    /**
     Returns the axial tilt of the planet.
     */
    func getTilt() -> SCNVector3 {
        return tilt
    }

    /**
     Returns the planet's orbital center rotation speed.
     */
    func getRotationSpeed() -> TimeInterval {
        return rotationSpeed
    }

    /**
     Returns the node of the planet's orbital center.
     */
    func getOrbitalCenterNode() -> SCNNode {
        return orbitalCenterNode
    }
    
    /**
     Returns the axial tilt of the planet's orbital center.
     */
    func getOrbitalCenterTilt() -> SCNVector3 {
        return orbitalCenterTilt
    }
    
    /**
     Returns the planet's orbital center rotation speed.
     */
    func getOrbitalCenterRotationSpeed() -> TimeInterval? {
        return orbitalCenterRotationSpeed
    }

    /**
     Returns all SCNActions currently tied to the planet.
     */
    func getAllPlanetActions() -> [SCNAction] {
        var actions = [SCNAction]()

        //Get all actions for the orbital center node.
        for key in orbitalCenterNode.actionKeys {
            actions.append(orbitalCenterNode.action(forKey: key)!)
        }
        
        //Get all actions for the planet node.
        for key in node.actionKeys {
            actions.append(node.action(forKey: key)!)
        }

        return actions
    }
    
    
    // MARK: - Planet Customization Functions
        
    /**
     Adds another planet's orbital center node to the current planet's orbital center node. This is how you get the moon to revolve around the Earth, for example.
     - parameter planet: Planet object input
     */
    func addSatellite(_ planet: Planet) {
        self.orbitalCenterNode.addChildNode(planet.getOrbitalCenterNode())
    }
    
    /**
     Adds the orbital path of the planet.
     */
    func addOrbitPath() {
        let orbitalPath = SCNTorus(ringRadius: CGFloat(sqrt(pow(node.position.x, 2) + pow(node.position.z, 2))), pipeRadius: 0.001)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        orbitalPath.materials = [material]
        
        let orbitNode = SCNNode()
        orbitNode.position = SCNVector3(x: 0, y: 0, z: 0)
        orbitNode.geometry = orbitalPath
        orbitalCenterNode.addChildNode(orbitNode)
    }
    
    //TEST**********
    func addRings(name: String, innerRadius: Float, outerRadius: Float) {
        let rings = SCNTube(innerRadius: CGFloat(innerRadius), outerRadius: CGFloat(outerRadius), height: 0.001)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/" + name.lowercased() + ".jpg")
        rings.materials = [material]
        
        let ringNode = SCNNode()
        ringNode.position = SCNVector3(x: 0, y: 0, z: 0)
        ringNode.geometry = rings
        node.addChildNode(ringNode)
    }
}


