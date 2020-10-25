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

class MenuContentViewLaunch: UIView {
    var superView: MenuBezelView!
    var stackView: UIStackView!
    var launchButton: UIButton!
    
    // MARK: - Top Stack Properties
    var titleTopLabel: UILabel!
    var titleBottomLabel: UILabel!
    var trulyImmersiveLabel: UILabel!

    // MARK: - Bottom Stack properties
    static let headerView = "View:"
    static let headerSound = "Sound:"
    static let headerHints = "Hints:"
    var bottomStackView: UIStackView!
    var planetARiumViewButton: UIButton!
    var soundButton: UIButton?  //these need to be optional because they're used in didSet below, and may be nil at initialization
    var hintsButton: UIButton?  //these need to be optional because they're used in didSet below, and may be nil at initialization
    var planetARiumViewLabel: UILabel!
    var soundLabel: UILabel!
    var hintsLabel: UILabel!
    var creditsLabel: UILabel!
    
    // MARK: - Misc Properties
    let buttonColor = UIColor(rgb: 0x3498db)
    let buttonPressedColor = UIColor(named: K.color500)!
    let descriptionColor = UIColor(red: 175, green: 255, blue: 255)
    var menuItem: MenuItem
    var isMuted: Bool {
        didSet {
            soundButton?.backgroundColor = isMuted ? buttonPressedColor : buttonColor
        }
    }
    var hintsAreOff: Bool {
        didSet {
            hintsButton?.backgroundColor = hintsAreOff ? buttonPressedColor : buttonColor
        }
    }
    var delegate: MenuContentViewLaunchDelegate?


    // MARK: - Initialization
    
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
        let topView = UIView()
        topView.clipsToBounds = true
        stackView.addArrangedSubview(topView)
        
        let fontTitle: String = K.fontTitle
        let fontSize: CGFloat = 40
        let titlePadding: CGFloat = 0.0
        let textColor = UIColor.getRandom(redRange: 175...255, greenRange: 175...255, blueRange: 175...255)
        let shadowOffset: CGFloat = 3.0
        
        //"Pocket" label
        titleTopLabel = UILabel(frame: CGRect(x: -frame.width,
                                              y: frame.height / 4 - fontSize - titlePadding,
                                              width: frame.width,
                                              height: fontSize + 10))
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
        titleBottomLabel = UILabel(frame: CGRect(x: frame.width,
                                                 y: frame.height / 4,
                                                 width: frame.width,
                                                 height: fontSize + 10))
        titleBottomLabel.font = UIFont(name: fontTitle, size: fontSize)
        titleBottomLabel.textColor = textColor
        titleBottomLabel.textAlignment = .center
        titleBottomLabel.numberOfLines = 0
        titleBottomLabel.text = "PlanetARium"
        titleBottomLabel.shadowColor = .darkGray
        titleBottomLabel.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        titleBottomLabel.alpha = 0.0
        addSubview(titleBottomLabel)
        
        //"A truly immersive experience!
        trulyImmersiveLabel = UILabel(frame: CGRect(x: 0,
                                                    y: frame.height / 4 + fontSize + titlePadding,
                                                    width: frame.width,
                                                    height: fontSize + 10))
        trulyImmersiveLabel.font = UIFont(name: K.fontFace, size: K.fontSizePeekDetails)
        trulyImmersiveLabel.textColor = .white
        trulyImmersiveLabel.textAlignment = .center
        trulyImmersiveLabel.text = "A truly immersive experience!"
        trulyImmersiveLabel.alpha = 0.0
        addSubview(trulyImmersiveLabel)
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
        
