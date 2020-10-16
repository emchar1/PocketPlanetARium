//
//  MenuPageViewController.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/11/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

class MenuPageViewController: UIViewController {
    var menuBezelView: MenuBezelView!
    var menuItem: MenuItem
    
    
    init(with menuItem: MenuItem) {
        self.menuItem = menuItem

        //I don't get why this version of init needs to be called, and why it appears after page binding?
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBezelView = MenuBezelView(in: view)
        view.addSubview(menuBezelView!)
        
        menuBezelView!.addContentView(in: self, with: menuItem)
    }
        
}


// MARK: - MenuContentViewDelegate

extension MenuPageViewController: MenuContentViewDelegate {
    func menuContentView(_ controller: MenuContentView, didPresentPlanetARiumController planetARiumController: PlanetARiumController) {
        self.present(planetARiumController, animated: true, completion: nil)
    }
}
