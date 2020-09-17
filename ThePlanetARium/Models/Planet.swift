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
    let name: String

    //Planet properties
    let node: SCNNode
    let position: SCNVector3
    let rotation: SCNVector3
    let speed: TimeInterval

    //Orbital center properties
    let orbitalCenterNode: SCNNode
    let orbitalCenterPosition: SCNVector3
    let orbitalCenterRotation: SCNVector3
    let orbitalCenterSpeed: TimeInterval
    
    static var coordinateAngles = 16
    
    
    init(name: String, radius: Float, position: SCNVector3, rotation: SCNVector3, speed: TimeInterval, orbitalCenterPosition: SCNVector3, orbitalCenterRotation: SCNVector3, orbitalCenterSpeed: TimeInterval) {
        
        self.name = name
        self.position = position
        self.rotation = rotation
        self.speed = speed
        self.orbitalCenterPosition = orbitalCenterPosition
        self.orbitalCenterRotation = orbitalCenterRotation
        self.orbitalCenterSpeed = orbitalCenterSpeed
        
        //Set up planet
        let planet = SCNSphere(radius: CGFloat(radius))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/" + name.lowercased() + ".jpg") ?? UIColor.white.withAlphaComponent(0.8)
        planet.materials = [material]
        
        //Set up planet node
        self.node = SCNNode()
        node.position = position
        node.geometry = planet
        
        //Set up orbital center node
        self.orbitalCenterNode = SCNNode()
        orbitalCenterNode.position = orbitalCenterPosition
    }
    
    func animate() {
        let orbitalCenterRotationAction = SCNAction.rotateBy(x: CGFloat(orbitalCenterRotation.x),
                                                     y: CGFloat(orbitalCenterRotation.y),
                                                     z: CGFloat(orbitalCenterRotation.z),
                                                     duration: orbitalCenterSpeed)
        orbitalCenterNode.runAction(SCNAction.repeatForever(orbitalCenterRotationAction))
        
        let rotationAction = SCNAction.rotateBy(x: CGFloat(rotation.x),
                                                y: CGFloat(rotation.y),
                                                z: CGFloat(rotation.z),
                                                duration: speed)
        node.runAction(SCNAction.repeatForever(rotationAction))
        
        //This is where the magic happens
        orbitalCenterNode.addChildNode(node)
    }
}
