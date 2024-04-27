//
//  MenuContentViewLaunch.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/22/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

protocol MenuContentViewLaunchDelegate: AnyObject {
    func menuContentViewLaunch(_ controller: MenuContentViewLaunch, didPresentPlanetARiumController planetARiumController: PlanetARiumController)
    func menuContentViewLaunch(_ controller: MenuContentViewLaunch, didPresentViewChangeWith alert: UIAlertController, handler: (() -> Void)?)
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
    static let headerMusic = "Music:"
    var bottomStackView: UIStackView!
    var planetARiumViewButton: UIButton!
    var soundButton: UIButton?  //these need to be optional because they're used in didSet below, and may be nil at initialization
    var hintsButton: UIButton?  //these need to be optional because they're used in didSet below, and may be nil at initialization
    var musicThemeButton: UIButton!
    var planetARiumViewLabel: UILabel!
    var soundLabel: UILabel!
    var hintsLabel: UILabel!
    var creditsView: CreditsView!
    var musicThemeLabel: UILabel!
    var musicTheme: Int = 0 {
        didSet {
            if musicTheme > 2 {
                musicTheme = 0
            }
        }
    }
    var creditsLabel: UILabel!
    
    // MARK: - Misc Properties
    let buttonColor = UIColor(rgb: 0x3498db)
    let buttonPressedColor = K.color500
    let descriptionColor = K.colorIcyBlue
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
    weak var delegate: MenuContentViewLaunchDelegate?


    // MARK: - Initialization
    
    init(in superView: MenuBezelView, with menuItem: MenuItem) {
        self.superView = superView
        self.menuItem = menuItem
        isMuted = UserDefaults.standard.bool(forKey: K.userDefaultsKey_SoundIsMuted)
        hintsAreOff = UserDefaults.standard.bool(forKey: K.userDefaultsKey_HintsAreOff)
        
        super.init(frame: CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height))
        
        setupViews()
        
        AudioManager.shared.requestCamera()
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
        let fontSize: CGFloat = UIDevice.isiPad ? 64 : 40
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
        
        
        
        
        //ENABLE MUSIC THEME CHANGES = Buggy. Resets index when you swipe change views, but persists selected theme.
//        setupHorizontalStack(header: MenuContentViewLaunch.headerMusic,
//                             description: "Main Theme",
//                             gesture: UITapGestureRecognizer(target: self, action: #selector(toggleMusicThemes)))
        
