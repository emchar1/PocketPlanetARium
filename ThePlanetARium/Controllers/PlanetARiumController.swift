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
                              radius: 0.1,
                              position: SCNVector3(-0.5, 0, 0),
                              rotation: SCNVector3(0, 2 * Float.pi, 0),
                              speed: 2,
                              orbitalCenterPosition: SCNVector3(0, 0, -1),
                              orbitalCenterRotation: SCNVector3(0, 2 * Float.pi, 0),
                              orbitalCenterSpeed: 10))
        



        for planet in planets {
            planet.animate()

            sceneView.scene.rootNode.addChildNode(planet.orbitalCenterNode)
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
