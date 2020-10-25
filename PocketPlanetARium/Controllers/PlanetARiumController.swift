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

    @IBOutlet weak var bezelView: UIView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var lowLightWarning: UIView!

    override var prefersStatusBarHidden: Bool { return true }
    var scaleLabel: UILabel!
    var peekView: PlanetPeekView?
    lazy var loadingLabel: UILabel = {
        let loadingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        loadingLabel.center = view.center
        loadingLabel.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        loadingLabel.textColor = .white
        loadingLabel.textAlignment = .center
        loadingLabel.text = audioManager.launchMessage
        loadingLabel.numberOfLines = 0
        return loadingLabel
    }()

    //Settings buttons
    let settingsButtons = SettingsView()

    //PlanetARium properties
    var planetarium = PlanetARium()
    var tappedPlanet: Planet?

    //Lighting properties
    var lowLightTimer: TimeInterval?
    var lowLightTimerBegin = false

    //Scaling properties
    var pinchBegan: CGFloat?
    var pinchChanged: CGFloat?
    var pinchBoundsCount = 0
    var pinchBoundsLimit = 10
    var scaleValue: Float = 0.218 {
        didSet {
            scaleValue = scaleValue.clamp(min: 0, max: 1)
        }
    }
        

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = UIColor(named: K.color500) ?? .gray
        view.addSubview(loadingLabel)


        
        
        
        
        
        
        //*****Do I like this???
        let bezelRatio: CGFloat = 612/335
        let possibleWidth = view.frame.width - 2 * K.padding
        let possibleHeight = view.frame.height - 6 * K.padding
        let width = bezelRatio < K.screenRatio ? possibleWidth : possibleHeight / bezelRatio
        let height = bezelRatio < K.screenRatio ? possibleWidth * bezelRatio : possibleHeight

        bezelView.translatesAutoresizingMaskIntoConstraints = true
        bezelView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                
        bezelView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        bezelView.backgroundColor = UIColor(named: K.color900) ?? .gray
        bezelView.layer.cornerRadius = 18
        bezelView.layer.shadowColor = UIColor.black.cgColor
        bezelView.layer.shadowOpacity = 0.3
        bezelView.layer.shadowRadius = 10

        scaleLabel = UILabel()
        scaleLabel.font = UIFont(name: K.fontFace, size: K.fontSizePeekDetails)
        scaleLabel.textColor = .white
        view.addSubview(scaleLabel)
        scaleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([scaleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: K.padding),
                                    view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scaleLabel.bottomAnchor, constant: K.padding)])

        
        
        
        
        
        
        
        settingsButtons.delegate = self
        settingsButtons.alpha = 0.0
        view.addSubview(settingsButtons)
        NSLayoutConstraint.activate([view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: settingsButtons.bottomAnchor, constant: K.padding),
                                     view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: settingsButtons.trailingAnchor, constant: K.padding)])

        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
