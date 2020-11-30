//
//  MenuController.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/9/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit
import AVFoundation

//Need to add this as a global var to be shared across all files!
var audioManager = AudioManager(with: .main)

class MenuController: UIViewController {
    
    private var pageController: UIPageViewController!
    private var menuItems: [MenuItem] = MenuItem.allCases
    private var currentIndex = UserDefaults.standard.bool(forKey: K.userDefaultsKey_LaunchedBefore) ? MenuItem.lastItemIndex : MenuItem.firstItemIndex
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    
    override func viewDidLoad() {
        requestCamera()
        setupPageController()
        
        UserDefaults.standard.setValue(true, forKey: K.userDefaultsKey_LaunchedBefore)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        audioManager.playSound(for: "MenuScreen")
    }

    private func setupPageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        pageController.view.backgroundColor = K.color500
        pageController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        //Makes this ad hoc pageController a child of MenuController.
        addChild(pageController)
        
        //Also need to add the child's view as a subview of this view.
        view.addSubview(pageController.view)
        
        let initialController = MenuPageViewController(with: menuItems[currentIndex])
        pageController.setViewControllers([initialController], direction: .forward, animated: true, completion: nil)
        
        pageController.didMove(toParent: self)
    }
}


extension MenuController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return scrollPage(for: viewController, forward: false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return scrollPage(for: viewController, forward: true)
    }
    
    private func scrollPage(for viewController: UIViewController, forward: Bool) -> UIViewController? {
        guard let viewController = viewController as? MenuPageViewController else { return nil }
        
        let index = viewController.menuItem.item.index + (forward ? 1 : -1)
        
        guard index >= 0 && index < menuItems.count else { return nil }
        
        return MenuPageViewController(with: menuItems[index])
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return menuItems.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
}


extension MenuController {
    func requestCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            return
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    return
                }
            }
        case .denied: // The user has previously denied access.
            return
        case .restricted: // The user can't grant access due to restrictions.
            return
        default:
            return
        }
    }
}
