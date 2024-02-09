//
//  PlanetDetailsController.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 9/26/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit
import SceneKit

protocol PlanetDetailsControllerDelegate: AnyObject {
    func didDismiss(_ controller: PlanetDetailsController)
}

class PlanetDetailsController: UIViewController, SCNSceneRendererDelegate {
    @IBOutlet weak var planetTitleLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var planetStatsTV: UITableView!
    @IBOutlet weak var planetDetailsLabel: UILabel!
    @IBOutlet weak var planetDetailsLandscapeLabel: UILabel!
    
    var planet: Planet?
    weak var delegate: PlanetDetailsControllerDelegate?

    
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
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        guard let planet = planet else { return }
        
        if UIDevice.current.orientation.isLandscape, UIDevice.isiPad {
            planetDetailsLabel.text = "Hold device in Portrait Mode to view more interesting facts on \(planet.getName() == "Sun" ? "the Sun" : planet.getName())!"
        }
        else {
            planetDetailsLabel.text = planet.getDetails().details
        }
    }

    override func viewWillLayoutSubviews() {
        updateTableViewContentInset()
    }
    
    private func updateTableViewContentInset() {
        let viewHeight: CGFloat = planetStatsTV.frame.height
        let tableViewContentHeight: CGFloat = planetStatsTV.contentSize.height
        let marginHeight: CGFloat = (viewHeight - tableViewContentHeight) / 2
        
        planetStatsTV.contentInset = UIEdgeInsets(top: marginHeight, left: 0, bottom: -marginHeight, right: 0)
    }
    
    private func setupPlanetView(for planet: Planet) {
        view.backgroundColor = K.color900
        
        //Setup labels
        planetTitleLabel.text = planet.getName()
        planetTitleLabel.textColor = UIColor.getRandom(redRange: 175...255, greenRange: 175...255, blueRange: 175...255)
        planetTitleLabel.shadowOffset = CGSize(width: 2.0, height: 2.0)
        planetTitleLabel.shadowColor = .darkGray
        
        planetDetailsLabel.text = planet.getDetails().details
        planetDetailsLandscapeLabel.text = planet.getDetails().details

        //Planet customization
        planet.animate()
        
        if planet.getName() == "Saturn" {
            planet.addRings(imageFileName: "saturn_rings2", innerRadius: planet.getRadius() * 1.1, outerRadius: planet.getRadius() * 2.3)
        }

        if planet.getType() == .sun {
            planet.addParticles(scenefileName: "SunParticles")
        }
        
        if planet.getName() == "Venus Surface" {
            audioManager.playSound(for: "VenusSurface", currentTime: 0.0)
        }
        else {
            audioManager.playSound(for: "DetailsOpen", currentTime: 0.0)
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
        
        if let planet = planet,
           let stat = PlanetStats(rawValue: indexPath.row),
           let value = planet.getDetails().stats[indexPath.row] {

            let statString = "\(stat):"

            cell.stat.text = statString.capitalized
            cell.value.text = value
            
            if stat == .order, value.count > 2 {
                cell.value.setAttributedTextWithSubscripts(text: value,
                                                           indicesOfSubscripts: [value.count - 1, value.count - 2],
                                                           setAsSuperscript: true)
            }

            if stat == .mass, value.count > 5 {
                cell.value.setAttributedTextWithSubscripts(text: value,
                                                           indicesOfSubscripts: [value.count - 4, value.count - 5],
                                                           setAsSuperscript: true)
            }
            
            if stat == .gravity, value.count > 1 {
                cell.value.setAttributedTextWithSubscripts(text: value,
                                                           indicesOfSubscripts: [value.count - 1],
                                                           setAsSuperscript: true)
            }

        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.isiPad ? 40 : 24
    }
}

