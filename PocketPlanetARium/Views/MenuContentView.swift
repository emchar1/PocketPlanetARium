//
//  MenuContentView.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/15/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

protocol MenuContentViewDelegate {
    func menuContentView(_ controller: MenuContentView, didPresentPlanetARiumController planetARiumController: PlanetARiumController)
}

class MenuContentView: UIView {
    var superView: MenuBezelView!
    var stackView: UIStackView!
    var videoView: UIImageView!
    var contentLabel: UILabel!
    var goButton: UIButton!
    
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
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: K.padding),
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
        view1.backgroundColor = .blue
        stackView.addArrangedSubview(view1)
        
        //image view
        videoView = UIImageView()
        videoView.backgroundColor = .black

        view1.addSubview(videoView)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([videoView.topAnchor.constraint(equalTo: view1.safeAreaLayoutGuide.topAnchor, constant: K.padding),
                                     videoView.leadingAnchor.constraint(equalTo: view1.safeAreaLayoutGuide.leadingAnchor),
                                     view1.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: videoView.bottomAnchor, constant: K.padding),
                                     view1.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: videoView.trailingAnchor)])
    }
    
    /**
     Helper method to set up the second view in the stack.
     */
    private func setupStack2() {
        let view2 = UIView()
        view2.backgroundColor = .green
        stackView.addArrangedSubview(view2)
        
        //content label
        contentLabel = UILabel()
        contentLabel.backgroundColor = .orange
        contentLabel.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        contentLabel.textColor = .white
        contentLabel.numberOfLines = 0
        contentLabel.text = menuItem.item.description
        
        view2.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([contentLabel.topAnchor.constraint(equalTo: view2.safeAreaLayoutGuide.topAnchor, constant: K.padding),
                                     contentLabel.leadingAnchor.constraint(equalTo: view2.safeAreaLayoutGuide.leadingAnchor),
                                     view2.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor)])

        
        
        
        
        
        
        
        //*******FIX!!!
        if menuItem == .item5 {
            goButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            goButton.backgroundColor = .gray
            goButton.layer.cornerRadius = 10
            goButton.layer.shadowOffset = .zero
            goButton.layer.shadowRadius = 3
            goButton.layer.shadowColor = UIColor.black.cgColor
            goButton.layer.shadowOpacity = 0.6
            goButton.titleLabel?.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
            goButton.setTitle("Go to PlanetARium", for: .normal)
            goButton.addTarget(self, action: #selector(loadPlanetARium), for: .touchUpInside)
            view2.addSubview(goButton)
            goButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([goButton.centerXAnchor.constraint(equalTo: view2.centerXAnchor),
                                         goButton.centerYAnchor.constraint(equalTo: view2.centerYAnchor)])
        }

    }
    
    
    // MARK: - PlanetARium Segue
            
    @objc func loadPlanetARium(_ sender: UIButton) {
        superView.label.alpha = 1.0
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
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
}