        let credits = UIView()
        //CREDITS PLACEHOLDER - Uncomment to use.
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let attributedText = NSAttributedString(string: "Credits", attributes: underlineAttribute)
        let creditsTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewCredits))
        creditsLabel = UILabel()
        creditsLabel.attributedText = attributedText
        creditsLabel.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        creditsLabel.textColor = descriptionColor
        creditsLabel.textAlignment = .center
        creditsLabel.addGestureRecognizer(creditsTapGesture)
        creditsLabel.isUserInteractionEnabled = true
        
        credits.addSubview(creditsLabel)
        creditsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([creditsLabel.topAnchor.constraint(equalTo: credits.safeAreaLayoutGuide.topAnchor),
                                     credits.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: creditsLabel.bottomAnchor),
                                     creditsLabel.centerXAnchor.constraint(equalTo: credits.centerXAnchor)])
        bottomStackView.addArrangedSubview(credits)

        creditsView = CreditsView(in: self)

        
        
        
        //Just some space filler...
        setupHorizontalStack(header: "", description: "", gesture: nil)
        setupHorizontalStack(header: "", description: "", gesture: nil)

        //Launch button
        launchButton = UIButton(type: .system)
        launchButton.backgroundColor = buttonColor
        launchButton.setTitle("Launch PlanetARium", for: .normal)
        launchButton.titleLabel?.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        launchButton.tintColor = .white
        launchButton.layer.cornerRadius = UIDevice.isiPad ? 37.5 : 25
        launchButton.layer.shadowRadius = UIDevice.isiPad ? 6 : 4
        launchButton.layer.shadowColor = UIColor.black.cgColor
        launchButton.layer.shadowOpacity = 0.3
        launchButton.addTarget(self, action: #selector(assessCameraAccess(_:)), for: .touchUpInside)

        bottomStackView.addSubview(launchButton)

        launchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([launchButton.widthAnchor.constraint(equalToConstant: UIDevice.isiPad ? 400 : 225),
                                     launchButton.heightAnchor.constraint(equalToConstant: UIDevice.isiPad ? 75 : 50),
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
            let buttonSize: CGFloat = UIDevice.isiPad ? 40 : 30
            let button = UIButton(type: .system)
            button.layer.cornerRadius = buttonSize / 2
            button.layer.shadowRadius = UIDevice.isiPad ? 6 : 4
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
            case MenuContentViewLaunch.headerMusic:
                button.backgroundColor = buttonColor
                musicThemeButton = button
                leftView.addSubview(musicThemeButton!)
                musicThemeButton!.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([musicThemeButton!.widthAnchor.constraint(equalToConstant: buttonSize),
                                             musicThemeButton!.heightAnchor.constraint(equalToConstant: buttonSize),
                                             musicThemeButton!.centerYAnchor.constraint(equalTo: leftView.safeAreaLayoutGuide.centerYAnchor),
                                             leftView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: musicThemeButton!.trailingAnchor)])
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
        case MenuContentViewLaunch.headerMusic:
            musicThemeLabel = descLabel
            rightView.addSubview(musicThemeLabel)
            musicThemeLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([musicThemeLabel.topAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.topAnchor),
                                         musicThemeLabel.leadingAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.leadingAnchor),
                                         rightView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: musicThemeLabel.bottomAnchor),
                                         rightView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: musicThemeLabel.trailingAnchor)])
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
        AudioManager.shared.playSound(for: "MenuButton", currentTime: 0.0)

        planetARiumViewButton.backgroundColor = buttonPressedColor
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.planetARiumViewButton.backgroundColor = self.buttonColor
        }

        let alert = UIAlertController(title: "Select PlanetARium View", message: nil, preferredStyle: .actionSheet)
        let actionSolarSystem = UIAlertAction(title: "Solar System", style: .default) { _ in
            print("Solar System pressed")
        }
        let actionConstellations = UIAlertAction(title: "Constellations (coming soon!)", style: .default) { _ in
            print("Constellations pressed")
        }
        let actionMilkyWay = UIAlertAction(title: "Milky Way Galaxy (coming soon!)", style: .default) { _ in
            print("Milky Way pressed")
        }
        let actionAndromeda = UIAlertAction(title: "Andromeda Galaxy (coming soon!)", style: .default) { _ in
            print("Andromeda pressed")
        }
        let actionVirgo = UIAlertAction(title: "Virgo Supercluster (coming soon!)", style: .default) { _ in
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
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        delegate?.menuContentViewLaunch(self, didPresentViewChangeWith: alert, handler: nil)
    }
    
    /**
     One of the tap gesture recognizers that handles toggling the sound on and off.
     */
    @objc private func toggleSound() {
        K.addHapticFeedback(withStyle: .light)
        AudioManager.shared.playSound(for: "MenuButton", currentTime: 0.0)
        
        isMuted = !isMuted
        UserDefaults.standard.setValue(isMuted, forKey: K.userDefaultsKey_SoundIsMuted)
        AudioManager.shared.updateVolumes()
        
        soundLabel.text = isMuted ? "Off" : "On"
    }
    
    /**
     One of the tap gesture recognizers that handles toggling the hints at startup, on and off.
     */
    @objc private func toggleHints() {
        K.addHapticFeedback(withStyle: .light)
        AudioManager.shared.playSound(for: "MenuButton", currentTime: 0.0)
        
        hintsAreOff = !hintsAreOff
        UserDefaults.standard.setValue(hintsAreOff, forKey: K.userDefaultsKey_HintsAreOff)
        
        hintsLabel.text = hintsAreOff ? "Off" : "On"
    }
    
    @objc private func toggleMusicThemes() {
        K.addHapticFeedback(withStyle: .light)
        AudioManager.shared.playSound(for: "MenuButton", currentTime: 0.0)
        
        musicThemeButton.backgroundColor = buttonPressedColor
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.musicThemeButton.backgroundColor = self.buttonColor
        } completion: { _ in
            self.musicTheme += 1
            
            switch self.musicTheme {
            case 0:
                AudioManager.shared.setTheme(.main)
                self.musicThemeLabel.text = "Main Theme"
            case 1:
                AudioManager.shared.setTheme(.mario)
                self.musicThemeLabel.text = "Super Mario Bros."
            case 2:
                AudioManager.shared.setTheme(.starWars)
                self.musicThemeLabel.text = "Star Wars"
            default:
                break
            }
        }
    }
    
    @objc private func viewCredits() {
        K.addHapticFeedback(withStyle: .light)
        AudioManager.shared.playSound(for: "MenuButton", currentTime: 0.0)
        
        creditsView.play()
    }
    
    /**
     Assess whether or not camera has been access and give user one last time to change, if recently denied.
     */
    @objc private func assessCameraAccess(_ sender: UIButton) {
        tapButton(sender)
        
        guard AudioManager.shared.checkForCamera() == .authorized else {
            let alertController = UIAlertController(title: "⚠️Camera Denied", message: "For the best AR experience, tap Open Settings and enable Camera access.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL)
                }
            }))
            alertController.addAction(UIAlertAction(title: "Proceed Anyway", style: .default, handler: { [unowned self] _ in
                loadPlanetARium()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            delegate?.menuContentViewLaunch(self, didPresentViewChangeWith: alertController) { [unowned self] in
                untapButton(sender)
            }

            return
        }
        
        loadPlanetARium()
        untapButton(sender)
    }
    
    private func tapButton(_ sender: UIButton) {
        sender.backgroundColor = buttonPressedColor
        K.addHapticFeedback(withStyle: .light)
        AudioManager.shared.playSound(for: "LaunchButton", currentTime: 0.0)
    }
    
    private func untapButton(_ sender: UIButton) {
        sender.backgroundColor = buttonColor
    }
    
    /**
     Launches the PlanetARium!
     */
    private func loadPlanetARium() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 8

        let attributedString = NSMutableAttributedString(string: AudioManager.shared.launchMessage)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        superView.label.attributedText = attributedString
        

        let duration: TimeInterval = 0.25
        
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
        
        AudioManager.shared.stopSound(for: "MenuScreen", fadeDuration: 2.0)
    }//end loadPlanetARium()
    
    
}
