//
//  PlanetARiumController.swift
//  ThePlanetARium
//
//  Created by Eddie Char on 9/14/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PlanetARiumController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    var planets: [String : Planet] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        addPlanets(sunCenter: SCNVector3(0, 0, -0.1), earthRadius: 0.8, earthDistance: -5, earthDay: 6, earthYear: 1200, orbitOffset: 777)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    
    // MARK: - Scene Setup
    
    func addPlanets(sunCenter: SCNVector3, earthRadius: Float, earthDistance: Float, earthDay: TimeInterval, earthYear: TimeInterval, orbitOffset: Float) {
        func toRadians(_ degrees: Float) -> Float {
            return Float.pi / (180 / degrees)
        }

        planets["Sun"] = Planet(name: "Sun",
                                radius: 0.008,
                                tilt: 0,
                                position: sunCenter,
                                rotationSpeed: earthDay * 27)
        
        planets["Mercury"] = Planet(name: "Mercury",
                                    radius: earthRadius * 0.38,
                                    tilt: 0,
                                    position: SCNVector3(0, 0, earthDistance * 0.39),
                                    rotationSpeed: earthDay * 58,
                                    orbitalCenterPosition: sunCenter,
                                    orbitalCenterRotationSpeed: earthYear * 0.24)
        
        planets["Venus"] = Planet(name: "Venus",
                                  radius: earthRadius * 0.95,
                                  tilt: toRadians(177),
                                  position: SCNVector3(0, 0, earthDistance * 0.72),
                                  rotationSpeed: earthDay * 243,
                                  orbitalCenterPosition: sunCenter,
                                  orbitalCenterRotationSpeed: earthYear * 0.62)

        planets["Earth"] = Planet(name: "Earth",
                                  radius: earthRadius,
                                  tilt: toRadians(23),
                                  position: SCNVector3(0, 0, earthDistance),
                                  rotationSpeed: earthDay,
                                  orbitalCenterPosition: sunCenter,
                                  orbitalCenterRotationSpeed: earthYear)

//        planets["Moon"] = Planet(name: "Moon",
//                                 radius: 0.05,
//                                 tilt: 0,
//                                 position: SCNVector3(0, 0, -5.5),
//                                 rotationSpeed: 8,
//                                 orbitalCenterPosition: SCNVector3(0, 0, -5),
//                                 orbitalCenterRotationSpeed: 5)
        
        planets["Mars"] = Planet(name: "Mars",
                                 radius: earthRadius * 0.53,
                                 tilt: toRadians(25),
                                 position: SCNVector3(0, 0, earthDistance * 1.52),
                                 rotationSpeed: earthDay * 1.04,
                                 orbitalCenterPosition: sunCenter,
                                 orbitalCenterRotationSpeed: earthYear * 1.88)

        planets["Jupiter"] = Planet(name: "Jupiter",
                                    radius: earthRadius * 11.21,
                                    tilt: toRadians(3),
                                    position: SCNVector3(0, 0, earthDistance * 5.2),
                                    rotationSpeed: earthDay * 0.42,
                                    orbitalCenterPosition: sunCenter,
                                    orbitalCenterRotationSpeed: earthYear * 11.87)

        planets["Saturn"] = Planet(name: "Saturn",
                                   radius: earthRadius * 9.45,
                                   tilt: toRadians(27),
                                   position: SCNVector3(0, 0, earthDistance * 9.58),
                                   rotationSpeed: earthDay * 0.46,
                                   orbitalCenterPosition: sunCenter,
                                   orbitalCenterRotationSpeed: earthYear * 29.44)

        planets["Uranus"] = Planet(name: "Uranus",
                                   radius: earthRadius * 4.01,
                                   tilt: toRadians(98),
                                   position: SCNVector3(0, 0, earthDistance * 19.18),
                                   rotationSpeed: earthDay * 0.71,
                                   orbitalCenterPosition: sunCenter,
                                   orbitalCenterRotationSpeed: earthYear * 83.81)

        planets["Neptune"] = Planet(name: "Neptune",
                                    radius: earthRadius * 3.88,
                                    tilt: toRadians(23),
                                    position: SCNVector3(0, 0, earthDistance * 30.03),
                                    rotationSpeed: earthDay * 0.67,
                                    orbitalCenterPosition: sunCenter,
                                    orbitalCenterRotationSpeed: earthYear * 163.84)
        
        
        sceneView.scene.rootNode.addChildNode(planets["Sun"]!.getNode())

        for (name, planet) in planets {
            planet.animate()
            
            if name != "Sun" {
                planets["Sun"]?.addChildNode(planet.getNode())
            }
        }
 
    }
    
    
    // MARK: - Gesture Interaction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else {
//            return
//        }
//
//        let touchLocation = touch.location(in: sceneView)
//        let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
//
//        for planet in planets {
//            if let hitResult = hitTestResults.first {
//                let planetMin = planet.node.boundingBox.min
//                let planetMax = planet.node.boundingBox.max
//                let touchPoint = hitResult.worldTransform.columns.3
//
//                if (touchPoint.x < planetMax.x && touchPoint.x > planetMin.x) && (touchPoint.y < planetMax.y && touchPoint.y > planetMin.y) {
//                    planet.node.removeFromParentNode()
//                    break
//                }
//            }
//        }
    }

}


// MARK: - AR Scene View Delegate
    
extension PlanetARiumController: ARSCNViewDelegate {
    
}
