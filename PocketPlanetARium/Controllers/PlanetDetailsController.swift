//
//  PlanetDetailsController.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 9/26/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit
import SceneKit

protocol PlanetDetailsControllerDelegate {
    func didDismiss(_ controller: PlanetDetailsController)
}

class PlanetDetailsController: UIViewController, SCNSceneRendererDelegate {
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var planetView: UIView!
    @IBOutlet weak var planetTitleLabel: UILabel!
    @IBOutlet weak var planetStatsLabel: UILabel!
    @IBOutlet weak var planetDetailsLabel: UILabel!
    
    var planetTitle = "Planet Title"
    var planetStats = "Planet Stats"
    var planetDetails = "Planet Details"
    var delegate: PlanetDetailsControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        planetTitleLabel.text = planetTitle
        planetStatsLabel.text = planetStats
        planetDetailsLabel.text = planetDetails

        setupPlanetView()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.didDismiss(self)
    }
    
    func setupPlanetView() {
        let scene = SCNScene()

        let planet = Planet(name: planetTitle, type: .planet, radius: 1, tilt: SCNVector3(x: 0, y: 0, z: 0), position: SCNVector3(x: 0, y: 0, z: -1), rotationSpeed: 20, labelColor: .clear)
                
        if planet.getName() == "Saturn" {
            planet.addRings(imageFileName: "saturn_rings2", innerRadius: planet.getRadius() * 1.1, outerRadius: planet.getRadius() * 2.3)
        }
        
        planet.animate()

        sceneView.delegate = self
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene = scene
        scene.rootNode.addChildNode(planet.getOrbitalCenterNode())
    }
    
    
    // MARK: - Gesture Recognizers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Empty implementation needed so that touches don't render to the underlying controller, i.e. PlanetARiumController. Ugh!!!!! I don't understand why, but this works!!!
    }

//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first,
//              view.traitCollection.forceTouchCapability == .available,
//              touch.force == touch.maximumPossibleForce else {
//            return
//        }
//
//        self.dismiss(animated: true, completion: nil)
//    }

}
