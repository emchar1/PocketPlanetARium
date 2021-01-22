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
    var lowLightActivated = false

    //Scaling properties
    var pinchBegan: CGFloat?
    var pinchChanged: CGFloat?
    var pinchBoundsCount = 0
    var pinchBoundsLimit = 10
    let scaleValueMin: Float = 0
    let scaleValueMax: Float = 1
    var scaleValue: Float = 0.218 {
        didSet {
            scaleValue = scaleValue.clamp(min: scaleValueMin, max: scaleValueMax)
        }
    }
    
    //Hint pop ups
    var hintDevice: HintView!
    var hintSettings: HintView!
    var hintPlanetTap: HintView!
    var hintPinchZoom: HintView!
            

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = K.color500
        view.addSubview(loadingLabel)

        let bezelRatio: CGFloat = 612/335
        let possibleWidth = view.frame.width - 2 * K.padding
        let possibleHeight = view.frame.height - 6 * K.padding
        let width = bezelRatio < K.screenRatio ? possibleWidth : possibleHeight / bezelRatio
        let height = bezelRatio < K.screenRatio ? possibleWidth * bezelRatio : possibleHeight

        bezelView.translatesAutoresizingMaskIntoConstraints = true
        bezelView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                
        bezelView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        bezelView.backgroundColor = K.color900
        bezelView.layer.cornerRadius = 18
        bezelView.layer.shadowColor = UIColor.black.cgColor
        bezelView.layer.shadowOpacity = 0.3
        bezelView.layer.shadowRadius = 10

        scaleLabel = UILabel()
        scaleLabel.font = UIFont(name: K.fontFace, size: K.fontSizePeekDetails)
        scaleLabel.textColor = .white
        view.addSubview(scaleLabel)
        scaleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([scaleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                                         constant: K.padding),
                                     view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scaleLabel.bottomAnchor,
                                                                                      constant: K.padding)])
        
        settingsButtons.delegate = self
        settingsButtons.alpha = 0.0
        view.addSubview(settingsButtons)
        NSLayoutConstraint.activate([view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: settingsButtons.bottomAnchor, constant: K.padding),
                                     view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: settingsButtons.trailingAnchor, constant: K.padding)])

        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.translatesAutoresizingMaskIntoConstraints = true
        sceneView.frame = CGRect(x: 0, y: 0, width: bezelView.frame.width, height: bezelView.frame.height)
        sceneView.alpha = 0.0

        lowLightWarning.clipsToBounds = true
        lowLightWarning.layer.cornerRadius = 7
        lowLightWarning.alpha = 0.0
        
        planetarium.beginAnimation(scale: scaleValue, toNode: sceneView)
        
        
        
        
        //GESTURES
        
        //Long press to replace 3D press (for iPad that doesn't have 3D touch technology)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPressGesture.minimumPressDuration = 1.5
        sceneView.addGestureRecognizer(longPressGesture)
        
        let popPlanetDetailsGesture = PopPlanetDetailsGesture(target: self, action: nil)
        popPlanetDetailsGesture.popDelegate = self
        sceneView.addGestureRecognizer(popPlanetDetailsGesture)
        
        let tapPlanetGesture = TapPlanetGesture(target: self, action: nil)
        tapPlanetGesture.tapDelegate = self
        sceneView.addGestureRecognizer(tapPlanetGesture)

//        let summonPlanetGesture = UIPanGestureRecognizer(target: self, action: #selector(planetSummoned))
//        sceneView.addGestureRecognizer(summonPlanetGesture)
        
        //View for the impending doom on earth
//        let sceneView2 = SCNView(frame: CGRect(x: 20, y: 80, width: 100, height: 100))
//        let urth = SCNSphere(radius: 0.5)
//        urth.materials.first?.diffuse.contents = UIImage(named: "art.scnassets/earth.jpg")
//        let urthNode = SCNNode(geometry: urth)
//        urthNode.position = SCNVector3(x: 0, y: 0, z: -1.0)
//
//        let scene = SCNScene()
//        sceneView2.allowsCameraControl = true
//        sceneView2.autoenablesDefaultLighting = true
//        sceneView2.backgroundColor = .clear
//        sceneView2.scene = scene
//        scene.rootNode.addChildNode(urthNode)
//        view.addSubview(sceneView2)
        
        
        
        
        //HINTS
        
        hintDevice = HintView(in: sceneView, ofSize: CGSize(width: 175, height: 250), anchorToBottomRight: false)
        hintSettings = HintView(in: sceneView, ofSize: CGSize(width: 150, height: 150), anchorToBottomRight: true)
        hintPlanetTap = HintView(in: sceneView, ofSize: CGSize(width: 150, height: 200), anchorToBottomRight: false)
        hintPinchZoom = HintView(in: sceneView, ofSize: CGSize(width: 150, height: 200), anchorToBottomRight: false)
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
        
        
        //Hints
        if !UserDefaults.standard.bool(forKey: K.userDefaultsKey_HintsAreOff) {
            hintDevice.showHint(text: "Move your device around until you can see the planets. Try physically walking up to a planet!",
                                image: "hintDevice",
                                forDuration: 7.0,
                                withDelay: 4.0,
                                iconAnimationType: .device)

            hintSettings.showHint(text: "Tap on the gear to open Settings.",
                                  image: "hintArrow",
                                  forDuration: 5.0,
                                  withDelay: 16.0,
                                  iconAnimationType: .settings)
                        
            hintPinchZoom.showHint(text: "Pinch the screen with two fingers to resize the PlanetARium.",
                                   image: "hintPinch",
                                   forDuration: 5.0,
                                   withDelay: 31.0,
                                   iconAnimationType: .pinchZoom)
            
            hintPlanetTap.showHint(text: "Tap and hold on a planet to view more details.",
                                   image: "hintTap",
                                   forDuration: 5.0,
                                   withDelay: 43.0,
                                   iconAnimationType: .planetTap)
        }
    }
    
    @objc private func orientationDidChange(_ notification: NSNotification) {
        bezelView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        sceneView.frame = bezelView.frame
    }

    
    // MARK: - Gesture Handling
    
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
            
            if scaleValue > scaleValueMin && scaleValue < scaleValueMax {
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
        let distanceToEarth = planetarium.getDistanceSunTo("Earth", scaleValue: scaleValue)
        
        scaleLabel.alpha = K.masterAlpha
        scaleLabel.text = distanceToEarth.text
        scaleLabel.textColor = .white//distanceToEarth.textColor
        
        UIView.animate(withDuration: 0.25, delay: 2.0, options: .curveEaseOut, animations: {
            self.scaleLabel.alpha = 0.0
        }, completion: nil)
    }
    
    
    
    
    
    
