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
    
    var planetarium = PlanetARium()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        planetarium.addPlanets(earthRadius: 0.02, earthDistance: -0.2, earthDay: 3, earthYear: 15, toNode: sceneView)
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
