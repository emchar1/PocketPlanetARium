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
    func menuContentViewLaunch(_ controller: MenuContentViewLaunch, didPresentViewChangeWith alert: UIAlertController)
}


struct StackItems {
    let button: UIButton
    let title: String
    let description: String
}


class MenuContentViewLaunch: UIView {
    var superView: MenuBezelView!
    var stackView: UIStackView!
    var launchButton: UIButton!

    //Top stack properties
    var titleTopLabel: UILabel!
    var titleBottomLabel: UILabel!

    //Bottom stack properties
    var bottomStackView: UIStackView!
    var planetARiumViewButton: UIButton!
    var soundButton: UIButton?  //these need to be optional because they're used in didSet below, and may be nil at initialization
    var hintsButton: UIButton?  //these need to be optional because they're used in didSet below, and may be nil at initialization
    var planetARiumViewLabel: UILabel!
    var soundLabel: UILabel!
    var hintsLabel: UILabel!
    var creditsLabel: UILabel!
    
    //Misc properties
    var menuItem: MenuItem
    var isMuted: Bool {
        didSet {
            soundButton?.backgroundColor = isMuted ? .red : .green
        }
    }
    var hintsAreOff: Bool {
        didSet {
            hintsButton?.backgroundColor = hintsAreOff ? .red : .green
        }
    }
    var delegate: MenuContentViewLaunchDelegate?


    
    
    
    
    
    
