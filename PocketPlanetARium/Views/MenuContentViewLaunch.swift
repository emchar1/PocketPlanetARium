//
//  MenuContentViewLaunch.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/22/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

protocol MenuContentViewLaunchDelegate {
    func menuContentViewLaunch(_ controller: MenuContentViewLaunch, didPresentPlanetARiumController planetARiumController: PlanetARiumController)
}


class MenuContentViewLaunch: UIView {
    var superView: MenuBezelView!
    var stackView: UIStackView!
    var titleLabel: UILabel!
    var titleLabel2: UILabel!
    var contentLabel: UILabel!
    var launchButton: UIButton!
    var menuItem: MenuItem

    var delegate: MenuContentViewLaunchDelegate?


    
    
    
    
    //TEMPORARY!!!!
    var changeMusicButton: UIButton!
    var theme = 0




    

        
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
                                     stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: -2 * K.padding),
                                     safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: K.padding),
                                     safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -2 * K.padding)])

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
        
        //"Pocket" label
        titleLabel = UILabel(frame: CGRect(x: -frame.width, y: frame.height / 4 - 25, width: frame.width, height: 50))
//        titleLabel.backgroundColor = .systemPink
        titleLabel.font = UIFont(name: K.fontTitle, size: 40)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = "Pocket"
        titleLabel.alpha = 0.0
        
        addSubview(titleLabel)
        
//        titleLabelXAnchor = titleLabel.centerXAnchor.constraint(equalTo: view1.safeAreaLayoutGuide.centerXAnchor, constant: -200)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([titleLabelXAnchor!,
//                                     titleLabel.centerYAnchor.constraint(equalTo: view1.safeAreaLayoutGuide.centerYAnchor)])
//        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: view1.safeAreaLayoutGuide.topAnchor),
//                                     titleLabel.leadingAnchor.constraint(equalTo: view1.safeAreaLayoutGuide.leadingAnchor),
//                                     view1.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
//                                     view1.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)])

        //"PlanetARium" label
        titleLabel2 = UILabel(frame: CGRect(x: frame.width, y: frame.height / 4 + 25, width: frame.width, height: 50))
//        titleLabel2.backgroundColor = .purple
        titleLabel2.font = UIFont(name: K.fontTitle, size: 40)
        titleLabel2.textColor = .white
        titleLabel2.textAlignment = .center
        titleLabel2.numberOfLines = 0
        titleLabel2.text = "PlanetARium"
        titleLabel2.alpha = 0.0
        
        addSubview(titleLabel2)

//        titleLabel2XAnchor = titleLabel2.centerXAnchor.constraint(equalTo: view1.safeAreaLayoutGuide.centerXAnchor, constant: 200)
//        titleLabel2.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([titleLabel2XAnchor!,
//                                     titleLabel2.centerYAnchor.constraint(equalTo: view1.safeAreaLayoutGuide.centerYAnchor)])
//        NSLayoutConstraint.activate([titleLabel2.topAnchor.constraint(equalTo: view1.safeAreaLayoutGuide.topAnchor),
//                                     titleLabel2.leadingAnchor.constraint(equalTo: view1.safeAreaLayoutGuide.leadingAnchor),
//                                     view1.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: titleLabel2.bottomAnchor),
//                                     view1.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: titleLabel2.trailingAnchor)])
    }
    
    /**
     Helper method to set up the second view in the stack.
     */
    private func setupStack2() {
        let view2 = UIView()
        stackView.addArrangedSubview(view2)
        
        //content label
        contentLabel = UILabel()
        contentLabel.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        contentLabel.textColor = .white
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        contentLabel.text = menuItem.item.description
        contentLabel.alpha = 0.0
        
        view2.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([contentLabel.topAnchor.constraint(equalTo: view2.safeAreaLayoutGuide.topAnchor, constant: 2 * K.padding),
                                     contentLabel.leadingAnchor.constraint(equalTo: view2.safeAreaLayoutGuide.leadingAnchor),
                                     view2.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor)])

        
        
        
        
        
        
        
        //*******FIX!!!
            launchButton = UIButton()
            launchButton.backgroundColor = UIColor(rgb: 0x3498db)
            launchButton.layer.cornerRadius = 30
            launchButton.layer.shadowRadius = 3
            launchButton.layer.shadowColor = UIColor.black.cgColor
            launchButton.layer.shadowOpacity = 0.3
            launchButton.titleLabel?.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
            launchButton.setTitle("Launch PlanetARium", for: .normal)
            launchButton.addTarget(self, action: #selector(loadPlanetARium), for: .touchUpInside)
            view2.addSubview(launchButton)
            launchButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([launchButton.widthAnchor.constraint(equalToConstant: 225),
                                         launchButton.heightAnchor.constraint(equalToConstant: 60),
                                         launchButton.centerXAnchor.constraint(equalTo: view2.centerXAnchor),
                                         view2.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: launchButton.bottomAnchor, constant: 4 * K.padding)])
            
            
            
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
    
    
    
    // MARK: - PlanetARium Segue
            
    @objc func loadPlanetARium(_ sender: UIButton) {
        let duration: TimeInterval = 0.25
        
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "LaunchButton", currentTime: 0.0)
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
                
                self.delegate?.menuContentViewLaunch(self, didPresentPlanetARiumController: planetARiumController)
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
        
        audioManager.setupSounds()
        audioManager.playSound(for: "ButtonPress", currentTime: 0.0)
    }

}
