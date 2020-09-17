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
    
    var planets: [Planet] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        addPlanets()
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
    
    func addPlanets() {
        
        planets.append(Planet(name: "Moon",
                              planetRadius: 0.1,
                              orbitalRadius: 2,
                              position: SCNVector3(0, 0, 0),
                              rotation: SCNVector3(0, -0.39, 0),
                              speed: 1.5))
        
        planets.append(Planet(name: "Mercury",
                              planetRadius: 0.2,
                              orbitalRadius: 4,
                              position: SCNVector3(3, 0, 0),
                              rotation: SCNVector3(0, -2, 0),
                              speed: 3))
        
        planets.append(Planet(name: "Venus",
                              planetRadius: 0.5,
                              orbitalRadius: 5,
                              position: SCNVector3(2, 0.2, 0),
                              rotation: SCNVector3(0, -1.5, 0),
                              speed: 4))
        
        planets.append(Planet(name: "Mars",
                              planetRadius: 0.35,
                              orbitalRadius: 7,
                              position: SCNVector3(1, 0.5, 0),
                              rotation: SCNVector3(0, -5, 0),
                              speed: 6))
        
        planets.append(Planet(name: "Jupiter",
                              planetRadius: 3,
                              orbitalRadius: 10,
                              position: SCNVector3(0, 0, 0),
                              rotation: SCNVector3(0, -4, 0),
                              speed: 9))

        planets.append(Planet(name: "Saturn",
                              planetRadius: 2,
                              orbitalRadius: 14,
                              position: SCNVector3(-5, 1, 0),
                              rotation: SCNVector3(0, -3, 0),
                              speed: 12))
        
        planets.append(Planet(name: "Uranus",
                              planetRadius: 1.5,
                              orbitalRadius: 20,
                              position: SCNVector3(-12, 1.5, 0),
                              rotation: SCNVector3(0, 0, 8),
                              speed: 15))
        
        planets.append(Planet(name: "Neptune",
                              planetRadius: 1.5,
                              orbitalRadius: 22,
                              position: SCNVector3(-25, 2, 0),
                              rotation: SCNVector3(0, 15, 0),
                              speed: 18))


        for planet in planets {
            planet.animate()

            sceneView.scene.rootNode.addChildNode(planet.node)
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