//    /**
//     Summons a planet
//     */
//    @objc func planetSummoned(_ recognizer: UIPanGestureRecognizer) {
//        peekView?.removeFromSuperview()
//
//        if recognizer.state == .ended {
////            print("It Ended. are you appy?")
//            tappedPlanet = nil
//
//            summonBegan = nil
//            summonChanged = nil
//        }
//
//        guard let tappedPlanet = tappedPlanet,
//              tappedPlanet.getType() != .sun,
//              !isSummoning/*,
//              planetarium.sweetSpotReached(for: scaleValue)*/ else {
//            print("isSummoning: \(isSummoning)")
//            return
//        }
//
//        isSummoning = true
//
//        switch recognizer.state {
//        case .began:
//            break
////            print("Began")
////            summonBegan = recognizer.location(in: sceneView)
//        case .changed:
//            print("Changed - translation: \(recognizer.translation(in: sceneView)), velocity: \(recognizer.velocity(in: sceneView))")
////            summonChanged = recognizer.location(in: sceneView)
//        case .ended:
////            print("Ended")
//            break
//        default:
//            break
//        }
//
//        print("We are summoning....")
//        planetarium.summonPlanet(tappedPlanet, in: sceneView) { [self] in
//            isSummoning = false
//            print("Summning done (isSummoning == false)")
//        }
//    }
    
    
    
    
    
    
    
    
    /**
     Alternative to 3D touch (for iPad users)
     */
    @objc func longPress(_ recognizer: UILongPressGestureRecognizer) {
        guard tappedPlanet != nil else { return }
        
        K.addHapticFeedback(withStyle: .heavy)
        
        seguePlanetDetails()
    }
    
    private func seguePlanetDetails() {
        planetarium.pauseAnimation()
        performSegue(withIdentifier: "PlanetDetailsSegue", sender: nil)
        peekView?.removeFromSuperview()
        
        tappedPlanet = nil
        
        AppStoreReviewManager.requestReviewIfAppropriate()
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
                if let lowLightTimer = lowLightTimer, time > lowLightTimer, !lowLightActivated {
                    lowLightActivated = true
                    DispatchQueue.main.async {
                        self.lowLightWarning.alpha = 0.6
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                            self.lowLightWarning.alpha = 0.0
                        }, completion: nil)
                    }
                }
            }
        }
        else if lightEstimate.ambientIntensity > 500 {
            lowLightTimer = nil
            lowLightTimerBegin = false
            lowLightActivated = false
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
//        isSummoning = false

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


// MARK: - Gesture Handling Delegates

extension PlanetARiumController: TapPlanetGestureDelegate {
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touch = touches.first, touches.count == 1 else {
            return
        }

        let location = touch.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)

        guard hitResults.count > 0,
              let result = hitResults.first,
              let planetNodeName = result.node.name,
              let tappedPlanet = planetarium.getPlanet(withName: planetNodeName) else {
            return
        }
        
        self.tappedPlanet = tappedPlanet
                
        //Prevents touching two planets in tandem while one finger is held down.
        peekView?.removeFromSuperview()
        
        peekView = PlanetPeekView(with: tappedPlanet)
//        peekView!.delegate = self
        peekView!.show(in: view, at: location)
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        peekView?.unshow()
        tappedPlanet = nil
    }
}

extension PlanetARiumController: PopPlanetDetailsGestureDelegate {
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        guard tappedPlanet != nil,
              view.traitCollection.forceTouchCapability == .available,
              let touch = touches.first,
              touch.force == touch.maximumPossibleForce else {
            return
        }
        
        K.addHapticFeedback(withStyle: .heavy)
        
        seguePlanetDetails()
    }
    
    
}
