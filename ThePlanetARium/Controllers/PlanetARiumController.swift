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
    var pauseAnimation = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scaleSlider.value = 0.2

        sceneView.delegate = self
        sceneView.showsStatistics = true
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
//        planetarium.scalePlanets(to: sender.value)
    }
    
    
    // MARK: - Gesture Interaction
    
    @IBAction func handlePinch(_ sender: UIPinchGestureRecognizer) {
        planetarium.addPlanets(scale: Float(sender.scale / 6), toNode: sceneView)
        print(sender.scale)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pauseAnimation = !pauseAnimation
        
        if pauseAnimation {
            planetarium.pauseAnimation()
        }
        else {
            planetarium.setSpeed(to: scaleSlider.value)
        }
    }

}


// MARK: - AR Scene View Delegate
    
extension PlanetARiumController: ARSCNViewDelegate {
    
}
