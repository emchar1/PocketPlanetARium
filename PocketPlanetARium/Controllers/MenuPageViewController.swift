//
//  MenuPageViewController.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/11/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

class MenuPageViewController: UIViewController {
    var bezelView: UIView?
    var titleLabel: UILabel?
    var button: UIButton?
    var page: Pages
    let padding: CGFloat = 20
    
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
        
        bezelView = UIView(frame: CGRect(x: 0, y: 0, width: Bezel.getWidth(for: view), height: Bezel.getHeight(for: view)))
        bezelView!.getBezelView(for: &bezelView!, in: view, width: bezelView!.frame.width, height: bezelView!.frame.height)
        view.addSubview(bezelView!)

        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        titleLabel!.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        titleLabel!.textAlignment = .center
        titleLabel!.font = UIFont(name: "Futura", size: 17.0)
        titleLabel!.textColor = .white
        titleLabel!.text = page.name
        view.addSubview(titleLabel!)
        
        if page == .pageFour {
            button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            button!.addTarget(self, action: #selector(loadPlanetARium), for: .touchUpInside)
            button!.addTarget(self, action: #selector(highlightButton), for: .touchDown)
            button!.addTarget(self, action: #selector(unhighlightButton), for: .touchDragExit)
            button!.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2 + 100)
            button!.backgroundColor = .gray
            button!.layer.cornerRadius = 10
            button!.layer.shadowOffset = .zero
            button!.layer.shadowRadius = 3
            button!.layer.shadowColor = UIColor.black.cgColor
            button!.layer.shadowOpacity = 0.6
            button!.titleLabel?.font = UIFont(name: "Futura", size: 20.0)
            button!.setTitle("Go to PlanetARium", for: .normal)
            view.addSubview(button!)
        }
    }
    
    @objc func highlightButton(_ sender: UIButton) {
        sender.backgroundColor = .darkGray
        sender.layer.shadowOpacity = 0.0
    }
    
    @objc func unhighlightButton(_ sender: UIButton) {
        sender.backgroundColor = .gray
        sender.layer.shadowOpacity = 0.6
    }
        
    @objc func loadPlanetARium(_ sender: UIButton) {
        sender.backgroundColor = .darkGray
        sender.layer.shadowOpacity = 0.0

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let planetARiumController = storyboard.instantiateViewController(identifier: String(describing: PlanetARiumController.self)) as? PlanetARiumController {

            planetARiumController.modalTransitionStyle = .crossDissolve
            planetARiumController.modalPresentationStyle = .fullScreen
            present(planetARiumController, animated: true, completion: nil)
        }
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first,
//              view.traitCollection.forceTouchCapability == .available,
//              touch.force == touch.maximumPossibleForce else {
//            return
//        }
//
//        K.addHapticFeedback(withStyle: .heavy)
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let planetARiumController = storyboard.instantiateViewController(identifier: String(describing: PlanetARiumController.self)) as? PlanetARiumController {
//
//            planetARiumController.modalTransitionStyle = .crossDissolve
//            planetARiumController.modalPresentationStyle = .fullScreen
//            present(planetARiumController, animated: true, completion: nil)
//        }
//    }
}
