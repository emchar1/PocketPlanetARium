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
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var scaleSlider: UISlider!
    
    var planetarium = PlanetARium()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        scaleSlider.minimumValue = 0.123
        scaleSlider.maximumValue = 1
        speedSlider.minimumValue = 0.123
        speedSlider.maximumValue = 1
        scaleSlider.value = 0.2
        speedSlider.value = scaleSlider.maximumValue - scaleSlider.value + scaleSlider.minimumValue

        planetarium.addPlanets(scale: scaleSlider.value, toNode: sceneView)
//        planetarium.resumeActions(for: speedSlider.value)
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
    
    @IBAction func pausePressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func speedChanged(_ sender: UISlider) {
        planetarium.resumeActions(for: speedSlider.value)
    }
    
    @IBAction func scaleChanged(_ sender: UISlider) {
        if sender.value >= 0 {
            speedSlider.value = scaleSlider.maximumValue - scaleSlider.value + scaleSlider.minimumValue
            
            //I don't like this. Is there a better way???
            planetarium.removePlanets(from: sceneView)
            planetarium.addPlanets(scale: sender.value, toNode: sceneView)
            planetarium.resumeActions(for: speedSlider.value)
        }
    }
    
    
    // MARK: - Gesture Interaction
    
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
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        planetarium.resumeActions(at: speedSlider.value)
//    }

}


// MARK: - AR Scene View Delegate
    
extension PlanetARiumController: ARSCNViewDelegate {
    
}
