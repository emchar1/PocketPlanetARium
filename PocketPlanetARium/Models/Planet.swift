//
//  Planet.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 9/14/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import Foundation
import SceneKit
import ARKit


/**
 PlanetType enumeration. Cases include sun, moon, planet, etc.
 */
enum PlanetType {
    case sun, moon, planet, comet, asteroid, spacestation, miscellany
}


/**
 Planet structure. Houses various information pertaining to a Planet object, such as the planet's name, type, size, node information and orbital center node information.
 */
struct Planet {
    
    // MARK: - Properties
    
    private let name: String
    private let type: PlanetType
    private let radius: Float
    private var details: PlanetDetails

    //Planet properties
    private let node: SCNNode
    private let tilt: SCNVector3
    private let rotationSpeed: TimeInterval

    //Orbital center properties
    private let orbitalCenterNode: SCNNode
    private let orbitalCenterTilt: SCNVector3
    private let orbitalCenterRotationSpeed: TimeInterval?
    
    //Planet label
    private let labelNode: SCNNode
    private let labelColor: UIColor
    private let labelSize: Float

    
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
        - labelColor: color of the planet label
     */
    init(name: String, type: PlanetType, radius: Float, tilt: SCNVector3, position: SCNVector3, rotationSpeed: TimeInterval, orbitalCenterTilt: SCNVector3, orbitalCenterPosition: SCNVector3, orbitalCenterRotationSpeed: TimeInterval?, labelColor: UIColor, details: PlanetDetails) {
        self.name = name
        self.type = type
        self.radius = radius
        self.tilt = tilt
        self.rotationSpeed = rotationSpeed
        self.orbitalCenterTilt = orbitalCenterTilt
        self.orbitalCenterRotationSpeed = orbitalCenterRotationSpeed
        self.labelColor = labelColor
        self.labelSize = 0.05 * radius + 0.005 * abs(position.z)
        self.details = details

        //Set up planet
        let planet = SCNSphere(radius: CGFloat(radius))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/" + name.replacingOccurrences(of: " ", with: "_").lowercased() + ".jpg") ?? UIColor.white.withAlphaComponent(0.8)
        planet.materials = [material]
        
        //Set up planet node. Added a tilt to the y axis as well because of the stupid moon. The other alternative is to edit the moon image in GIMP/PSD.
        self.node = SCNNode()
        node.name = name
        node.position = position
        node.eulerAngles = tilt
        node.geometry = planet
        
        //Set up orbital center node
        self.orbitalCenterNode = SCNNode()
        orbitalCenterNode.position = orbitalCenterPosition
        orbitalCenterNode.eulerAngles = orbitalCenterTilt
        
        //Set up label node
        let label = SCNText(string: name, extrusionDepth: 1.0)
        let labelMaterial = SCNMaterial()
        labelMaterial.diffuse.contents = labelColor
        label.materials = [labelMaterial]
        label.font = UIFont(name: K.fontFace, size: 11)
        
        self.labelNode = SCNNode()
        labelNode.position = SCNVector3(x: position.x, y: position.y + radius, z: position.z)
        labelNode.geometry = label
        labelNode.constraints = [SCNBillboardConstraint()]
        labelNode.scale = SCNVector3(x: labelSize, y: labelSize, z: labelSize)

        //Add the planet node to orbital center node
        orbitalCenterNode.addChildNode(node)
    }
    
    /**
     Convenience init that creates a planet where its planet node equals its orbital center node.
     - parameters:
        - name: planet's name
        - radius: planet's radius in m
        - tilt: planet's axial tilt
        - position: planet's position with respect to its orbital center
        - rotationSpeed: time in seconds to complete one rotation around a planet's axis
        - labelColor: color of the planet label
     */
    init(name: String, type: PlanetType, radius: Float, tilt: SCNVector3, position: SCNVector3, rotationSpeed: TimeInterval, labelColor: UIColor, details: PlanetDetails) {
        self.init(name: name,
                  type: type,
                  radius: radius,
                  tilt: tilt,
                  position: position,
                  rotationSpeed: rotationSpeed,
                  orbitalCenterTilt: SCNVector3(x: 0, y: 0, z: 0),
                  orbitalCenterPosition: position,
                  orbitalCenterRotationSpeed: nil,
                  labelColor: labelColor,
                  details: details)
    }
    
    
    // MARK: - Animation
    
    /**
     Animates a planet object by setting its rotation and revolution (orbital rotation) actions.
     */
    func animate() {
        let orbitalCenterRotationAction = SCNAction.rotateBy(x: 0,
                                                             y: orbitalCenterRotationSpeed == nil ? 0 : CGFloat(K.period),
                                                             z: 0,
                                                             duration: orbitalCenterRotationSpeed == nil ? 1 : orbitalCenterRotationSpeed!)
        orbitalCenterNode.runAction(SCNAction.repeatForever(orbitalCenterRotationAction), forKey: "revolvePlanet")
        
        let rotationAction = SCNAction.rotateBy(x: 0,
                                                y: CGFloat(K.period),
                                                z: 0,
                                                duration: rotationSpeed)
        node.runAction(SCNAction.repeatForever(rotationAction), forKey: "rotatePlanet")
    }
    
    
    // MARK: - Getters
    
    func getName() -> String { return name }
    func getType() -> PlanetType { return type }
    func getRadius() -> Float { return radius }
    func getDetails() -> PlanetDetails { return details }
    func getNode() -> SCNNode { return node }
    func getTilt() -> SCNVector3 { return tilt }
    func getRotationSpeed() -> TimeInterval { return rotationSpeed }
    func getOrbitalCenterNode() -> SCNNode { return orbitalCenterNode }
    func getOrbitalCenterTilt() -> SCNVector3 { return orbitalCenterTilt }
    func getOrbitalCenterRotationSpeed() -> TimeInterval? { return orbitalCenterRotationSpeed }
    func getLabelNode() -> SCNNode { return labelNode }
    func getLabelColor() -> UIColor { return labelColor }

