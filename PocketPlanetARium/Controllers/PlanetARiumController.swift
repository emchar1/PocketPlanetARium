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
    @IBOutlet weak var resetAnimationButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var showLabelsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    var showSettings = false
    
    //PlanetARium properties
    var planetarium = PlanetARium()
    var tappedPlanet: Planet?
    var showLabels = false
    var isPaused = false
    
    //Lighting properties
    var lowLightTimer: TimeInterval?
    var lowLightTimerBegin = false

    //Pinch to zoom properties
    var pinchBegan: CGFloat?
    var pinchChanged: CGFloat?
    var scaleValue: Float = 0.218 {
        willSet {
            if newValue < 0 || newValue > 1 {
                K.addHapticFeedback(withStyle: .light)
            }
        }
        didSet {
            scaleValue = scaleValue.clamp(min: 0, max: 1)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //******BETA Testing peek and pop interaction
        //I didn't like this one
//        let interaction = UIContextMenuInteraction(delegate: self)
//        sceneView.addInteraction(interaction)
        
        //This one causes it to crash after 3 - 5 peeks
//        registerForPreviewing(with: self, sourceView: view)

        
        
        
        setupButton(&resetAnimationButton, with: UIColor(rgb: 0x667C89))
        setupButton(&playPauseButton, with: UIColor(rgb: 0x93A4AD))
        setupButton(&showLabelsButton, with: UIColor(rgb: 0xD0D8DC))
        setupButton(&settingsButton)
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
                
        lowLightWarning.alpha = 0.0
        lowLightWarning.clipsToBounds = true
        lowLightWarning.layer.cornerRadius = 7
        
        planetarium.update(scale: scaleValue, toNode: sceneView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(ARWorldTrackingConfiguration(), options: [])
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    
    // MARK: - Settings Buttons
    
    @IBAction func resetPlanets(_ sender: UIButton) {
        K.addHapticFeedback(withStyle: .light)

        sceneView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
        planetarium.resetPlanets(withScale: scaleValue, toNode: sceneView)

        handlePause(isPaused)
    }
    
    @IBAction func pausePressed(_ sender: UIButton) {
        K.addHapticFeedback(withStyle: .light)

        isPaused = !isPaused
        handlePause(isPaused)
    }
    
    @IBAction func toggleLabels(_ sender: UIButton) {
        K.addHapticFeedback(withStyle: .light)

        showLabels = !showLabels
        planetarium.showAllLabels(showLabels)
    }
    
    @IBAction func settingsPressed(_ sender: UIButton) {
        showSettings = !showSettings
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            sender.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: nil)
        UIView.animate(withDuration: 0.25, delay: 0.25, options: .curveEaseOut, animations: {
            sender.transform = CGAffineTransform(rotationAngle: .pi * 2)
        }, completion: { _ in
            K.addHapticFeedback(withStyle: .medium)
        })
        
        if showSettings {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.showLabelsButton.isHidden = false
                self.showLabelsButton.center.y -= self.settingsButton.frame.size.height + 10
                self.showLabelsButton.alpha = 0.8

                self.playPauseButton.isHidden = false
                self.playPauseButton.center.y -= (self.settingsButton.frame.size.height + 10) * 2
                self.playPauseButton.alpha = 0.8

                self.resetAnimationButton.isHidden = false
                self.resetAnimationButton.center.y -= (self.settingsButton.frame.size.height + 10) * 3
                self.resetAnimationButton.alpha = 0.8
            } completion: { _ in
                if self.isPaused {
                    self.playPauseButton.blink()
                }
            }
        }
        else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.showLabelsButton.center = self.settingsButton.center
                self.showLabelsButton.alpha = 0.0
                
                self.playPauseButton.center = self.settingsButton.center
                self.playPauseButton.alpha = 0.0

                self.resetAnimationButton.center = self.settingsButton.center
                self.resetAnimationButton.alpha = 0.0
            } completion: { _ in
                self.showLabelsButton.isHidden = true
                self.playPauseButton.isHidden = true
                self.resetAnimationButton.isHidden = true
            }
        }
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

            scaleValue += diff / (diff < 0 ? 50 : 200)
            planetarium.update(scale: scaleValue, toNode: sceneView)

            handlePause(isPaused)
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
            planetarium.showLabel(true, forPlanet: tappedPlanet)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let tappedPlanet = tappedPlanet {
            planetarium.showLabel(showLabels, forPlanet: tappedPlanet)
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
                
        performSegue(withIdentifier: "PlanetInfoSegue", sender: nil)
        K.addHapticFeedback(withStyle: .heavy)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlanetInfoSegue" {
            let controller = segue.destination as! PlanetDetailsController
            
            guard let tappedPlanet = tappedPlanet else {
                return
            }
            
            controller.delegate = self
            controller.planetTitle = tappedPlanet.getName()
            
            controller.planetStats = "Radius:\t\(tappedPlanet.getRadius())\n"
            controller.planetStats += "Axial Tilt:\t\(K.radToDeg(tappedPlanet.getTilt().z)) deg F\n"
            controller.planetStats += "1 Day:\t\(tappedPlanet.getRotationSpeed()) sec"
            
            controller.planetDetails = "Jupiter is the largest planet in the solar system."
        }
    }
    
    
    // MARK: - Helper Functions
    
    /**
     Sets up the settings buttons
     - parameters:
        - button: the button being passed in and returned as well
        - color: color of the round background image
     - If color is set to nil, then the button is a sub-setting button that gets revealed when the original settings button is pressed.
     */
    private func setupButton(_ button: inout UIButton, with color: UIColor? = nil) {
        button.tintColor = .white
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        button.alpha = 0.8
        button.center.x = view.bounds.width - 70
        button.center.y = view.bounds.height - 100
//        button.center.x = UIDevice.current.orientation.isPortrait ? view.bounds.width - 70 : view.bounds.height - 70
//        button.center.y = UIDevice.current.orientation.isPortrait ? view.bounds.height - 100 : view.bounds.width - 100
        button.frame.size = CGSize(width: 60, height: 60)

        //i.e. button is a sub-setting button
        if color != nil {
            button.backgroundColor = color
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
            button.alpha = 0.0
            button.isHidden = true
        }
    }
    
    /**
     Handles animation of the PlanetARium.
     - parameter isPaused: pauses animation if true
     - Not sure if a parameter is needed or if I can access global isPaused variable???
     */
    private func handlePause(_ isPaused: Bool) {
        if isPaused {
            planetarium.pauseAnimation()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            playPauseButton.blink()
        }
        else {
            planetarium.setSpeed(to: scaleValue)
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            playPauseButton.stopBlink()
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
        }//end else if lightEstimate.ambientIntensity > 500
        
    }
    
    
}


