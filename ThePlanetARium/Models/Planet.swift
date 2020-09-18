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
    private let position: SCNVector3
    private var rotationSpeed: TimeInterval

    //Orbital center properties
    private let orbitalCenterNode: SCNNode
    private let orbitalCenterPosition: SCNVector3
    private let orbitalCenterRotationSpeed: TimeInterval?
    
    static var coordinateAngles = 16
    static let revolution = 2 * Float.pi
    
    
    init(name: String, radius: Float, tilt: Float, position: SCNVector3, rotationSpeed: TimeInterval, orbitalCenterPosition: SCNVector3, orbitalCenterRotationSpeed: TimeInterval?) {
        
        self.name = name
        self.position = position
        self.rotationSpeed = rotationSpeed
        self.orbitalCenterPosition = orbitalCenterPosition
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
    
    init(name: String, radius: Float, tilt: Float, position: SCNVector3, rotationSpeed: TimeInterval) {
        self.init(name: name,
                  radius: radius,
                  tilt: tilt,
                  position: position,
                  rotationSpeed: rotationSpeed,
                  orbitalCenterPosition: position,
                  orbitalCenterRotationSpeed: nil)
    }
    
    init(name: String, radius: Float, tilt: Float, positionAngle: (angle: Float, multiplier: Float), rotationSpeed: TimeInterval, orbitalCenterPosition: SCNVector3, orbitalCenterRotationSpeed: TimeInterval?) {
        self.init(name: name,
                  radius: radius,
                  tilt: tilt,
                  position: SCNVector3(x: -sin(positionAngle.angle) * positionAngle.multiplier, y: 0, z: cos(positionAngle.angle) * positionAngle.multiplier),
                  rotationSpeed: rotationSpeed,
                  orbitalCenterPosition: orbitalCenterPosition,
                  orbitalCenterRotationSpeed: orbitalCenterRotationSpeed)
    }
    
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
    
    /**
     Return the node of the planet's orbital center.
     */
    func getNode() -> SCNNode {
        return orbitalCenterNode
    }
    
    /**
     Returns the SCNVector3 value of the orbital center's position.
     */
    func getPosition() -> SCNVector3 {
        return orbitalCenterPosition
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
        
//    mutating func setRotationSpeed(to rotationSpeed: TimeInterval) {
//        self.rotationSpeed = rotationSpeed
//    }
        
    /**
     Adds another planet's orbital center node to the current planet's node. This is how you get the moon to revolve around the Earth, for example.
     */
    func addChildNode(_ planet: Planet) {
        self.orbitalCenterNode.addChildNode(planet.getNode())
    }
}
