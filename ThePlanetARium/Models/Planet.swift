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
    private let rotationSpeed: TimeInterval

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
        node.runAction(SCNAction.rotateTo(x: 0, y: 0, z: CGFloat(tilt), duration: 0))
        
        //Set up orbital center node
        self.orbitalCenterNode = SCNNode()
        orbitalCenterNode.position = orbitalCenterPosition
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
    
    func animate() {
        let orbitalCenterRotationAction = SCNAction.rotateBy(x: 0,
                                                             y: orbitalCenterRotationSpeed == nil ? 0 : CGFloat(Planet.revolution),
                                                             z: 0,
                                                             duration: orbitalCenterRotationSpeed == nil ? 1 : orbitalCenterRotationSpeed!)
        orbitalCenterNode.runAction(SCNAction.repeatForever(orbitalCenterRotationAction))
        
        let rotationAction = SCNAction.rotateBy(x: 0,
                                                y: CGFloat(Planet.revolution),
                                                z: 0,
                                                duration: rotationSpeed)
        node.runAction(SCNAction.repeatForever(rotationAction))
        
        //This is where the magic happens
        orbitalCenterNode.addChildNode(node)
    }
    
    func getNode() -> SCNNode {
        return orbitalCenterNode
    }
    
    func getPosition() -> SCNVector3 {
        return orbitalCenterPosition
    }
        
    func addChildNode(_ node: SCNNode) {
        self.orbitalCenterNode.addChildNode(node)
    }
}
