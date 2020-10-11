//
//  MenuPageViewController.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/11/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

class MenuPageViewController: UIViewController {
    var titleLabel: UILabel?
    var page: Pages
    
    init(with page: Pages) {
        self.page = page

        //I don't get why this version of init needs to be called, and why it appears after page binding?
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        titleLabel?.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        titleLabel?.textAlignment = .center
        titleLabel?.text = page.name
        view.addSubview(titleLabel!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              view.traitCollection.forceTouchCapability == .available,
              touch.force == touch.maximumPossibleForce else {
            return
        }

        K.addHapticFeedback(withStyle: .heavy)
        

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let planetARiumController = storyboard.instantiateViewController(identifier: String(describing: PlanetARiumController.self)) as? PlanetARiumController {

            planetARiumController.modalTransitionStyle = .crossDissolve
            planetARiumController.modalPresentationStyle = .fullScreen
            present(planetARiumController, animated: true, completion: nil)
        }
    }
}