    //TOTALLY A TEST!!!
//    var changeMusicButton: UIButton!
//    var theme = 0




    

        
    init(in superView: MenuBezelView, with menuItem: MenuItem) {
        self.superView = superView
        self.menuItem = menuItem
        isMuted = UserDefaults.standard.bool(forKey: K.userDefaultsKey_SoundIsMuted)
        hintsAreOff = UserDefaults.standard.bool(forKey: K.userDefaultsKey_HintsAreOff)
        
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
        
        soundLabel = UILabel()
        soundLabel.text = "Fiddle"
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: K.padding),
                                     stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: -2 * K.padding),
                                     safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: K.padding),
                                     safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -2 * K.padding)])

        setupStackTop()
        setupStackBottom()
    }
    
    /**
     Helper method to set up the first view in the stack.
     */
    private func setupStackTop() {
        let holderView = UIView()
        holderView.clipsToBounds = true
        stackView.addArrangedSubview(holderView)
        
        
        let fontTitle: String = K.fontTitle
        let fontSize: CGFloat = 40
        let textColor = UIColor.getRandom(redRange: 175...255, greenRange: 175...255, blueRange: 175...255)
        let shadowOffset: CGFloat = 3.0
        
        //"Pocket" label
        titleTopLabel = UILabel(frame: CGRect(x: -frame.width, y: frame.height / 4 - 25, width: frame.width, height: 50))
        titleTopLabel.font = UIFont(name: fontTitle, size: fontSize)
        titleTopLabel.textColor = textColor
        titleTopLabel.textAlignment = .center
        titleTopLabel.numberOfLines = 0
        titleTopLabel.text = "Pocket"
        titleTopLabel.shadowColor = .darkGray
        titleTopLabel.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        titleTopLabel.alpha = 0.0
        addSubview(titleTopLabel)
        
        //"PlanetARium" label
        titleBottomLabel = UILabel(frame: CGRect(x: frame.width, y: frame.height / 4 + 25, width: frame.width, height: 50))
        titleBottomLabel.font = UIFont(name: fontTitle, size: fontSize)
        titleBottomLabel.textColor = textColor
        titleBottomLabel.textAlignment = .center
        titleBottomLabel.numberOfLines = 0
        titleBottomLabel.text = "PlanetARium"
        titleBottomLabel.shadowColor = .darkGray
        titleBottomLabel.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        titleBottomLabel.alpha = 0.0
        addSubview(titleBottomLabel)
    }
    
    /**
     Helper method to set up the second view in the stack.
     */
    private func setupStackBottom() {
        //Bottom half stack view
        bottomStackView = UIStackView()
        bottomStackView.distribution = .fillEqually
        bottomStackView.alignment = .fill
        bottomStackView.axis = .vertical
        stackView.addArrangedSubview(bottomStackView)
        
        setupHorizontalStack(header: "View:", description: "Solar System",
                             gesture: UITapGestureRecognizer(target: self, action: #selector(changeView)))
        
        setupHorizontalStack(header: "Sound:", description: isMuted ? "Off" : "On",
                             gesture: UITapGestureRecognizer(target: self, action: #selector(toggleSound)))

        setupHorizontalStack(header: "Hints:", description: hintsAreOff ? "Off" : "On",
                             gesture: UITapGestureRecognizer(target: self, action: #selector(toggleHints)))
        
        let creditsView = UIView()
        //CREDITS PLACEHOLDER - Uncomment to use.
//        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
//        let attributedText = NSAttributedString(string: "Credits", attributes: underlineAttribute)
//        creditsLabel = UILabel()
//        creditsLabel.attributedText = attributedText
//        creditsLabel.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
//        creditsLabel.textColor = UIColor(red: 175, green: 255, blue: 255)
//        creditsLabel.textAlignment = .center
//        creditsView.addSubview(creditsLabel)
//        creditsLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([creditsLabel.topAnchor.constraint(equalTo: creditsView.safeAreaLayoutGuide.topAnchor),
//                                     creditsLabel.leadingAnchor.constraint(equalTo: creditsView.safeAreaLayoutGuide.leadingAnchor),
//                                     creditsView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: creditsLabel.bottomAnchor),
//                                     creditsView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: creditsLabel.trailingAnchor)])
        bottomStackView.addArrangedSubview(creditsView)

        //Just a space filler...
        setupHorizontalStack(header: "", description: "", gesture: nil)
        setupHorizontalStack(header: "", description: "", gesture: nil)

        //Launch button
        launchButton = UIButton(type: .system)
        launchButton.backgroundColor = UIColor(rgb: 0x3498db)
        launchButton.setTitle("Launch PlanetARium", for: .normal)
        launchButton.titleLabel?.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        launchButton.tintColor = .white
        launchButton.layer.cornerRadius = 25
        launchButton.layer.shadowRadius = 4
        launchButton.layer.shadowColor = UIColor.black.cgColor
        launchButton.layer.shadowOpacity = 0.3
        launchButton.addTarget(self, action: #selector(loadPlanetARium), for: .touchUpInside)

        bottomStackView.addSubview(launchButton)

        launchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([launchButton.widthAnchor.constraint(equalToConstant: 225),
                                     launchButton.heightAnchor.constraint(equalToConstant: 50),
                                     launchButton.centerXAnchor.constraint(equalTo: bottomStackView.centerXAnchor),
                                     bottomStackView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: launchButton.bottomAnchor, constant: K.padding)])


        
        
        
        
        
        
        
            //TOTALLY A TEST!!!
//            changeMusicButton = UIButton()
//            changeMusicButton.backgroundColor = UIColor(rgb: 0x3498db)
//            changeMusicButton.layer.cornerRadius = 30
//            changeMusicButton.layer.shadowRadius = 3
//            changeMusicButton.layer.shadowColor = UIColor.black.cgColor
//            changeMusicButton.layer.shadowOpacity = 0.3
//            changeMusicButton.titleLabel?.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
//            changeMusicButton.setTitle("Change Theme", for: .normal)
//            changeMusicButton.addTarget(self, action: #selector(changeMusic), for: .touchUpInside)
//            view2.addSubview(changeMusicButton)
//            changeMusicButton.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([changeMusicButton.widthAnchor.constraint(equalToConstant: 225),
//                                         changeMusicButton.heightAnchor.constraint(equalToConstant: 60),
//                                         changeMusicButton.centerXAnchor.constraint(equalTo: view2.centerXAnchor),
//                                         view2.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: changeMusicButton.bottomAnchor, constant: 0)])

    }
    
    
    /**
     I hate hate hate this method!!! So inefficient, everything's hard coded, it could use a MAJOR refactor some day...
     */
    private func setupHorizontalStack(header: String, description: String, gesture: UIGestureRecognizer? = nil) {
        let textPadding: CGFloat = 5.0
        
        let horizontalStackView = UIStackView()
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.alignment = .fill
        horizontalStackView.axis = .horizontal

        //Button and Header Stackview
        let leftStackView = UIStackView()
        leftStackView.distribution = .fillEqually
        leftStackView.alignment = .fill
        leftStackView.axis = .horizontal

        //Left part of the Button/Header stack
        let leftView = UIView()
        if let gesture = gesture {
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 10
            button.layer.shadowRadius = 4
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.3
            button.addGestureRecognizer(gesture)
//            leftView.addGestureRecognizer(gesture)

            switch header {
            case "View:":
                button.backgroundColor = .green
                planetARiumViewButton = button
                leftView.addSubview(planetARiumViewButton)
                planetARiumViewButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([planetARiumViewButton.widthAnchor.constraint(equalToConstant: 20),
                                             planetARiumViewButton.heightAnchor.constraint(equalToConstant: 20),
                                             planetARiumViewButton.centerYAnchor.constraint(equalTo: leftView.safeAreaLayoutGuide.centerYAnchor),
                                             leftView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: planetARiumViewButton.trailingAnchor)])
            case "Sound:":
                button.backgroundColor = isMuted ? .red : .green
                soundButton = button
                leftView.addSubview(soundButton!)
                soundButton!.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([soundButton!.widthAnchor.constraint(equalToConstant: 20),
                                             soundButton!.heightAnchor.constraint(equalToConstant: 20),
                                             soundButton!.centerYAnchor.constraint(equalTo: leftView.safeAreaLayoutGuide.centerYAnchor),
                                             leftView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: soundButton!.trailingAnchor)])
            case "Hints:":
                button.backgroundColor = hintsAreOff ? .red : .green
                hintsButton = button
                leftView.addSubview(hintsButton!)
                hintsButton!.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([hintsButton!.widthAnchor.constraint(equalToConstant: 20),
                                             hintsButton!.heightAnchor.constraint(equalToConstant: 20),
                                             hintsButton!.centerYAnchor.constraint(equalTo: leftView.safeAreaLayoutGuide.centerYAnchor),
                                             leftView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: hintsButton!.trailingAnchor)])
            default:
                break
            }
            
            
            
            
            //OLD WAY
//            leftView.addSubview(button)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([button.widthAnchor.constraint(equalToConstant: 20),
//                                         button.heightAnchor.constraint(equalToConstant: 20),
//                                         button.centerYAnchor.constraint(equalTo: leftView.safeAreaLayoutGuide.centerYAnchor),
//                                         leftView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: button.trailingAnchor)])
        }
        
        //Right part of the Button/Header stack (i.e. middle view)
        let midView = UIView()
        let headerLabel = UILabel()
        headerLabel.text = header
        headerLabel.font = UIFont(name: K.fontFaceSecondary, size: K.fontSizeMenu)
        headerLabel.textColor = .white
        headerLabel.textAlignment = .left
        midView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([headerLabel.topAnchor.constraint(equalTo: midView.safeAreaLayoutGuide.topAnchor),
                                     headerLabel.leadingAnchor.constraint(equalTo: midView.safeAreaLayoutGuide.leadingAnchor, constant: 2 * textPadding),
                                     midView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: headerLabel.bottomAnchor),
                                     midView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor)])
        leftStackView.addArrangedSubview(leftView)
        leftStackView.addArrangedSubview(midView)
        horizontalStackView.addArrangedSubview(leftStackView)

        
        
        
        
        
        
        
        //Description (menu selection) view
        let rightView = UIView()
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        descLabel.textColor = UIColor(red: 175, green: 255, blue: 255)
        descLabel.textAlignment = .left

        switch header {
        case "View:":
            planetARiumViewLabel = descLabel
            rightView.addSubview(planetARiumViewLabel)
            planetARiumViewLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([planetARiumViewLabel.topAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.topAnchor),
                                         planetARiumViewLabel.leadingAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.leadingAnchor),
                                         rightView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: planetARiumViewLabel.bottomAnchor),
                                         rightView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: planetARiumViewLabel.trailingAnchor)])
        case "Sound:":
            soundLabel = descLabel
            rightView.addSubview(soundLabel)
            soundLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([soundLabel.topAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.topAnchor),
                                         soundLabel.leadingAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.leadingAnchor),
                                         rightView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: soundLabel.bottomAnchor),
                                         rightView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: soundLabel.trailingAnchor)])
        case "Hints:":
            hintsLabel = descLabel
            rightView.addSubview(hintsLabel)
            hintsLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([hintsLabel.topAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.topAnchor),
                                         hintsLabel.leadingAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.leadingAnchor),
                                         rightView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: hintsLabel.bottomAnchor),
                                         rightView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: hintsLabel.trailingAnchor)])

        default:
            break
        }

        
        
        
        
        
        //OLD WAY
