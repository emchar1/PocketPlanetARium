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
    @IBOutlet weak var planetTitleLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var planetStatsTV: UITableView!
    @IBOutlet weak var planetDetailsLabel: UILabel!
    @IBOutlet weak var planetDetailsLandscapeLabel: UILabel!
    
    var planet: Planet?
    var delegate: PlanetDetailsControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        planetStatsTV.delegate = self
        planetStatsTV.dataSource = self

        guard let planet = planet else {
            print("No planet found!")
            return
        }

        setupPlanetView(for: planet)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.didDismiss(self)
    }
    
    func setupPlanetView(for planet: Planet) {
        //Setup labels
        planetTitleLabel.text = planet.getName()
        planetDetailsLabel.text = planet.getDetails().details
        planetDetailsLandscapeLabel.text = planet.getDetails().details

        //Planet customization
        planet.animate()
        
        if planet.getName() == "Saturn" {
            planet.addRings(imageFileName: "saturn_rings2", innerRadius: planet.getRadius() * 1.1, outerRadius: planet.getRadius() * 2.3)
        }

        if planet.getType() == .sun {
            planet.addParticles()
        }

        let scene = SCNScene()
        sceneView.delegate = self
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene = scene
        scene.rootNode.addChildNode(planet.getNode())
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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



class PlanetStatsCell: UITableViewCell {
    @IBOutlet weak var stat: UILabel!
    @IBOutlet weak var value: UILabel!
}

extension PlanetDetailsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planet?.getDetails().stats.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statCell", for: indexPath) as! PlanetStatsCell
        
        if let planet = planet, let stat = PlanetStats(rawValue: indexPath.row) {
            let statString = "\(stat):"
//            let value = planet.getDetails().stats[indexPath.row]!

            cell.stat.text = statString.capitalized
            cell.value.text = planet.getDetails().stats[indexPath.row]
//            cell.value.setAttributedTextWithSubscripts(text: value, indicesOfSubscripts: [0, 1, 2], setAsSuperscript: true)
        }

        return cell
    }
}

