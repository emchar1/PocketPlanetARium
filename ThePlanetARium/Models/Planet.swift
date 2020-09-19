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

    //Planet properties
    private let node: SCNNode
    private let rotationSpeed: TimeInterval

    //Orbital center properties
    private let orbitalCenterNode: SCNNode
    private let orbitalCenterRotationSpeed: TimeInterval?
    
    static let coordinateAngles = 16
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
        - orbitalCenterPosition: position of a planet's orbital center in space
        - orbitalCenterRotationSpeed: time it takes planet to complete one revolution around its orbital center.
     */
    init(name: String, radius: Float, tilt: Float, position: SCNVector3, rotationSpeed: TimeInterval, orbitalCenterPosition: SCNVector3, orbitalCenterRotationSpeed: TimeInterval?) {
        
        self.name = name
        self.rotationSpeed = rotationSpeed
        self.orbitalCenterRotationSpeed = orbitalCenterRotationSpeed
        
        //Set up planet
        let planet = SCNSphere(radius: CGFloat(radius))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/" + name.lowercased() + ".jpg") ?? UIColor.white.withAlphaComponent(0.8)
        planet.materials = [material]
        
        //Set up planet node
        self.node = SCNNode()
        node.position = position
        node.geometry = planet
        node.runAction(SCNAction.rotateTo(x: 0, y: 0, z: CGFloat(tilt), duration: 0), forKey: "tiltPlanet")
        
        //Set up orbital center node
        self.orbitalCenterNode = SCNNode()
        orbitalCenterNode.position = orbitalCenterPosition
        
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
    init(name: String, radius: Float, tilt: Float, position: SCNVector3, rotationSpeed: TimeInterval) {
        self.init(name: name,
                  radius: radius,
                  tilt: tilt,
                  position: position,
                  rotationSpeed: rotationSpeed,
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
            - orbitalCenterPosition: position of a planet's orbital center in space
            - orbitalCenterRotationSpeed: time it takes planet to complete one revolution around its orbital center.
     */
    init(name: String, radius: Float, tilt: Float, aPosition: (angle: Float, hypotenuse: Float), rotationSpeed: TimeInterval, orbitalCenterPosition: SCNVector3, orbitalCenterRotationSpeed: TimeInterval?) {
        self.init(name: name,
                  radius: radius,
                  tilt: tilt,
                  position: SCNVector3(x: -sin(aPosition.angle) * aPosition.hypotenuse, y: 0, z: cos(aPosition.angle) * aPosition.hypotenuse),
                  rotationSpeed: rotationSpeed,
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
    
    
    // MARK: - Planet Customization Functions
        
    /**
     Adds another planet's orbital center node to the current planet's orbital center node. This is how you get the moon to revolve around the Earth, for example.
     - parameter planet: Planet object input
     */
    func addSatellite(_ planet: Planet) {
        self.orbitalCenterNode.addChildNode(planet.getOrbitalCenterNode())
    }
    
    //TEST*******
    func addRings(_ saturn: Planet) {
        
    }

    
    // MARK: - Get Properties
    
    /**
     Returns the node of the planet.
     */
    func getnode() -> SCNNode {
        return node
    }
    
    /**
     Returns the node of the planet's orbital center.
     */
    func getOrbitalCenterNode() -> SCNNode {
        return orbitalCenterNode
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
}
