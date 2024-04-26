//
//  MenuController.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/9/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

class MenuController: UIViewController {
    
    // MARK: - Properties
    
    private var pageController: UIPageViewController!
    private var menuItems: [MenuItem] = MenuItem.allCases
    private var currentIndex = UserDefaults.standard.bool(forKey: K.userDefaultsKey_LaunchedBefore) ? MenuItem.lastItemIndex : MenuItem.firstItemIndex
    private var previousIndex: Int?
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        setupPageController()
        
        UserDefaults.standard.setValue(true, forKey: K.userDefaultsKey_LaunchedBefore)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AudioManager.shared.playSound(for: "MenuScreen")
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


// MARK: - UPageViewController DataSource & Delegate

extension MenuController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else { return }
        guard let menuPageViewController = pageViewController.viewControllers?.first as? MenuPageViewController else { return }

        previousIndex = currentIndex
        currentIndex = menuPageViewController.menuItem.item.index
        
        guard let previousIndex = previousIndex, previousIndex < currentIndex else { return }

        switch currentIndex {
        case 2:
            AudioManager.shared.requestCamera()
        case 3:
            NotificationsManager.shared.requestNotifications()
        case 4:
            if #available(iOS 14, *) {
                AdMobManager.shared.requestIDFAPermission()
            } else {
                // Fallback on earlier versions
            }
        default:
            break
        }
    }
    
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
