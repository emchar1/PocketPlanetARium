//
//  PlanetARiumController.swift
//  PocketPlanetARium
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
    
    //Pinch to zoom properties
    var pinchBegan: CGFloat?
    var pinchChanged: CGFloat?
    var scaleValue: Float = 0.218 {
        didSet {
            scaleValue = scaleValue.clamp(min: 0, max: 1)
            scaleSlider.value = scaleValue
            print(scaleValue)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scaleSlider.value = scaleValue
        scaleSlider.setThumbImage(UIImage(systemName: "hare.fill"), for: .normal)

        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = false
        
        planetarium.update(scale: scaleValue, toNode: sceneView)        
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
        scaleValue = sender.value
        
        planetarium.update(scale: scaleValue, toNode: sceneView)
//        planetarium.scalePlanets(to: sender.value)
    }
    
    
    // MARK: - Gesture Interaction
    
    @IBAction func handlePinch(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            pinchBegan = sender.scale
        case .changed:
            pinchChanged = sender.scale
        case .ended:
            //reset values
            pinchBegan = nil
            pinchChanged = nil
        default:
            break
        }
        
        if let began = pinchBegan, let changed = pinchChanged {
            let diff = Float(changed - began)
            scaleValue += diff / (diff < 0 ? 100 : 200)
            planetarium.update(scale: scaleValue, toNode: sceneView)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        planetarium.pauseAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        planetarium.setSpeed(to: scaleValue)
    }

}


// MARK: - AR Scene View Delegate
    
extension PlanetARiumController: ARSCNViewDelegate {

}
