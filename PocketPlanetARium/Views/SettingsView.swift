//
//  SettingsView.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/1/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

struct SettingsSubButton {
    var button = UIButton()
    var buttonOrder: CGFloat
    
    func getPositionInView(_ view: UIView) -> CGPoint {
        let offset = (buttonOrder + 1) * SettingsView.buttonSize + buttonOrder * SettingsView.buttonSpacing
        
        return CGPoint(x: view.frame.width - offset,
                       y: view.frame.height - offset)
    }
}


protocol SettingsViewDelegate {
    func settingsView(_ controller: SettingsView, didPressLabelsButton settingsSubButton: SettingsSubButton?)
    func settingsView(_ controller: SettingsView, didPressPlayPauseButton settingsSubButton: SettingsSubButton?)
    func settingsView(_ controller: SettingsView, didPressResetAnimationButton settingsSubButton: SettingsSubButton?)
}

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
    var isPaused = false
    
    //Buttons
    var settingsButton = UIButton()
    enum SubButtonType: String {
        case labels, playPause, resetAnimation
    }
    var settingsSubButtons: [String : SettingsSubButton] = [SubButtonType.labels.rawValue : SettingsSubButton(buttonOrder: 1),
                                                            SubButtonType.playPause.rawValue : SettingsSubButton(buttonOrder: 2),
                                                            SubButtonType.resetAnimation.rawValue : SettingsSubButton(buttonOrder: 3)]
    
    //Constraints
    var viewWidthAnchor: NSLayoutConstraint?
    var viewHeightAnchor: NSLayoutConstraint?
    var lastOrientation: UIDeviceOrientation = .portrait
    
    //Delegate var
    var delegate: SettingsViewDelegate?
    
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: SettingsView.buttonSize,
                                 height: SettingsView.buttonSize))
        
        initializeButtons()
        
        backgroundColor = .blue
        
        viewWidthAnchor = widthAnchor.constraint(equalToConstant: frame.width)
        viewHeightAnchor = heightAnchor.constraint(equalToConstant: frame.height)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([viewWidthAnchor!, viewHeightAnchor!])
        
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationDidChange(_:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        
        
        //The order of adding the button to the subviews MATTER!
        setupButton(&settingsSubButtons[SubButtonType.resetAnimation.rawValue],
                    systemName: "arrow.counterclockwise",
                    backgroundColor: UIColor(named: "BlueGrey500") ?? .gray,
                    targetAction: #selector(resetAnimationPressed))

        setupButton(&settingsSubButtons[SubButtonType.playPause.rawValue],
                    systemName: "pause.fill",
                    backgroundColor: UIColor(named: "BlueGrey300") ?? .gray,
                    targetAction: #selector(playPausePressed))

        setupButton(&settingsSubButtons[SubButtonType.labels.rawValue],
                    systemName: "textformat",
                    backgroundColor: UIColor(named: "BlueGrey100") ?? .gray,
                    targetAction: #selector(labelsPressed))

        settingsButton.frame = CGRect(x: homePosition.x,
                                      y: homePosition.y,
                                      width: SettingsView.buttonSize,
                                      height: SettingsView.buttonSize)
        settingsButton.setBackgroundImage(UIImage(named: "settings"), for: .normal)
        settingsButton.tintColor = UIColor(named: "BlueGrey000") ?? .gray
        settingsButton.layer.shadowOpacity = 0.4
        settingsButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        settingsButton.alpha = K.masterAlpha
        settingsButton.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
        self.addSubview(settingsButton)
    }

    /**
     Sets up a circular SettingsSubButton.
     - parameters:
        - settingsSubButton: the button that will get customized
        - systemName: system name of the button image
        - backgroundColor: button's background color
        - targetAction: selector call to the function that gets called when the button is pressed
     */
    private func setupButton(_ settingsSubButton: inout SettingsSubButton?, systemName: String, backgroundColor: UIColor, targetAction: Selector) {
        guard let settingsSubButton = settingsSubButton else {
            fatalError("Invalid subButton name!")
        }

        settingsSubButton.button.frame = CGRect(x: self.homePosition.x,
                                                y: self.homePosition.y,
                                                width: SettingsView.buttonSize,
                                                height: SettingsView.buttonSize)
        settingsSubButton.button.setImage(UIImage(systemName: systemName), for: .normal)
        settingsSubButton.button.tintColor = .white
        settingsSubButton.button.alpha = 0.0
        settingsSubButton.button.backgroundColor = backgroundColor
        settingsSubButton.button.layer.cornerRadius = 0.5 * SettingsView.buttonSize
        settingsSubButton.button.clipsToBounds = true
        settingsSubButton.button.isHidden = true
        settingsSubButton.button.addTarget(self, action: targetAction, for: .touchUpInside)
        self.addSubview(settingsSubButton.button)
    }
    
    
    // MARK: - Device Orientation Change
    
    @objc private func orientationDidChange(_ notification: NSNotification) {
        //Only need to reposition if settings are expanded and device orientation is portrait or landscape only.
        guard showSettings && UIDevice.current.orientation.isValidInterfaceOrientation else {
            return
        }
        
        
        let subButtonsCount = CGFloat(settingsSubButtons.count)
        let newSize = (subButtonsCount + 1) * SettingsView.buttonSize + subButtonsCount * SettingsView.buttonSpacing
        
        if UIDevice.current.orientation.isPortrait {
            frame.size.width = SettingsView.buttonSize
            frame.size.height = newSize
            
            for (_, subButton) in settingsSubButtons {
                subButton.button.frame.origin.x = homePosition.x
                subButton.button.frame.origin.y = subButton.getPositionInView(self).y
            }
        }
        else if UIDevice.current.orientation.isLandscape {
            frame.size.width = newSize
            frame.size.height = SettingsView.buttonSize
            
            for (_, subButton) in settingsSubButtons {
                subButton.button.frame.origin.x = subButton.getPositionInView(self).x
                subButton.button.frame.origin.y = homePosition.y
            }
        }
        
        settingsButton.frame.origin.x = homePosition.x
        settingsButton.frame.origin.y = homePosition.y
        viewWidthAnchor?.constant = frame.width
        viewHeightAnchor?.constant = frame.height
        
        lastOrientation = UIDevice.current.orientation
    }
    
    
    // MARK: - Button Presses
    
    @objc private func settingsPressed() {
        showSettings = !showSettings
        
        
        
        
        //************TEST
        //Need to reset all buttons while resizing the frame and constraints!!
        let subButtonsCount = CGFloat(self.settingsSubButtons.count)
        let newSize = (subButtonsCount + 1) * SettingsView.buttonSize + subButtonsCount * SettingsView.buttonSpacing
        
        if UIDevice.current.orientation.isPortrait ||
            (!UIDevice.current.orientation.isValidInterfaceOrientation && self.lastOrientation.isPortrait) {
            self.frame.size.height = newSize
            self.viewHeightAnchor?.constant = self.frame.height
            self.settingsButton.frame.origin.y = self.homePosition.y
            
            for (_, subButton) in self.settingsSubButtons {
                subButton.button.frame.origin.y = self.homePosition.y
            }
        }
        else if UIDevice.current.orientation.isLandscape ||
                    (!UIDevice.current.orientation.isValidInterfaceOrientation && self.lastOrientation.isLandscape) {
            self.frame.size.width = newSize
            self.viewWidthAnchor?.constant = self.frame.width
            self.settingsButton.frame.origin.x = self.homePosition.x
            
            for (_, subButton) in self.settingsSubButtons {
                subButton.button.frame.origin.x = self.homePosition.x
            }
        }
        
        
        
        
        
        
        
        
        if showSettings {
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
                        subButton.button.frame.origin.y = subButton.getPositionInView(self).y
                    }
                    else if UIDevice.current.orientation.isLandscape ||
                                (!UIDevice.current.orientation.isValidInterfaceOrientation && self.lastOrientation.isLandscape) {
                        subButton.button.frame.origin.x = subButton.getPositionInView(self).x
                    }
                }
            } completion: { _ in
                self.handlePlayPause()
            }
        }
        else {
            K.addHapticFeedback(withStyle: .medium)

            
            
            
            //************TEST
            //Need to reset all buttons while resizing the frame and constraints!!
            if UIDevice.current.orientation.isPortrait ||
                (!UIDevice.current.orientation.isValidInterfaceOrientation && self.lastOrientation.isPortrait) {
                self.frame.size.height = SettingsView.buttonSize
                self.viewHeightAnchor?.constant = self.frame.height
                self.settingsButton.frame.origin.y = self.homePosition.y
                
                for (_, subButton) in self.settingsSubButtons {
                    subButton.button.frame.origin.y = subButton.getPositionInView(self).y
                }
                
                self.lastOrientation = .portrait
            }
            else if UIDevice.current.orientation.isLandscape ||
                        (!UIDevice.current.orientation.isValidInterfaceOrientation && self.lastOrientation.isLandscape) {
                self.frame.size.width = SettingsView.buttonSize
                self.viewWidthAnchor?.constant = self.frame.width
                self.settingsButton.frame.origin.x = self.homePosition.x
                
                for (_, subButton) in self.settingsSubButtons {
                    subButton.button.frame.origin.x = subButton.getPositionInView(self).x
                }
                
                self.lastOrientation = .landscapeRight
            }

            
            
            
            
            
            
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.settingsButton.transform = CGAffineTransform(rotationAngle: -.pi * 2)
            }, completion: nil)

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                for (_, subButton) in self.settingsSubButtons {
                    subButton.button.alpha = 0.0
                    
                    if UIDevice.current.orientation.isPortrait ||
                        (!UIDevice.current.orientation.isValidInterfaceOrientation && self.lastOrientation.isPortrait) {
                        subButton.button.frame.origin.y = self.homePosition.y
                    }
                    else if UIDevice.current.orientation.isLandscape ||
                                (!UIDevice.current.orientation.isValidInterfaceOrientation && self.lastOrientation.isLandscape) {
                        subButton.button.frame.origin.x = self.homePosition.x
                    }
                }
            } completion: { _ in
                for (_, subButton) in self.settingsSubButtons {
                    subButton.button.isHidden = true
                }
            }
        }
    }

    @objc private func labelsPressed() {
        K.addHapticFeedback(withStyle: .light)
        delegate?.settingsView(self, didPressLabelsButton: settingsSubButtons[SubButtonType.labels.rawValue])
    }
    
    @objc private func resetAnimationPressed() {
        K.addHapticFeedback(withStyle: .light)
        delegate?.settingsView(self, didPressResetAnimationButton: settingsSubButtons[SubButtonType.resetAnimation.rawValue])
    }
    
    @objc private func playPausePressed() {
        K.addHapticFeedback(withStyle: .light)

        isPaused = !isPaused
        handlePlayPause()

        delegate?.settingsView(self, didPressPlayPauseButton: settingsSubButtons[SubButtonType.playPause.rawValue])
    }
    
    
    // MARK: - Helper Functions
    
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
