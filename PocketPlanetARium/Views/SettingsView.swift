//
//  SettingsView.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/1/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit


// MARK: - Settings Sub Button Struct

struct SettingsSubButton {
    var button = UIButton()
    var buttonOrder: CGFloat
    
    func getCollapsedPosition(in view: UIView) -> CGPoint {
        return CGPoint(x: view.frame.width - SettingsView.buttonSize,
                       y: view.frame.height - SettingsView.buttonSize)
    }
    
    func getExpandedPosition(in view: UIView) -> CGPoint {
        let offset = (buttonOrder + 1) * SettingsView.buttonSize + buttonOrder * SettingsView.buttonSpacing
        
        return CGPoint(x: view.frame.width - offset,
                       y: view.frame.height - offset)
    }
}


// MARK: - SettingsView Delegate Function Headers

protocol SettingsViewDelegate {
    func settingsView(_ controller: SettingsView, didPressSoundButton settingsSubButton: SettingsSubButton?)
    func settingsView(_ controller: SettingsView, didPressLabelsButton settingsSubButton: SettingsSubButton?)
    func settingsView(_ controller: SettingsView, didPressPlayPauseButton settingsSubButton: SettingsSubButton?)
    func settingsView(_ controller: SettingsView, didPressResetAnimationButton settingsSubButton: SettingsSubButton?)
}


// MARK: - SettingsView Class

class SettingsView: UIView {
        
    //Size properties
    static let buttonSize: CGFloat = 60
    static let buttonSpacing: CGFloat = 10
    var homePosition: CGPoint {
        CGPoint(x: self.frame.width - SettingsView.buttonSize,
                y: self.frame.height - SettingsView.buttonSize)
    }

    //State properties
    var showSettings = false
    var isMuted: Bool
    var isPaused = false
    
    //Buttons
    var settingsButton = UIButton()
    enum SubButtonType: String {
        case sound, labels, playPause, resetAnimation
    }
    var settingsSubButtons: [String : SettingsSubButton] = [SubButtonType.sound.rawValue : SettingsSubButton(buttonOrder: 1),
                                                            SubButtonType.labels.rawValue : SettingsSubButton(buttonOrder: 2),
                                                            SubButtonType.playPause.rawValue : SettingsSubButton(buttonOrder: 3),
                                                            SubButtonType.resetAnimation.rawValue : SettingsSubButton(buttonOrder: 4)]
    
    //View parameters
    var viewWidthAnchor: NSLayoutConstraint?
    var viewHeightAnchor: NSLayoutConstraint?
    var collapsedViewSize: CGFloat {
        SettingsView.buttonSize
    }
    var expandedViewSize: CGFloat {
        (CGFloat(settingsSubButtons.count) + 1) * SettingsView.buttonSize + CGFloat(settingsSubButtons.count) * SettingsView.buttonSpacing
    }
    var lastOrientation: UIDeviceOrientation = .portrait
    
    //Delegate var
    var delegate: SettingsViewDelegate?
    
    
    // MARK: - Initialization
    
