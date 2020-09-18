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
        
        speedSlider.minimumValue = 0.002
        speedSlider.value = 0.002
        scaleSlider.minimumValue = 0.002 * 0.1
        
        planetarium.addPlanets(earthRadius: 0.02, earthDistance: -0.2, earthYear: 365 / 64, toNode: sceneView)
        planetarium.resumeActions(at: speedSlider.value)
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
    @IBAction func pausePressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func changeSpeedPressed(_ sender: UISlider) {
        planetarium.resumeActions(at: speedSlider.value)
    }
    
    @IBAction func changeScalePressed(_ sender: UISlider) {
//        print(sender.value)
        if sender.value >= 0 {
            planetarium.removePlanets(from: sceneView)
            planetarium.addPlanets(size: sender.value, distance: sender.value, speed: 1, toNode: sceneView)
            planetarium.resumeActions(at: speedSlider.value)
        }
    }
    
    // MARK: - Gesture Interaction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        planetarium.pauseActions()
        
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        planetarium.resumeActions(at: speedSlider.value)
    }

}


// MARK: - AR Scene View Delegate
    
extension PlanetARiumController: ARSCNViewDelegate {
    
}