//        sceneView.showsStatistics = true
        sceneView.translatesAutoresizingMaskIntoConstraints = true
        sceneView.frame = CGRect(x: 0, y: 0, width: bezelView.frame.width, height: bezelView.frame.height)
        sceneView.alpha = 0.0

        lowLightWarning.clipsToBounds = true
        lowLightWarning.layer.cornerRadius = 7
        lowLightWarning.alpha = 0.0
                
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
        
    override func viewDidAppear(_ animated: Bool) {
        let duration: TimeInterval = 2.0
        
        UIView.animate(withDuration: duration / 2, delay: 0.0, options: .curveEaseIn) {
            self.loadingLabel.alpha = 0.0
        } completion: { _ in
            self.loadingLabel.removeFromSuperview()
        }

        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut) {
            self.bezelView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.sceneView.frame = self.bezelView.frame
            self.sceneView.alpha = 1.0
        } completion: { _ in
            self.view.backgroundColor = .clear
            self.bezelView.backgroundColor = .clear
            
            //Enable device rotation only after the bezel finishes animating!
            (UIApplication.shared.delegate as! AppDelegate).supportedOrientations = [.allButUpsideDown]

            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.orientationDidChange(_:)),
                                                   name: UIDevice.orientationDidChangeNotification,
                                                   object: nil)
        }

        UIView.animate(withDuration: duration / 2, delay: duration / 2, options: .curveEaseInOut, animations: {
            self.settingsButtons.alpha = K.masterAlpha
        }, completion: nil)
        
        //PLAY MUSIC!!!
        audioManager.playSound(for: "PlanetARiumOpen")
        audioManager.playSound(for: "PlanetARiumMusic")
    }
    
    @objc private func orientationDidChange(_ notification: NSNotification) {
        bezelView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        sceneView.frame = bezelView.frame
    }

    
    // MARK: - Zoom Zoom
    
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
            
            if scaleValue > 0 && scaleValue < 1 {
                pinchBoundsCount = 0
                
                planetarium.beginAnimation(scale: scaleValue, toNode: sceneView)
                handlePlayPause(for: settingsButtons)
                
                if diff < 0 {
                    audioManager.playSound(for: "PinchShrink")
                }
                else {
                    audioManager.playSound(for: "PinchGrow")
                }
            }
            else {
                if pinchBoundsCount < pinchBoundsLimit {
                    K.addHapticFeedback(withStyle: .soft)
                    pinchBoundsCount += 1
                }
            }


            showScaleLabel()
        }
        
        //Prevents peekView getting stuck when trying to pinch instead.
        peekView?.removeFromSuperview()
    }
    
    private func showScaleLabel() {
        scaleLabel.alpha = K.masterAlpha
        scaleLabel.text = planetarium.getDistanceSunTo("Earth")
        
        UIView.animate(withDuration: 0.25, delay: 2.0, options: .curveEaseOut, animations: {
            self.scaleLabel.alpha = 0.0
        }, completion: nil)
    }
    
    
    // MARK: - Planet Details Peek n Pop
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, touches.count == 1 else {
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

            //Prevents touching two planets in tandem while one finger is held down.
            peekView?.removeFromSuperview()
            
            peekView = PlanetPeekView(with: tappedPlanet)
//            peekView!.delegate = self
            peekView!.show(in: view, at: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        peekView?.removeFromSuperview()
        tappedPlanet = nil
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              view.traitCollection.forceTouchCapability == .available,
              tappedPlanet != nil else {
            return
        }
        
        //Do shit while it expands...
        peekView?.expand(by: touch.force / touch.maximumPossibleForce)
        
        guard touch.force == touch.maximumPossibleForce else {
            //Max force pressed reached
            return
        }

        K.addHapticFeedback(withStyle: .heavy)

        planetarium.pauseAnimation()
        performSegue(withIdentifier: "PlanetDetailsSegue", sender: nil)
        peekView?.removeFromSuperview()

        tappedPlanet = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlanetDetailsSegue" {
            let controller = segue.destination as! PlanetDetailsController

            guard let tappedPlanet = tappedPlanet else {
                return
            }

            controller.delegate = self
            controller.planet = Planet(name: tappedPlanet.getName(),
                                       type: tappedPlanet.getType(),
                                       radius: 1,
                                       tilt: SCNVector3(x: 0, y: 0, z: 0),
                                       position: SCNVector3(x: 0, y: 0, z: -1),
                                       rotationSpeed: 20,
                                       labelColor: .clear,
                                       details: tappedPlanet.getDetails())            
        }
    }
}

extension PlanetARiumController: PlanetDetailsControllerDelegate {
    func didDismiss(_ controller: PlanetDetailsController) {
        if !settingsButtons.isPaused {
            planetarium.resumeAnimation(to: scaleValue)
        }
    }
}






//******TEST
extension PlanetARiumController: PlanetPeekViewDelegate {
    func planetPeekView(_ controller: PlanetPeekView, willPerformSegue: Bool) {
        performSegue(withIdentifier: "PlanetDetailsSegue", sender: nil)
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


// MARK: - Settings View Delegate

extension PlanetARiumController: SettingsViewDelegate {
    func settingsView(_ controller: SettingsView, didPressSoundButton settingsSubButton: SettingsSubButton?) {

    }

    func settingsView(_ controller: SettingsView, didPressLabelsButton settingsSubButton: SettingsSubButton?) {
        planetarium.toggleLabels()
        planetarium.showLabels()
    }
    
    func settingsView(_ controller: SettingsView, didPressPlayPauseButton settingsSubButton: SettingsSubButton?) {
        handlePlayPause(for: controller)
    }
    
    func settingsView(_ controller: SettingsView, didPressResetAnimationButton settingsSubButton: SettingsSubButton?) {
        sceneView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
        planetarium.resetAnimation(withScale: scaleValue, toNode: sceneView)

        handlePlayPause(for: controller)
        
        showScaleLabel()
    }
    
    private func handlePlayPause(for controller: SettingsView) {
        if controller.isPaused {
            planetarium.pauseAnimation()
        }
        else {
            planetarium.resumeAnimation(to: scaleValue)
        }
    }
}
