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
    @IBOutlet weak var scaleSlider: UISlider!
    
    var planetarium = PlanetARium()

    //Test for handlePinch
    var scale = 0.5 {
        didSet {
            scale = min(max(scale, 0), 1)

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scaleSlider.value = 0.5

        sceneView.delegate = self
//        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        planetarium.addPlanets(scale: scaleSlider.value, toNode: sceneView)
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
    
    
    // MARK: - UI Controls
    
    @IBAction func scaleChanged(_ sender: UISlider) {
        planetarium.addPlanets(scale: sender.value, toNode: sceneView)
    }
    
    
    // MARK: - Gesture Interaction
    
    @IBAction func handlePinch(_ sender: UIPinchGestureRecognizer) {
        print(sender.scale)
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        planetarium.pauseActions()
//
//        guard let touch = touches.first else {
//            return
//        }
//
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
//    }

}


// MARK: - AR Scene View Delegate
    
extension PlanetARiumController: ARSCNViewDelegate {
    
}
