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
    @IBOutlet weak var lowLightWarning: UIView!
    
    //Settings buttons
    let settingsButtons = SettingsView()
    let padding: CGFloat = 20

    //PlanetARium properties
    var planetarium = PlanetARium()
    var tappedPlanet: Planet?

    //Lighting properties
    var lowLightTimer: TimeInterval?
    var lowLightTimerBegin = false

    //Scaling properties
    var pinchBegan: CGFloat?
    var pinchChanged: CGFloat?
    var scaleValue: Float = 0.218 {
        willSet {
            if newValue < 0 || newValue > 1 {
                K.addHapticFeedback(withStyle: .soft)
            }
        }
        didSet {
            scaleValue = scaleValue.clamp(min: 0, max: 1)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsButtons.delegate = self
        self.view.addSubview(settingsButtons)
        NSLayoutConstraint.activate([settingsButtons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
                                     settingsButtons.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding)])
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.showsStatistics = true

        lowLightWarning.alpha = 0.0
        lowLightWarning.clipsToBounds = true
        lowLightWarning.layer.cornerRadius = 7
        
        planetarium.beginAnimation(scale: scaleValue, toNode: sceneView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(ARWorldTrackingConfiguration(), options: [])
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
    // MARK: - Gesture Interaction
    
    @IBAction func handlePinch(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            pinchBegan = sender.scale
        case .changed:
            pinchChanged = sender.scale
        case .ended:
            pinchBegan = nil
            pinchChanged = nil
        default:
            break
        }

        if let began = pinchBegan, let changed = pinchChanged {
            let diff = Float(changed - began)
            let diffScale: Float = diff < 0 ? 50 : 200

            scaleValue += diff / diffScale
            planetarium.beginAnimation(scale: scaleValue, toNode: sceneView)

            handlePlayPause(for: settingsButtons)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let location = touch.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)

        if hitResults.count > 0 {
            guard let result = hitResults.first,
                  let planetNodeName = result.node.name,
                  let tappedPlanet = planetarium.getPlanet(withName: planetNodeName) else {
                return
            }

            self.tappedPlanet = tappedPlanet
            

            
            
            
            //*******BETA****This will eventually handle a peek and pop with animation
            //make this pop up a little window with planet stats and "press harder to view more"
            planetarium.showLabels(true, forPlanet: tappedPlanet)
            
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let tappedPlanet = tappedPlanet {
            planetarium.showLabels(forPlanet: tappedPlanet)
        }
        
        self.tappedPlanet = nil
    }

    
    
    
    //**************BETA****Start to work on info graph for each planet.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, view.traitCollection.forceTouchCapability == .available,
              touch.force == touch.maximumPossibleForce,
              tappedPlanet != nil else {
            return
        }
                
        K.addHapticFeedback(withStyle: .heavy)
        planetarium.pauseAnimation()
        planetarium.showLabels(forPlanet: tappedPlanet)
        performSegue(withIdentifier: "PlanetDetailsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlanetDetailsSegue" {
            let controller = segue.destination as! PlanetDetailsController

            guard let tappedPlanet = tappedPlanet else {
                return
            }

            controller.delegate = self
            controller.planetTitle = tappedPlanet.getName()

            controller.planetStats = "Radius:\t\(tappedPlanet.getRadius())\n"
            controller.planetStats += "Axial Tilt:\t\(K.radToDeg(tappedPlanet.getTilt().z)) deg F\n"
            controller.planetStats += "1 Day:\t\(tappedPlanet.getRotationSpeed()) sec"

            controller.planetDetails = "\(tappedPlanet.getName()) is a planet in the solar system. Marvel at its grandeur..."
        }
    }
}


// MARK: - AR Scene View Delegate
    
extension PlanetARiumController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let currentFrame = sceneView.session.currentFrame else {
            print("sceneView.session.currentFrame not available?")
            return
        }
        
        guard let lightEstimate = currentFrame.lightEstimate else {
            print("No ambientIntensity checking happening today...")
            return
        }
                
        if lightEstimate.ambientIntensity < 250 {
            if !lowLightTimerBegin {
                lowLightTimerBegin = true
                lowLightTimer = time + 3
            }
            else {
                if let lowLightTimer = lowLightTimer, time > lowLightTimer {
                    DispatchQueue.main.async {
                        self.lowLightWarning.alpha = 0.6
                    }
                }
            }
        }
        else if lightEstimate.ambientIntensity > 500 {
            if lowLightTimerBegin {
                lowLightTimerBegin = false
                lowLightTimer = time + 3
            }
            else {
                if let lowLightTimer = lowLightTimer, time > lowLightTimer {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                            self.lowLightWarning.alpha = 0.0
                        }, completion: { _ in
                            self.lowLightTimer = nil
                        })
                    }
                }
            }
        }
    }


}


// MARK: - Planet Details Controller Delegate

extension PlanetARiumController: PlanetDetailsControllerDelegate {
    func didDismiss(_ controller: PlanetDetailsController) {
        //Reset label to it's current state
        if let tappedPlanet = tappedPlanet {
            planetarium.showLabels(forPlanet: tappedPlanet)
        }
        
        if !settingsButtons.isPaused {
            planetarium.resumeAnimation(to: scaleValue)
        }
        
        self.tappedPlanet = nil
    }
}


// MARK: - Settings View Delegate

extension PlanetARiumController: SettingsViewDelegate {
    func settingsView(_ controller: SettingsView, didPressLabelsButton settingsSubButton: SettingsSubButton) {
        planetarium.toggleLabels()
        planetarium.showLabels()
    }
    
    func settingsView(_ controller: SettingsView, didPressPlayPauseButton settingsSubButton: SettingsSubButton) {
        handlePlayPause(for: controller)
    }
    
    func settingsView(_ controller: SettingsView, didPressResetAnimationButton settingsSubButton: SettingsSubButton) {
        sceneView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
        planetarium.resetAnimation(withScale: scaleValue, toNode: sceneView)

        handlePlayPause(for: controller)
    }
    
    func handlePlayPause(for controller: SettingsView) {
        if controller.isPaused {
            planetarium.pauseAnimation()
        }
        else {
            planetarium.resumeAnimation(to: scaleValue)
        }
    }
}
