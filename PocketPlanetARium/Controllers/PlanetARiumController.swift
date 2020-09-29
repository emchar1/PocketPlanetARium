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

    //PlanetARium properties
    var planetarium = PlanetARium()
    var tappedPlanet: Planet?
    var showLabels = false
    
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
            scaleSlider.value = scaleValue
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
        
        
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        scaleSlider.value = scaleValue
        scaleSlider.setThumbImage(UIImage(systemName: "hare.fill"), for: .normal)
        
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

    
    // MARK: - UI Controls
    
    @IBAction func scaleChanged(_ sender: UISlider) {
        scaleValue = sender.value
        planetarium.update(scale: scaleValue, toNode: sceneView)
    }
    
    @IBAction func toggleLabels(_ sender: UIButton) {
        showLabels = !showLabels
        planetarium.showAllLabels(showLabels)
    }
    
    @IBAction func resetPlanets(_ sender: UIButton) {
        sceneView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
        planetarium.resetPlanets(withScale: scaleValue, toNode: sceneView)
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
            scaleValue += diff / (diff < 0 ? 25 : 100)
            planetarium.update(scale: scaleValue, toNode: sceneView)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        planetarium.pauseAnimation()

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
        planetarium.setSpeed(to: scaleValue)
        
        if let tappedPlanet = tappedPlanet {
            planetarium.showLabel(showLabels, forPlanet: tappedPlanet)
        }
    }

    
    
    
    //**************BETA****Start to work on info graph for each planet.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, view.traitCollection.forceTouchCapability == .available else {
            print("3D Touch not available on this device")
            return
        }

        let location = touch.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)

        if hitResults.count > 0 {
            guard let result = hitResults.first,
                  let planetNodeName = result.node.name,
                  let tappedPlanet = planetarium.getPlanet(withName: planetNodeName),
                  touch.force == touch.maximumPossibleForce else {
                return
            }

            self.tappedPlanet = tappedPlanet
            performSegue(withIdentifier: "PlanetInfoSegue", sender: nil)
            K.addHapticFeedback(withStyle: .heavy)
        }
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
    
    
    
    

}


// MARK: - AR Scene View Delegate
    
extension PlanetARiumController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let currentFrame = sceneView.session.currentFrame,
              let lightEstimate = currentFrame.lightEstimate else {
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
                        self.lowLightWarning.alpha = 1.0
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
                        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
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
        //Resume planetarium animation
        planetarium.setSpeed(to: scaleValue)
        
        //Reset label to it's current state
        if let tappedPlanet = tappedPlanet {
            planetarium.showLabel(showLabels, forPlanet: tappedPlanet)
        }
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
