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
    @IBOutlet weak var lowLightWarning: UIView!
    
    var lowLightTimer: TimeInterval = 0
    var lowLightTimerBegin = false
    var showLabels = false
    var planetarium = PlanetARium()
    
    //Pinch to zoom properties
    var pinchBegan: CGFloat?
    var pinchChanged: CGFloat?
    var scaleValue: Float = 0.218 {
        willSet {
            if newValue < 0 || newValue > 1 {
                //Add some haptic feedback! This only applies to pinch to zoom, for now.
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        }
        didSet {
            scaleValue = scaleValue.clamp(min: 0, max: 1)
            scaleSlider.value = scaleValue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scaleSlider.value = scaleValue
        scaleSlider.setThumbImage(UIImage(systemName: "hare.fill"), for: .normal)
        
        lowLightWarning.isHidden = true
        lowLightWarning.clipsToBounds = true
        lowLightWarning.layer.cornerRadius = 7
        
        planetarium.update(scale: scaleValue, toNode: sceneView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func setupSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = false
    }
    
    
    // MARK: - UI Controls
    
    @IBAction func scaleChanged(_ sender: UISlider) {
        scaleValue = sender.value
        planetarium.update(scale: scaleValue, toNode: sceneView)
    }
    
    @IBAction func toggleLabels(_ sender: UIButton) {
        showLabels = !showLabels
        planetarium.showLabels(showLabels)
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
            print(diff)
            scaleValue += diff / (diff < 0 ? 25 : 100)
            planetarium.update(scale: scaleValue, toNode: sceneView)
        }

        
//        print(sender.velocity)
//        scaleValue += Float(sender.velocity) / (sender.velocity < 0 ? 50 : 500)
//        planetarium.update(scale: scaleValue, toNode: sceneView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        planetarium.pauseAnimation()

        //Start to work on info graph for each planet.
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            guard let result = hitResults.first, let planetNodeName = result.node.name else {
                return
            }
            

            
            
            
//            //******TEST******Trying to figure out popup View
//            let planetDetailsController = PlanetDetailsController()
//            planetDetailsController.view.bounds = CGRect(x: 0, y: 0, width: view.bounds.width - 24, height: 2 * view.bounds.height / 3)
//            planetDetailsController.view.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
//            addChild(planetDetailsController)
//
////            view.addSubviewWithSlideUpAnimation(planetDetailsController.view, duration: 0.5, options: .curveEaseInOut)
//
//            planetDetailsController.view.transform = view.transform.scaledBy(x: 0.01, y: 0.01)
//
//            view.addSubview(planetDetailsController.view)
//
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
//                planetDetailsController.view.transform = CGAffineTransform.identity
//            }, completion: nil)
//
            
//            planetDetailsController.didMove(toParent: self)
            
            
            
            
            
            print(planetNodeName)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        planetarium.setSpeed(to: scaleValue)
    }

}


// MARK: - AR Scene View Delegate
    
extension PlanetARiumController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let currentFrame = sceneView.session.currentFrame,
              let lightEstimate = currentFrame.lightEstimate else {
            return
        }
        
        if lightEstimate.ambientIntensity < 250 {
            if !lowLightTimerBegin {
                lowLightTimerBegin = true
                lowLightTimer = time + 3
            }
        
            if time > lowLightTimer {
                DispatchQueue.main.async {
                    self.lowLightWarning.isHidden = false
                }
            }
        }
        
        if lightEstimate.ambientIntensity > 500 {
            if lowLightTimerBegin {
                lowLightTimerBegin = false
                lowLightTimer = time + 3
            }
            
            lowLightTimerBegin = false

            if time > lowLightTimer {
                DispatchQueue.main.async {
                    self.lowLightWarning.isHidden = true
                }
            }
        }
    }
    
    
}





//******TEST******
extension UIView {
    func addSubviewWithSlideUpAnimation(_ view: UIView, duration: TimeInterval, options: UIView.AnimationOptions) {
        view.transform = view.transform.scaledBy(x: 0.01, y: 0.01)
        
        addSubview(view)
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            view.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