    init() {
        isMuted = UserDefaults.standard.bool(forKey: K.userDefaultsKey_SoundIsMuted)

        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: SettingsView.buttonSize,
                                 height: SettingsView.buttonSize))
                
        initializeButtons()
        
        translatesAutoresizingMaskIntoConstraints = false
        viewWidthAnchor = widthAnchor.constraint(equalToConstant: frame.width)
        viewHeightAnchor = heightAnchor.constraint(equalToConstant: frame.height)
        NSLayoutConstraint.activate([viewWidthAnchor!, viewHeightAnchor!])
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationDidChange(_:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)

        if UIDevice.current.orientation.isValidInterfaceOrientation {
            lastOrientation = UIDevice.current.orientation
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Helper function that intializes the settings dial button, resetAnimation, playPause and labels buttons.
     */
    private func initializeButtons() {
        
        //The order of adding the button to the subviews MATTER!
        setupButton(&settingsSubButtons[SubButtonType.resetAnimation.rawValue],
                    systemName: "arrow.counterclockwise",
                    backgroundColor: UIColor(named: K.color700) ?? .gray,
                    targetAction: #selector(resetAnimationPressed))

        setupButton(&settingsSubButtons[SubButtonType.playPause.rawValue],
                    systemName: "pause.fill",
                    backgroundColor: UIColor(named: K.color500) ?? .gray,
                    targetAction: #selector(playPausePressed))

        setupButton(&settingsSubButtons[SubButtonType.labels.rawValue],
                    systemName: "info",
                    backgroundColor: UIColor(named: K.color300) ?? .gray,
                    targetAction: #selector(labelsPressed))

        setupButton(&settingsSubButtons[SubButtonType.sound.rawValue],
                    systemName: isMuted ? "speaker.slash.fill" : "speaker.2.fill",
                    backgroundColor: UIColor(named: K.color100) ?? .gray,
                    tintColor: UIColor(named: K.color900) ?? .white,
                    targetAction: #selector(soundPressed))

        settingsButton.frame = CGRect(x: homePosition.x,
                                      y: homePosition.y,
                                      width: SettingsView.buttonSize,
                                      height: SettingsView.buttonSize)
        settingsButton.setBackgroundImage(UIImage(named: "settings"), for: .normal)
        settingsButton.tintColor = UIColor(named: K.color000) ?? .gray
        settingsButton.layer.shadowOpacity = 0.4
        settingsButton.layer.shadowOffset = .zero
        settingsButton.alpha = K.masterAlpha
        settingsButton.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
        addSubview(settingsButton)
    }

    /**
     Sets up a circular SettingsSubButton.
     - parameters:
        - settingsSubButton: the button that will get customized
        - systemName: system name of the button image
        - backgroundColor: button's background color
        - targetAction: selector call to the function that gets called when the button is pressed
     */
    private func setupButton(_ settingsSubButton: inout SettingsSubButton?, systemName: String, backgroundColor: UIColor, tintColor: UIColor = .white, targetAction: Selector) {
        guard let settingsSubButton = settingsSubButton else {
            fatalError("Invalid subButton name!")
        }

        settingsSubButton.button.frame = CGRect(x: homePosition.x,
                                                y: homePosition.y,
                                                width: SettingsView.buttonSize,
                                                height: SettingsView.buttonSize)
        settingsSubButton.button.setImage(UIImage(systemName: systemName), for: .normal)
        settingsSubButton.button.tintColor = tintColor
        settingsSubButton.button.alpha = 0.0
        settingsSubButton.button.backgroundColor = backgroundColor
        settingsSubButton.button.layer.cornerRadius = 0.5 * SettingsView.buttonSize
        settingsSubButton.button.layer.shadowOpacity = 0.4
        settingsSubButton.button.layer.shadowOffset = .zero
        settingsSubButton.button.isHidden = true
        settingsSubButton.button.addTarget(self, action: targetAction, for: .touchUpInside)
        addSubview(settingsSubButton.button)
    }
    
    
    // MARK: - Device Orientation Changes
    
    /**
     Handles resizing of the view dimensions upon device orientation changes.
     */
    @objc private func orientationDidChange(_ notification: NSNotification) {
        //Only need to reposition if settings are expanded and device orientation is portrait or landscape only.
        guard showSettings && UIDevice.current.orientation.isValidInterfaceOrientation else {
            return
        }
        
        
        if UIDevice.current.orientation.isPortrait {
            frame.size.width = collapsedViewSize
            frame.size.height = expandedViewSize
            
            for (_, subButton) in settingsSubButtons {
                subButton.button.frame.origin.x = subButton.getCollapsedPosition(in: self).x
                subButton.button.frame.origin.y = subButton.getExpandedPosition(in: self).y
            }
        }
        else if UIDevice.current.orientation.isLandscape {
            frame.size.width = expandedViewSize
            frame.size.height = collapsedViewSize
            
            for (_, subButton) in settingsSubButtons {
                subButton.button.frame.origin.x = subButton.getExpandedPosition(in: self).x
                subButton.button.frame.origin.y = subButton.getCollapsedPosition(in: self).y
            }
        }
        
        //Always anchor settingsButton dial in the same position, i.e. home position.
        settingsButton.frame.origin.x = homePosition.x
        settingsButton.frame.origin.y = homePosition.y
        
        //Resize the anchor dimension constants to the new view frame dimensions.
        viewWidthAnchor?.constant = frame.width
        viewHeightAnchor?.constant = frame.height
        
        lastOrientation = UIDevice.current.orientation
    }
    
    
    // MARK: - Button Presses
    
    /**
     Handles resizing of the view dimensions upon collapsing or expanding the settings button.
     */
    @objc private func settingsPressed() {
        showSettings = !showSettings
        
        if showSettings {
            audioManager.playSound(for: "SettingsExpand", currentTime: 0)
            
            //Need to reset all buttons while resizing the frame and constraints!!
            if UIDevice.current.orientation.isPortrait ||
                (!UIDevice.current.orientation.isValidInterfaceOrientation && lastOrientation.isPortrait) {

                frame.size.width = collapsedViewSize
                frame.size.height = expandedViewSize
            }
            else if UIDevice.current.orientation.isLandscape ||
                        (!UIDevice.current.orientation.isValidInterfaceOrientation && lastOrientation.isLandscape) {

                frame.size.width = expandedViewSize
                frame.size.height = collapsedViewSize
            }

            viewWidthAnchor?.constant = frame.width
            viewHeightAnchor?.constant = frame.height

            settingsButton.frame.origin.x = homePosition.x
            settingsButton.frame.origin.y = homePosition.y

            for (_, subButton) in settingsSubButtons {
                subButton.button.frame.origin.x = subButton.getCollapsedPosition(in: self).x
                subButton.button.frame.origin.y = subButton.getCollapsedPosition(in: self).y
            }
            
            
            //Now animate the buttons...
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                self.settingsButton.transform = CGAffineTransform(rotationAngle: .pi)
            } completion: { _ in
                K.addHapticFeedback(withStyle: .medium)
            }

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                for (_, subButton) in self.settingsSubButtons {
                    subButton.button.isHidden = false
                    subButton.button.alpha = K.masterAlpha
                    
                    if UIDevice.current.orientation.isPortrait ||
                        (!UIDevice.current.orientation.isValidInterfaceOrientation && self.lastOrientation.isPortrait) {
                        subButton.button.frame.origin.y = subButton.getExpandedPosition(in: self).y
                    }
                    else if UIDevice.current.orientation.isLandscape ||
                                (!UIDevice.current.orientation.isValidInterfaceOrientation && self.lastOrientation.isLandscape) {
                        subButton.button.frame.origin.x = subButton.getExpandedPosition(in: self).x
                    }
                }
            } completion: { _ in
                self.handlePlayPause()
            }
        }
        else {
            K.addHapticFeedback(withStyle: .medium)
            audioManager.playSound(for: "SettingsCollapse", currentTime: 0)

            //Need to reset all buttons while resizing the frame and constraints!!
            frame.size.width = collapsedViewSize
            frame.size.height = collapsedViewSize

            viewWidthAnchor?.constant = frame.width
            viewHeightAnchor?.constant = frame.height

            settingsButton.frame.origin.x = homePosition.x
            settingsButton.frame.origin.y = homePosition.y

            if UIDevice.current.orientation.isPortrait ||
                (!UIDevice.current.orientation.isValidInterfaceOrientation && lastOrientation.isPortrait) {

                for (_, subButton) in settingsSubButtons {
                    subButton.button.frame.origin.x = subButton.getCollapsedPosition(in: self).x
                    subButton.button.frame.origin.y = subButton.getExpandedPosition(in: self).y
                }
            }
            else if UIDevice.current.orientation.isLandscape ||
                        (!UIDevice.current.orientation.isValidInterfaceOrientation && lastOrientation.isLandscape) {

                for (_, subButton) in settingsSubButtons {
                    subButton.button.frame.origin.x = subButton.getExpandedPosition(in: self).x
                    subButton.button.frame.origin.y = subButton.getCollapsedPosition(in: self).y
                }
            }

            
            //Now animate the buttons...
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.settingsButton.transform = CGAffineTransform(rotationAngle: -.pi * 2)
            }, completion: nil)

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                for (_, subButton) in self.settingsSubButtons {
                    subButton.button.alpha = 0.0
                    
                    if UIDevice.current.orientation.isPortrait ||
                        (!UIDevice.current.orientation.isValidInterfaceOrientation && self.lastOrientation.isPortrait) {
                        subButton.button.frame.origin.y = subButton.getCollapsedPosition(in: self).y
                    }
                    else if UIDevice.current.orientation.isLandscape ||
                                (!UIDevice.current.orientation.isValidInterfaceOrientation && self.lastOrientation.isLandscape) {
                        subButton.button.frame.origin.x = subButton.getCollapsedPosition(in: self).x
                    }
                }
            } completion: { _ in
                for (_, subButton) in self.settingsSubButtons {
                    subButton.button.isHidden = true
                }
            }
        }
    }

    /**
     Target action that handles the labels button press.
     */
    @objc private func soundPressed() {
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "ButtonPress", currentTime: 0, pan: 1.0)

        isMuted = !isMuted
        handleSound()

        delegate?.settingsView(self, didPressSoundButton: settingsSubButtons[SubButtonType.sound.rawValue])
    }

    /**
     Target action that handles the labels button press.
     */
    @objc private func labelsPressed() {
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "ButtonPress", currentTime: 0, pan: 0.5)

        delegate?.settingsView(self, didPressLabelsButton: settingsSubButtons[SubButtonType.labels.rawValue])
    }
    
    /**
     Target action that handles the playPause button press.
     */
    @objc private func playPausePressed() {
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "ButtonPress", currentTime: 0, pan: -0.5)

        isPaused = !isPaused
        handlePlayPause()

        delegate?.settingsView(self, didPressPlayPauseButton: settingsSubButtons[SubButtonType.playPause.rawValue])
    }
    
    /**
     Target action that handles the resetAnimation button press.
     */
    @objc private func resetAnimationPressed() {
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "ButtonPress", currentTime: 0, pan: -1.0)

        delegate?.settingsView(self, didPressResetAnimationButton: settingsSubButtons[SubButtonType.resetAnimation.rawValue])
    }
    
    
    // MARK: - Helper Functions
    
    /**
     Toggles the sound on or off.
     */
    private func handleSound() {
        guard let soundButton = settingsSubButtons[SubButtonType.sound.rawValue] else {
            return
        }
                
        UserDefaults.standard.setValue(isMuted, forKey: K.userDefaultsKey_SoundIsMuted)
        audioManager.updateVolumes()
                
        if isMuted {
            soundButton.button.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
        }
        else {
            soundButton.button.setImage(UIImage(systemName: "speaker.2.fill"), for: .normal)
        }
    }
    
    /**
     Helper function that produces a blinking animation when paused, and toggles the button image.
     */
    private func handlePlayPause() {
        guard let playPauseButton = settingsSubButtons[SubButtonType.playPause.rawValue] else {
            return
        }
        
        if isPaused {
            playPauseButton.button.blink()
            playPauseButton.button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        else {
            playPauseButton.button.stopBlink(to: K.masterAlpha)
            playPauseButton.button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
}