    /**
     Returns all SCNActions currently tied to the planet.
     */
    func getAllPlanetActions() -> [SCNAction] {
        var actions = [SCNAction]()

        //Get all actions for the orbital center node.
        for key in orbitalCenterNode.actionKeys {
            if let action = orbitalCenterNode.action(forKey: key) {
                actions.append(action)
            }
        }
        
        //Get all actions for the planet node.
        for key in node.actionKeys {
            if let action = node.action(forKey: key) {
                actions.append(action)
            }
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
        let orbitalPath = SCNTube(innerRadius: CGFloat(K.hypotenuse(x: node.position.x, z: node.position.z)),
                                  outerRadius: CGFloat(K.hypotenuse(x: node.position.x, z: node.position.z)),
                                  height: 0.001)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white.withAlphaComponent(0.8)
        orbitalPath.materials = [material]
        
        let orbitalPathNode = SCNNode()
        orbitalPathNode.position = SCNVector3(x: 0, y: 0, z: 0)
        orbitalPathNode.geometry = orbitalPath
        orbitalCenterNode.addChildNode(orbitalPathNode)
    }
    
    /**
     Attaches a light source to the node. Appies light source types, omni and ambient.
     - parameters:
        - omniLumens: lumens for the omni value
        - ambientLumens: lumens for the ambient value
     */
    func addLightSource(omniLumens: CGFloat, ambientLumens: CGFloat) {
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = ambientLumens
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        ambientLightNode.position = SCNVector3(x: 0, y: 0, z: 0)
        node.addChildNode(ambientLightNode)

        let omniLight = SCNLight()
        omniLight.type = .omni
        omniLight.intensity = omniLumens
        let omniLightNode = SCNNode()
        omniLightNode.light = omniLight
        omniLightNode.position = SCNVector3(x: 0, y: 0, z: 0)
        node.addChildNode(omniLightNode)
    }
    
    /**
     Adds rings to the planet.
     - parameters:
        - imageFileName: the name of the file, without the file path or extensions, e.g. if file path is art.scnassets/saturn_rings.jpg, use "saturn_rings"
        - innerRadius: innermost ring radius, in m
        - outerRadius: outermos ring radius, in m
     */
    func addRings(imageFileName: String, innerRadius: Float, outerRadius: Float) {
        let rings = SCNTube(innerRadius: CGFloat(innerRadius),
                            outerRadius: CGFloat(outerRadius),
                            height: 0.001)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/" + imageFileName.lowercased() + ".jpg") ?? UIColor.lightGray.withAlphaComponent(0.8)
        rings.materials = [material]
        
        let ringsNode = SCNNode()
        ringsNode.position = SCNVector3(x: 0, y: 0, z: 0)
        ringsNode.geometry = rings
        node.addChildNode(ringsNode)
    }
    
    /**
     Adds a cloud emission for the Earth
     - parameters:
        - imageFileName: name of the file with just the file name sans extension
        - node: the Earth node to apply the emission to
     */
    func addEarthClouds(imageFileName: String, to node: SCNNode) {
        let cloudsNode = SCNNode(geometry: node.geometry)
        cloudsNode.geometry?.firstMaterial?.emission.contents = UIImage(named: "art.scnassets/" + imageFileName.lowercased() + ".jpg") ?? UIColor.clear
        
        node.addChildNode(cloudsNode)
    }
    
    /**
     Adds a specular for the Earth, adding a spotlight on the white mask of the earth_specular.jpg, i.e. the water only
     - parameters:
        - imageFileName: name of the file with just the file name sans extension
        - node: the Earth node to apply the specular to
     */
    func addEarthSpecular(imageFileName: String, to node: SCNNode) {
        node.geometry?.firstMaterial?.specular.contents = UIImage(named: "art.scnassets/" + imageFileName.lowercased() + ".jpg") ?? UIColor.clear
    }
    
    /**
     Adds a normal for the Earth, i.e. topographic features, e.g. mountains
     - parameters:
        - imageFileName: name of the file with just the file name sans extension
        - node: the Earth node to apply the normal to
     */
    func addEarthNormal(imageFileName: String, to node: SCNNode) {
        node.geometry?.firstMaterial?.normal.contents = UIImage(named: "art.scnassets/" + imageFileName.lowercased() + ".jpg") ?? UIColor.clear
    }
    
    
    /**
     Adds a particle system. For use for the sun, mostly.
     */
    func addParticles() {
        guard let particleScene = SCNScene(named: "SunParticles.scn"),
              let particleNode = particleScene.rootNode.childNode(withName: "particles", recursively: true),
              let particleSystem = particleNode.particleSystems?.first else {
            print("Unable to load SunParticles.scn: particles")
            return
        }
        
        particleSystem.emitterShape = SCNSphere(radius: CGFloat(radius))
        particleSystem.particleSize = CGFloat(radius) / 10
        particleSystem.stretchFactor = CGFloat(radius) * 100
        
        node.addParticleSystem(particleSystem)
    }
    
    /**
     Shows or hides the planet label.
     - parameter show: show (true) or hide (false) the planet's label
     */
    mutating func showLabel(_ show: Bool) {
        if show {
            orbitalCenterNode.addChildNode(labelNode)
        }
        else {
            labelNode.removeFromParentNode()
        }
    }
    
    
}
