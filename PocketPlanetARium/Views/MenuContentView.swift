//
//  MenuContentView.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/15/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

protocol MenuContentViewDelegate {
    func menuContentView(_ controller: MenuContentView, didPresentPlanetARiumController planetARiumController: PlanetARiumController)
}

class MenuContentView: UIView {
    var superView: MenuBezelView!
    var stackView: UIStackView!
    var playerViewController: AVPlayerViewController!
    var contentLabel: UILabel!
    var goButton: UIButton!
    
    var changeMusicButton: UIButton! //temporary
    var theme = 0
    
    var menuItem: MenuItem
    
    var delegate: MenuContentViewDelegate?

        
    init(in superView: MenuBezelView, with menuItem: MenuItem) {
        self.menuItem = menuItem
        self.superView = superView
        super.init(frame: CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height))
        
        setupViews()
}

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        //stack view
        stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 2 * K.padding),
                                     stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: K.padding),
                                     safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: K.padding),
                                     safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: K.padding)])
        setupStack1()
        setupStack2()
    }
    
    /**
     Helper method to set up the first view in the stack.
     */
    private func setupStack1() {
        let view1 = UIView()
//        view1.backgroundColor = .blue
        view1.clipsToBounds = true
        stackView.addArrangedSubview(view1)
        
        guard let video = menuItem.item.video else { return }
        
        playerViewController = AVPlayerViewController()
        
        guard let videoURL = Bundle.main.path(forResource: video.name, ofType: video.type) else {
            
            print("Unable to find video \(video.name).\(video.type)")
            return
        }
        
        playerViewController.player = AVPlayer(url: URL(fileURLWithPath: videoURL))
//        playerViewController.view.backgroundColor = .systemPink
        playerViewController.showsPlaybackControls = false
        playerViewController.player!.actionAtItemEnd = .none
        view1.addSubview(playerViewController.view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: playerViewController.player!.currentItem)
        
        playerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([playerViewController.view.leadingAnchor.constraint(equalTo: view1.safeAreaLayoutGuide.leadingAnchor),
                                     view1.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: playerViewController.view.trailingAnchor),
                                     playerViewController.view.heightAnchor.constraint(equalToConstant: playerViewController.view.frame.height),
                                     playerViewController.view.centerYAnchor.constraint(equalTo: view1.safeAreaLayoutGuide.centerYAnchor)])
    }
    
    /**
     Helper method to allow looping of a training video when it reaches the end.
     */
    @objc private func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }
    
    /**
     Helper method to set up the second view in the stack.
     */
    private func setupStack2() {
        let view2 = UIView()
//        view2.backgroundColor = .green
        stackView.addArrangedSubview(view2)
        
        //content label
        contentLabel = UILabel()
//        contentLabel.backgroundColor = .orange
        contentLabel.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        contentLabel.textColor = .white
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        contentLabel.text = menuItem.item.description
        
        view2.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([contentLabel.topAnchor.constraint(equalTo: view2.safeAreaLayoutGuide.topAnchor, constant: 2 * K.padding),
                                     contentLabel.leadingAnchor.constraint(equalTo: view2.safeAreaLayoutGuide.leadingAnchor),
                                     view2.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor)])

        
        
        
        
        
        
        
        //*******FIX!!!
        if menuItem == .item4 {
            goButton = UIButton()
            goButton.backgroundColor = UIColor(rgb: 0x3498db)
            goButton.layer.cornerRadius = 30
            goButton.layer.shadowRadius = 3
            goButton.layer.shadowColor = UIColor.black.cgColor
            goButton.layer.shadowOpacity = 0.3
            goButton.titleLabel?.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
            goButton.setTitle("Launch PlanetARium", for: .normal)
            goButton.addTarget(self, action: #selector(loadPlanetARium), for: .touchUpInside)
            view2.addSubview(goButton)
            goButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([goButton.widthAnchor.constraint(equalToConstant: 225),
                                         goButton.heightAnchor.constraint(equalToConstant: 60),
                                         goButton.centerXAnchor.constraint(equalTo: view2.centerXAnchor),
                                         view2.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: goButton.bottomAnchor, constant: 4 * K.padding)])
            
            
            
            //TOTALLY A TEST!!!
            changeMusicButton = UIButton()
            changeMusicButton.backgroundColor = UIColor(rgb: 0x3498db)
            changeMusicButton.layer.cornerRadius = 30
            changeMusicButton.layer.shadowRadius = 3
            changeMusicButton.layer.shadowColor = UIColor.black.cgColor
            changeMusicButton.layer.shadowOpacity = 0.3
            changeMusicButton.titleLabel?.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
            changeMusicButton.setTitle("Change Theme", for: .normal)
            changeMusicButton.addTarget(self, action: #selector(changeMusic), for: .touchUpInside)
            view2.addSubview(changeMusicButton)
            changeMusicButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([changeMusicButton.widthAnchor.constraint(equalToConstant: 225),
                                         changeMusicButton.heightAnchor.constraint(equalToConstant: 60),
                                         changeMusicButton.centerXAnchor.constraint(equalTo: view2.centerXAnchor),
                                         view2.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: changeMusicButton.bottomAnchor, constant: 0)])
        }

    }
    
    
    // MARK: - PlanetARium Segue
            
    @objc func loadPlanetARium(_ sender: UIButton) {
        let duration: TimeInterval = 0.25
        
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "GoButton", currentTime: 0.0)
        audioManager.stopSound(for: "MenuScreen", fadeDuration: 2.0)
        
        UIView.animate(withDuration: duration, delay: duration / 2, options: .curveEaseIn, animations: {
            self.superView.label.alpha = K.masterAlpha
        }, completion: nil)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
            self.alpha = 0
        } completion: { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let planetARiumController = storyboard.instantiateViewController(identifier: String(describing: PlanetARiumController.self)) as? PlanetARiumController {

                planetARiumController.modalTransitionStyle = .crossDissolve
                planetARiumController.modalPresentationStyle = .fullScreen
                
                self.delegate?.menuContentView(self, didPresentPlanetARiumController: planetARiumController)
            }
        }
        
    }
    
    @objc func changeMusic(_ sender: UIButton) {
        K.addHapticFeedback(withStyle: .light)

        theme += 1
        if theme > 2 {
            theme = 0
        }
        switch  theme {
        case 0:
            audioManager.setTheme(.main)
            sender.setTitle("Main Theme", for: .normal)
        case 1:
            audioManager.setTheme(.mario)
            sender.setTitle("Super Mario", for: .normal)
        case 2:
            audioManager.setTheme(.starWars)
            sender.setTitle("Star Wars", for: .normal)
        default:
            print("Unknown theme")
        }
        
        audioManager.playSound(for: "GoButton", currentTime: 0.0)
        print(theme)
    }
}
