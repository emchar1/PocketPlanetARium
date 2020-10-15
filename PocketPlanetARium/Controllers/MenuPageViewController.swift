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
    var stackView: UIStackView?
    var videoView: UIView?
    var contentLabel: UILabel?
    var goButton: UIButton?
    
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
        
        setupViews()
        
        
        
    }
    
    
    // MARK: - Setup Functions - TESTICLEES
    
    /**
     Sets up the various views... manually!
     */
    private func setupViews() {
        bezelView = UIView(frame: CGRect(x: 0, y: 0, width: Bezel.getWidth(for: view), height: Bezel.getHeight(for: view)))
        bezelView!.getBezelView(for: &bezelView!, in: view, width: bezelView!.frame.width, height: bezelView!.frame.height)
        view.addSubview(bezelView!)
        print("bezelView: w: \(bezelView!.frame.width), h: \(bezelView!.frame.height)")
        
        addVideoView(to: bezelView!, with: CGRect(x: 2 * K.padding,
                                                  y: 2 * K.padding,
                                                  width: bezelView!.frame.width - 4 * K.padding,
                                                  height: bezelView!.frame.height / 2 - 4 * K.padding))

        contentLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bezelView!.frame.width - 4 * K.padding, height: 200))
//        contentLabel!.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        contentLabel!.textAlignment = .justified
        contentLabel!.font = UIFont(name: K.fontFace, size: K.fontSizeMenu )

        contentLabel!.backgroundColor = .orange
//        contentLabel!.sizeToFit()

        contentLabel!.textColor = .white
        contentLabel!.numberOfLines = 0
        contentLabel!.text = menuItem.item.description
//        view.addSubview(contentLabel!)

        stackView = UIStackView(frame: CGRect(x: K.padding, y: K.padding, width: bezelView!.frame.width - 2 * K.padding, height: bezelView!.frame.height - 2 * K.padding))
        stackView!.distribution = .fillEqually
        stackView!.axis = .vertical
        bezelView!.addSubview(stackView!)
        stackView!.addArrangedSubview(videoView!)
        stackView!.addArrangedSubview(contentLabel!)

        if menuItem == .item5 {
            goButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            goButton!.addTarget(self, action: #selector(loadPlanetARium), for: .touchUpInside)
            goButton!.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2 + 100)
            goButton!.backgroundColor = .gray
            goButton!.layer.cornerRadius = 10
            goButton!.layer.shadowOffset = .zero
            goButton!.layer.shadowRadius = 3
            goButton!.layer.shadowColor = UIColor.black.cgColor
            goButton!.layer.shadowOpacity = 0.6
            goButton!.titleLabel?.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
            goButton!.setTitle("Go to PlanetARium", for: .normal)
//            view.addSubview(goButton!)
            stackView!.addArrangedSubview(goButton!)
        }
    }
    
    private func addVideoView(to view: UIView, with frame: CGRect) {
        videoView = UIView(frame: frame)
        videoView!.backgroundColor = .black
        videoView!.layer.shadowRadius = 4
        videoView!.layer.shadowOpacity = 0.2
        videoView!.layer.shadowOffset = .zero
        videoView!.layer.shadowColor = UIColor.white.cgColor
//        view.addSubview(videoView!)
    }
    
    
    // MARK: - PlanetARium Segue
            
    @objc func loadPlanetARium(_ sender: UIButton) {
        guard let contentLabel = contentLabel, let videoView = videoView else {
            return
        }
        
        contentLabel.alpha = 0
        contentLabel.text = "Constructing PlanetARium..."
        contentLabel.textAlignment = .center

        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn) {
            sender.frame.origin.y = self.view.frame.height + sender.frame.height
            videoView.frame.origin.y = self.view.frame.origin.y - 2 * videoView.frame.height
            contentLabel.alpha = 1.0
        } completion: { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let planetARiumController = storyboard.instantiateViewController(identifier: String(describing: PlanetARiumController.self)) as? PlanetARiumController {

                planetARiumController.modalTransitionStyle = .crossDissolve
                planetARiumController.modalPresentationStyle = .fullScreen
                self.present(planetARiumController, animated: true, completion: nil)
            }
        }
        
    }
    
    
    
}
