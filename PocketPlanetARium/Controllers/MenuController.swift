//
//  MenuController.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/9/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

class MenuController: UIViewController {
    
    private var pageController: UIPageViewController?
    private var pages: [Pages] = Pages.allCases
    private var currentIndex = 0
    
    
    override func viewDidLoad() {
        setupPageController()
    }

    private func setupPageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController?.dataSource = self
        pageController?.delegate = self
        pageController?.view.backgroundColor = UIColor(named: "BlueGrey900") ?? .gray
        pageController?.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        addChild(pageController!)
        
        view.addSubview(pageController!.view)
        
        let initialController = MenuPageViewController(with: pages[0])
        pageController?.setViewControllers([initialController], direction: .forward, animated: true, completion: nil)
        
        pageController?.didMove(toParent: self)
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
        
        let index = viewController.page.index + (forward ? 1 : -1)
        
        guard index >= 0 && index < pages.count else { return nil }
        
        return MenuPageViewController(with: pages[index])
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
}







enum Pages: CaseIterable {
    case pageZero, pageOne, pageTwo, pageThree
    
    var name: String {
        switch self {
        case .pageZero:
            return "This is page zero"
        case .pageOne:
            return "This is page one"
        case .pageTwo:
            return "This is page two"
        case .pageThree:
            return "This is page three"
        }
    }
    
    var index: Int {
        switch self {
        case .pageZero:
            return 0
        case .pageOne:
            return 1
        case .pageTwo:
            return 2
        case .pageThree:
            return 3
        }
    }
}
