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
        
        menuBezelView = MenuBezelView(in: view, showSubLabel: menuItem == MenuItem.lastItem ? false : true)
        view.addSubview(menuBezelView!)
        menuBezelView!.addContentView(in: self, with: menuItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //I should probably use protocol delegation instead of this travesty, but I'm lazy and exhausted :P
        if let menuContentView = menuBezelView.menuContentView as? MenuContentViewSingle {
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                menuContentView.contentLabel.alpha = 1.0
            }, completion: nil)
        }

        if let menuContentView = menuBezelView.menuContentView as? MenuContentView {
            menuContentView.playerViewController?.player?.play()

            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                menuContentView.contentLabel.alpha = 1.0
            }, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let menuContentView = menuBezelView.menuContentView as? MenuContentViewLaunch {
            //Only play whoosh when label is out of frame.
            if menuContentView.titleTopLabel.frame.origin.x < 0 {
                AudioManager.shared.playSound(for: "MenuTitle", currentTime: 0.0)
            }
            
            menuContentView.titleTopLabel.alpha = 1.0
            menuContentView.titleBottomLabel.alpha = 1.0
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                menuContentView.titleTopLabel.frame.origin.x = 0
                menuContentView.titleBottomLabel.frame.origin.x = 0
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
                menuContentView.trulyImmersiveLabel.alpha = 1.0
            }, completion: nil)
        }
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        //I should probably use protocol delegation instead of this travesty, but I'm lazy and exhausted :P
        if let menuContentView = menuBezelView.menuContentView as? MenuContentView {
            menuContentView.playerViewController?.player?.pause()
            menuContentView.playerViewController?.player?.seek(to: .zero)
            menuContentView.contentLabel.alpha = 0.0
        }
        
        if let menuContentView = menuBezelView.menuContentView as? MenuContentViewSingle {
            menuContentView.contentLabel.alpha = 0.0
        }
    }
}


// MARK: - MenuContentViewLaunchDelegate

extension MenuPageViewController: MenuContentViewLaunchDelegate {
    func menuContentViewLaunch(_ controller: MenuContentViewLaunch, didPresentPlanetARiumController planetARiumController: PlanetARiumController) {
        self.present(planetARiumController, animated: true, completion: nil)
    }
    
    func menuContentViewLaunch(_ controller: MenuContentViewLaunch, didPresentViewChangeWith alert: UIAlertController, handler: (() -> Void)?) {
        present(alert, animated: true, completion: handler)
        
        //IMPORTANT!! Required for iPad, else program crashes
        if let popOver = alert.popoverPresentationController {
            let deviceFrame: CGRect = view.superview?.frame ?? .zero
            
            popOver.sourceView = self.view
            popOver.sourceRect = CGRect(origin: CGPoint(x: deviceFrame.size.width / 2, y: deviceFrame.size.height / 2 + 60), size: .zero)
        }
    }
}
