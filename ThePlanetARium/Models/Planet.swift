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
    let node: SCNNode
    let orbitalRadius: Float
    let position: SCNVector3
    let rotation: SCNVector3
    let speed: TimeInterval
    static var coordinateAngles = 16
    
    init(name: String, planetRadius: Float, orbitalRadius: Float, position: SCNVector3, rotation: SCNVector3, speed: TimeInterval) {
        self.name = name
        self.orbitalRadius = orbitalRadius
        self.position = position
        self.rotation = rotation
        self.speed = speed

        let sphere = SCNSphere(radius: CGFloat(planetRadius))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/" + name.lowercased() + ".jpg") ?? UIColor.white.withAlphaComponent(0.8)
        sphere.materials = [material]
        
        //Include orbitalRadius in the z-coordinate, which will place the initial position at the far end of the orbital path, i.e. in front of the camera.
        self.node = SCNNode()
        node.position = SCNVector3(position.x, position.y, position.z - orbitalRadius)
        node.geometry = sphere
    }
    
    func animate() {
        let rotationAction = SCNAction.rotateBy(x: CGFloat(rotation.x), y: CGFloat(rotation.y), z: CGFloat(rotation.z), duration: speed)
        var groupActions = [SCNAction]()

        print("***** \(name), orbital radius: \(orbitalRadius), initial position: (\(position.x), \(position.z)), initial node position: (\(node.position.x), \(node.position.z))")

        for angle in 1...Planet.coordinateAngles {
            let angleRad = Float(2 * angle) * (.pi / Float(Planet.coordinateAngles))
            let revolutionAction = SCNAction.move(to: SCNVector3(position.x + orbitalRadius * sin(angleRad),
                                                                 position.y,
                                                                 position.z - orbitalRadius * cos(angleRad)),
                                                  duration: speed)
            
            groupActions.append(SCNAction.group([rotationAction, revolutionAction]))

            debugAnimation(angleRad: angleRad)
        }

        let moveSequence = SCNAction.sequence(groupActions)
        
        node.runAction(SCNAction.repeatForever(moveSequence))
    }
    
    private func debugAnimation(angleRad: Float) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        let angle = formatter.string(from: NSNumber(value: angleRad * 180 / .pi)) ?? "nil"
        let sinx = formatter.string(from: NSNumber(value: sin(angleRad))) ?? "nil"
        let cosz = formatter.string(from: NSNumber(value: cos(angleRad))) ?? "nil"
        let posx = formatter.string(from: NSNumber(value: position.x + orbitalRadius * sin(angleRad))) ?? "nil"
        let posz = formatter.string(from: NSNumber(value: position.z + orbitalRadius * cos(angleRad))) ?? "nil"

        print("angle: \(angle), sin.x: \(sinx), cos.z: \(cosz), pos.x: \(posx), pos.z: \(posz)")
    }
}