        setupHorizontalStack(header: MenuContentViewLaunch.headerView,
                             description: "Solar System",
                             gesture: UITapGestureRecognizer(target: self, action: #selector(changeView)))
        
        setupHorizontalStack(header: MenuContentViewLaunch.headerSound,
                             description: isMuted ? "Off" : "On",
                             gesture: UITapGestureRecognizer(target: self, action: #selector(toggleSound)))

        setupHorizontalStack(header: MenuContentViewLaunch.headerHints,
                             description: hintsAreOff ? "Off" : "On",
                             gesture: UITapGestureRecognizer(target: self, action: #selector(toggleHints)))
        
        let creditsView = UIView()
        //CREDITS PLACEHOLDER - Uncomment to use.
//        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
//        let attributedText = NSAttributedString(string: "Credits", attributes: underlineAttribute)
//        creditsLabel = UILabel()
//        creditsLabel.attributedText = attributedText
//        creditsLabel.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
//        creditsLabel.textColor = descriptionColor
//        creditsLabel.textAlignment = .center
//        creditsView.addSubview(creditsLabel)
//        creditsLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([creditsLabel.topAnchor.constraint(equalTo: creditsView.safeAreaLayoutGuide.topAnchor),
//                                     creditsLabel.leadingAnchor.constraint(equalTo: creditsView.safeAreaLayoutGuide.leadingAnchor),
//                                     creditsView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: creditsLabel.bottomAnchor),
//                                     creditsView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: creditsLabel.trailingAnchor)])
        bottomStackView.addArrangedSubview(creditsView)

        //Just some space filler...
        setupHorizontalStack(header: "", description: "", gesture: nil)
        setupHorizontalStack(header: "", description: "", gesture: nil)

        //Launch button
        launchButton = UIButton(type: .system)
        launchButton.backgroundColor = buttonColor
        launchButton.setTitle("Launch PlanetARium", for: .normal)
        launchButton.titleLabel?.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        launchButton.tintColor = .white
        launchButton.layer.cornerRadius = 25
        launchButton.layer.shadowRadius = 4
        launchButton.layer.shadowColor = UIColor.black.cgColor
        launchButton.layer.shadowOpacity = 0.3
        launchButton.addTarget(self, action: #selector(loadPlanetARium(_:)), for: .touchUpInside)

        bottomStackView.addSubview(launchButton)

        launchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([launchButton.widthAnchor.constraint(equalToConstant: 225),
                                     launchButton.heightAnchor.constraint(equalToConstant: 50),
                                     launchButton.centerXAnchor.constraint(equalTo: bottomStackView.centerXAnchor),
                                     bottomStackView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: launchButton.bottomAnchor, constant: K.padding)])
    }
    
    
    /**
     I hate hate hate this method!!! So inefficient, everything's hard coded, it could use a MAJOR refactor some day...
     */
    private func setupHorizontalStack(header: String, description: String, gesture: UIGestureRecognizer? = nil) {
        let horizontalStackView = UIStackView()
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.alignment = .fill
        horizontalStackView.axis = .horizontal

        //Button/Header Stackview
        let leftStackView = UIStackView()
        leftStackView.distribution = .fillEqually
        leftStackView.alignment = .fill
        leftStackView.axis = .horizontal

        //Left part of the Button/Header stack
        let leftView = UIView()
        if let gesture = gesture {
            let buttonSize: CGFloat = 30
            let button = UIButton(type: .system)
            button.layer.cornerRadius = buttonSize / 2
            button.layer.shadowRadius = 4
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.3
            button.addGestureRecognizer(gesture)

            switch header {
            case MenuContentViewLaunch.headerView:
                button.backgroundColor = buttonColor
                planetARiumViewButton = button
                leftView.addSubview(planetARiumViewButton)
                planetARiumViewButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([planetARiumViewButton.widthAnchor.constraint(equalToConstant: buttonSize),
                                             planetARiumViewButton.heightAnchor.constraint(equalToConstant: buttonSize),
                                             planetARiumViewButton.centerYAnchor.constraint(equalTo: leftView.safeAreaLayoutGuide.centerYAnchor),
                                             leftView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: planetARiumViewButton.trailingAnchor)])
            case MenuContentViewLaunch.headerSound:
                button.backgroundColor = isMuted ? buttonPressedColor : buttonColor
                soundButton = button
                leftView.addSubview(soundButton!)
                soundButton!.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([soundButton!.widthAnchor.constraint(equalToConstant: buttonSize),
                                             soundButton!.heightAnchor.constraint(equalToConstant: buttonSize),
                                             soundButton!.centerYAnchor.constraint(equalTo: leftView.safeAreaLayoutGuide.centerYAnchor),
                                             leftView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: soundButton!.trailingAnchor)])
            case MenuContentViewLaunch.headerHints:
                button.backgroundColor = hintsAreOff ? buttonPressedColor : buttonColor
                hintsButton = button
                leftView.addSubview(hintsButton!)
                hintsButton!.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([hintsButton!.widthAnchor.constraint(equalToConstant: buttonSize),
                                             hintsButton!.heightAnchor.constraint(equalToConstant: buttonSize),
                                             hintsButton!.centerYAnchor.constraint(equalTo: leftView.safeAreaLayoutGuide.centerYAnchor),
                                             leftView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: hintsButton!.trailingAnchor)])
            default:
                break
            }
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
                                     headerLabel.leadingAnchor.constraint(equalTo: midView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
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
        descLabel.textColor = descriptionColor
        descLabel.textAlignment = .left

        switch header {
        case MenuContentViewLaunch.headerView:
            planetARiumViewLabel = descLabel
            rightView.addSubview(planetARiumViewLabel)
            planetARiumViewLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([planetARiumViewLabel.topAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.topAnchor),
                                         planetARiumViewLabel.leadingAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.leadingAnchor),
                                         rightView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: planetARiumViewLabel.bottomAnchor),
                                         rightView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: planetARiumViewLabel.trailingAnchor)])
        case MenuContentViewLaunch.headerSound:
            soundLabel = descLabel
            rightView.addSubview(soundLabel)
            soundLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([soundLabel.topAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.topAnchor),
                                         soundLabel.leadingAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.leadingAnchor),
                                         rightView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: soundLabel.bottomAnchor),
                                         rightView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: soundLabel.trailingAnchor)])
        case MenuContentViewLaunch.headerHints:
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
        
        horizontalStackView.addArrangedSubview(rightView)
        
        bottomStackView.addArrangedSubview(horizontalStackView)
    }
    
    
    // MARK: - Menu Buttons
    
    /**
     One of the tap gesture recognizers that handles changing the planetarium view.
     */
    @objc private func changeView() {
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "MenuButton", currentTime: 0.0)
        planetARiumViewButton.backgroundColor = buttonPressedColor

        let alert = UIAlertController(title: "Select PlanetARium View", message: nil, preferredStyle: .actionSheet)
        let actionSolarSystem = UIAlertAction(title: "Solar System", style: .default) { _ in
            self.planetARiumViewButton.backgroundColor = self.buttonColor
            print("Solar System pressed")
        }
        let actionConstellations = UIAlertAction(title: "Constellations (coming soon!)", style: .default) { _ in
            self.planetARiumViewButton.backgroundColor = self.buttonColor
            print("Constellations pressed")
        }
        let actionMilkyWay = UIAlertAction(title: "Milky Way Galaxy (coming soon!)", style: .default) { _ in
            self.planetARiumViewButton.backgroundColor = self.buttonColor
            print("Milky Way pressed")
        }
        let actionAndromeda = UIAlertAction(title: "Andromeda Galaxy (coming soon!)", style: .default) { _ in
            self.planetARiumViewButton.backgroundColor = self.buttonColor
            print("Andromeda pressed")
        }
        let actionVirgo = UIAlertAction(title: "Virgo Supercluster (coming soon!)", style: .default) { _ in
            self.planetARiumViewButton.backgroundColor = self.buttonColor
            print("Virgo pressed")
        }

        actionConstellations.isEnabled = false
        actionMilkyWay.isEnabled = false
        actionAndromeda.isEnabled = false
        actionVirgo.isEnabled = false
        
        alert.addAction(actionSolarSystem)
        alert.addAction(actionConstellations)
        alert.addAction(actionMilkyWay)
        alert.addAction(actionAndromeda)
        alert.addAction(actionVirgo)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.planetARiumViewButton.backgroundColor = self.buttonColor
        })
        
        delegate?.menuContentViewLaunch(self, didPresentViewChangeWith: alert)
    }
    
    /**
     One of the tap gesture recognizers that handles toggling the sound on and off.
     */
    @objc private func toggleSound() {
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "MenuButton", currentTime: 0.0)
        
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
        audioManager.playSound(for: "MenuButton", currentTime: 0.0)
        
        hintsAreOff = !hintsAreOff
        UserDefaults.standard.setValue(hintsAreOff, forKey: K.userDefaultsKey_HintsAreOff)
        
        hintsLabel.text = hintsAreOff ? "Off" : "On"
    }
    
    /**
     Launches the PlanetARium!
     */
    @objc private func loadPlanetARium(_ sender: UIButton) {
        let duration: TimeInterval = 0.25
        
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "LaunchButton", currentTime: 0.0)
        audioManager.stopSound(for: "MenuScreen", fadeDuration: 2.0)
        
        sender.backgroundColor = buttonPressedColor
        
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
}
