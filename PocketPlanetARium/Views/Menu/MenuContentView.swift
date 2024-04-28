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

class MenuContentView: UIView {
    var superView: MenuBezelView!
    var stackView: UIStackView!
    var playerViewController: AVPlayerViewController!
    var contentLabel: UILabel!
    var menuItem: MenuItem


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
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
                
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 2 * K.ScreenDimensions.padding),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: K.ScreenDimensions.padding),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: K.ScreenDimensions.padding),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: K.ScreenDimensions.padding)
        ])

        setupStackTop()
        setupStackBottom()
    }
    
    /**
     Helper method to set up the first view in the stack.
     */
    private func setupStackTop() {
        let view1 = UIView()
        view1.clipsToBounds = true
        stackView.addArrangedSubview(view1)
        
        guard let video = menuItem.item.video else { return }
        
        playerViewController = AVPlayerViewController()
        
        guard let videoURL = Bundle.main.path(forResource: video.name, ofType: video.type) else {
            print("Unable to find video \(video.name).\(video.type)")
            return
        }
        
        playerViewController.player = AVPlayer(url: URL(fileURLWithPath: videoURL))
        playerViewController.showsPlaybackControls = false
        playerViewController.player!.actionAtItemEnd = .none
        playerViewController.view.translatesAutoresizingMaskIntoConstraints = false

        view1.addSubview(playerViewController.view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: playerViewController.player!.currentItem)
        
        NSLayoutConstraint.activate([
            playerViewController.view.leadingAnchor.constraint(equalTo: view1.safeAreaLayoutGuide.leadingAnchor),
            view1.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: playerViewController.view.trailingAnchor),
            playerViewController.view.heightAnchor.constraint(equalToConstant: playerViewController.view.frame.height),
            playerViewController.view.centerYAnchor.constraint(equalTo: view1.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    /**
     Helper method to set up the second view in the stack.
     */
    private func setupStackBottom() {
        let view2 = UIView()
        stackView.addArrangedSubview(view2)
        
        //content label
        contentLabel = UILabel()
        contentLabel.font = UIFont(name: UIFont.fontFace, size: UIFont.fontSizeMenu)
        contentLabel.textColor = .white
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        contentLabel.text = menuItem.item.description
        contentLabel.alpha = 0.0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view2.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: view2.safeAreaLayoutGuide.topAnchor, constant: 2 * K.ScreenDimensions.padding),
            contentLabel.leadingAnchor.constraint(equalTo: view2.safeAreaLayoutGuide.leadingAnchor),
            view2.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor)
        ])
    }
    
    /**
     Helper method to allow looping of a training video when it reaches the end.
     */
    @objc private func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }
    
    
}