// MARK: - Planet Details Controller Delegate

extension PlanetARiumController: PlanetDetailsControllerDelegate {
    func didDismiss(_ controller: PlanetDetailsController) {
        //Resume planetarium animation THIS MAY NOT BE NEEDED ANYMORE??
//        handlePause(isPaused)
            
        //Reset label to it's current state
        if let tappedPlanet = tappedPlanet {
            planetarium.showLabel(showLabels, forPlanet: tappedPlanet)
        }
        
        self.tappedPlanet = nil
    }
}













//********GAMMA*******Peek and Pop NOTHING HERE WORKS THE WAY I LIKE IT!
extension PlanetARiumController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let hitResults = sceneView.hitTest(location, options: nil)

        if hitResults.count > 0 {
            guard let result = hitResults.first,
                  let planetNodeName = result.node.name,
                  let tappedPlanet = planetarium.getPlanet(withName: planetNodeName) else {
                return nil
            }

            self.tappedPlanet = tappedPlanet
//            performSegue(withIdentifier: "PlanetInfoSegue", sender: nil)
//            K.addHapticFeedback(withStyle: .heavy)
            
            guard let viewController = storyboard?.instantiateViewController(identifier: "PlanetDetails") as? PlanetDetailsController else {
                preconditionFailure("Expected a PlanetDetailsController")
            }
            
            viewController.planetTitle = tappedPlanet.getName()
            
            return viewController
            

        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

extension PlanetARiumController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        let hitResults = sceneView.hitTest(location, options: nil)

        if hitResults.count > 0 {
            guard let result = hitResults.first,
                  let planetNodeName = result.node.name,
                  let tappedPlanet = planetarium.getPlanet(withName: planetNodeName) else {
                return nil
            }

            self.tappedPlanet = tappedPlanet
//            performSegue(withIdentifier: "PlanetInfoSegue", sender: nil)
//            K.addHapticFeedback(withStyle: .heavy)
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
                return self.makeContextMenu(withPlanet: tappedPlanet)
            }

        }
        
        return nil
       
    }
    
    func makeContextMenu(withPlanet planet: Planet) -> UIMenu {

        let rename = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { action in
            // Show rename UI
        }
        
        // Here we specify the "destructive" attribute to show that it’s destructive in nature
        let delete = UIAction(title: "Delete Photo", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            // Delete this photo 😢
        }
        
        // The "title" will show up as an action for opening this menu
        let edit = UIMenu(title: "Edit...", children: [rename, delete])
        
        let share = UIAction(title: planet.getName(), image: UIImage(systemName: "square.and.arrow.up")) { action in
            // Show system share sheet
        }
        
        // Create our menu with both the edit menu and the share action
        return UIMenu(title: "Main Menu", children: [edit, share])
    }
    
    
}





////******TEST******
//extension UIView {
//    func addSubviewWithSlideUpAnimation(_ view: UIView, duration: TimeInterval, options: UIView.AnimationOptions) {
//        view.transform = view.transform.scaledBy(x: 0.01, y: 0.01)
//
//        addSubview(view)
//
//        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
//            view.transform = CGAffineTransform.identity
//        }, completion: nil)
//    }
//}
