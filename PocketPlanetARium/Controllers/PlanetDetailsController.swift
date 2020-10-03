//
//  PlanetDetailsController.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 9/26/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

protocol PlanetDetailsControllerDelegate {
    func didDismiss(_ controller: PlanetDetailsController)
}

class PlanetDetailsController: UIViewController {
    @IBOutlet weak var planetTitleLabel: UILabel!
    @IBOutlet weak var planetStatsLabel: UILabel!
    @IBOutlet weak var planetDetailsLabel: UILabel!
    @IBOutlet weak var planetView: UIView!
    
    var planetTitle = "Planet Title"
    var planetStats = "Planet Stats"
    var planetDetails = "Planet Details"
    var delegate: PlanetDetailsControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        planetTitleLabel.text = planetTitle
        planetStatsLabel.text = planetStats
        planetDetailsLabel.text = planetDetails
    }

    override func viewDidDisappear(_ animated: Bool) {
        delegate?.didDismiss(self)
    }
        
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, view.traitCollection.forceTouchCapability == .available,
              touch.force == touch.maximumPossibleForce else {
            return
        }

        self.dismiss(animated: true, completion: {
            print("Deep pressed!")
        })
    }

}