//        rightView.addSubview(descLabel)
//        descLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([descLabel.topAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.topAnchor),
//                                     descLabel.leadingAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.leadingAnchor),
//                                     rightView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: descLabel.bottomAnchor),
//                                     rightView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: descLabel.trailingAnchor)])
        horizontalStackView.addArrangedSubview(rightView)
        
        bottomStackView.addArrangedSubview(horizontalStackView)
    }
    
    /**
     One of the tap gesture recognizers that handles changing the planetarium view.
     */
    @objc private func changeView() {
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "ButtonPress", currentTime: 0.0)
        planetARiumViewButton.backgroundColor = .yellow

        let alert = UIAlertController(title: nil, message: "Select PlanetARium View", preferredStyle: .actionSheet)
        let actionSolarSystem = UIAlertAction(title: "Solar System", style: .default) { _ in
            self.planetARiumViewButton.backgroundColor = .green
            print("Solar System pressed")
        }
        let actionConstellations = UIAlertAction(title: "Constellations (coming soon!)", style: .default) { _ in
            self.planetARiumViewButton.backgroundColor = .green
            print("Constellations pressed")
        }
        let actionMilkyWay = UIAlertAction(title: "Milky Way Galaxy (coming soon!)", style: .default) { _ in
            self.planetARiumViewButton.backgroundColor = .green
            print("Milky Way pressed")
        }
        let actionAndromeda = UIAlertAction(title: "Andromeda Galaxy (coming soon!)", style: .default) { _ in
            self.planetARiumViewButton.backgroundColor = .green
            print("Andromeda pressed")
        }

        actionConstellations.isEnabled = false
        actionMilkyWay.isEnabled = false
        actionAndromeda.isEnabled = false
        
        alert.addAction(actionSolarSystem)
        alert.addAction(actionConstellations)
        alert.addAction(actionMilkyWay)
        alert.addAction(actionAndromeda)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.planetARiumViewButton.backgroundColor = .green
        })
        
        delegate?.menuContentViewLaunch(self, didPresentViewChangeWith: alert)
    }
    
    /**
     One of the tap gesture recognizers that handles toggling the sound on and off.
     */
    @objc private func toggleSound() {
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "ButtonPress", currentTime: 0.0)
        
        isMuted = !isMuted
        UserDefaults.standard.setValue(isMuted, forKey: K.userDefaultsKey_SoundIsMuted)
        audioManager.updateVolumes()
        
        soundLabel.text = isMuted ? "Off" : "On"
    }
    
    /**
     One of the tap gesture recognizers that handles toggling the hints at startup, on and off.
     */
    @objc private func toggleHints() {
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "ButtonPress", currentTime: 0.0)
        
        hintsAreOff = !hintsAreOff
        UserDefaults.standard.setValue(hintsAreOff, forKey: K.userDefaultsKey_HintsAreOff)
        
        hintsLabel.text = hintsAreOff ? "Off" : "On"
    }
    
    
    // MARK: - PlanetARium Segue
            
    @objc private func loadPlanetARium(_ sender: UIButton) {
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
    
    
    
    
    
    
    
    
    //TOTALLY A TEST!!!
//    @objc func changeMusic(_ sender: UIButton) {
//        K.addHapticFeedback(withStyle: .light)
//
//        theme += 1
//        if theme > 2 {
//            theme = 0
//        }
//        switch  theme {
//        case 0:
//            audioManager.setTheme(.main)
//            sender.setTitle("Main Theme", for: .normal)
//        case 1:
//            audioManager.setTheme(.mario)
//            sender.setTitle("Super Mario", for: .normal)
//        case 2:
//            audioManager.setTheme(.starWars)
//            sender.setTitle("Star Wars", for: .normal)
//        default:
//            print("Unknown theme")
//        }
//        
//        audioManager.setupSounds()
//        audioManager.playSound(for: "ButtonPress", currentTime: 0.0)
//    }

}
