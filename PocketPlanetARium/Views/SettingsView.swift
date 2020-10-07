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
    var yPosition: CGFloat
    
    func getYPositionInView(_ view: UIView) -> CGFloat {
        return view.frame.height - (yPosition + 1) * SettingsView.buttonSize - yPosition * SettingsView.buttonSpacing
    }
    
    func getXPositionInView(_ view: UIView) -> CGFloat {
        return view.frame.width - (yPosition + 1) * SettingsView.buttonSize - yPosition * SettingsView.buttonSpacing
    }
}


protocol SettingsViewDelegate {
    func settingsView(_ controller: SettingsView, didPressLabelsButton settingsSubButton: SettingsSubButton)
    func settingsView(_ controller: SettingsView, didPressPlayPauseButton settingsSubButton: SettingsSubButton)
    func settingsView(_ controller: SettingsView, didPressResetAnimationButton settingsSubButton: SettingsSubButton)
}

class SettingsView: UIView {
    
    //Size properties
    static let buttonSize: CGFloat = 60
    static let buttonSpacing: CGFloat = 10
    var buttonHomePosition: CGPoint {
//        CGPoint(x: self.frame.origin.x, y: self.frame.height - SettingsView.buttonSize)
        CGPoint(x: self.frame.width - SettingsView.buttonSize, y: self.frame.height - SettingsView.buttonSize)
    }

    //State properties
    var showSettings = false
    var isPaused = false
    
    //Buttons
    var settingsButton = UIButton()
    var labelsButton = SettingsSubButton(yPosition: 1)
    var playPauseButton = SettingsSubButton(yPosition: 2)
    var resetAnimationButton = SettingsSubButton(yPosition: 3)
        
    var delegate: SettingsViewDelegate?
    
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: 4 * SettingsView.buttonSize + 3 * SettingsView.buttonSpacing,
                                 height: 4 * SettingsView.buttonSize + 3 * SettingsView.buttonSpacing))

        initializeButtons()
        
        backgroundColor = .blue
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: frame.width),
                                     heightAnchor.constraint(equalToConstant: frame.height)])
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
        
        setupButton(&resetAnimationButton,
                    systemName: "arrow.counterclockwise",
                    backgroundColor: UIColor(named: "BlueGrey500") ?? .gray,
                    targetAction: #selector(resetAnimationPressed))

        setupButton(&playPauseButton,
                    systemName: "pause.fill",
                    backgroundColor: UIColor(named: "BlueGrey300") ?? .gray,
                    targetAction: #selector(playPausePressed))

        setupButton(&labelsButton,
                    systemName: "textformat",
                    backgroundColor: UIColor(named: "BlueGrey100") ?? .gray,
                    targetAction: #selector(labelsPressed))

        settingsButton.frame = CGRect(x: buttonHomePosition.x,
                                      y: buttonHomePosition.y,
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
    private func setupButton(_ settingsSubButton: inout SettingsSubButton, systemName: String, backgroundColor: UIColor, targetAction: Selector) {
        settingsSubButton.button.frame = CGRect(x: self.buttonHomePosition.x,
                                                y: self.buttonHomePosition.y,
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
        guard showSettings else {
            //Only need to reposition if settings are expanded
            return
        }
        
        if UIDevice.current.orientation == .portrait {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                self.labelsButton.button.frame.origin.x = self.buttonHomePosition.x
                self.playPauseButton.button.frame.origin.x = self.buttonHomePosition.x
                self.resetAnimationButton.button.frame.origin.x = self.buttonHomePosition.x

                self.labelsButton.button.frame.origin.y = self.labelsButton.getYPositionInView(self)
                self.playPauseButton.button.frame.origin.y = self.playPauseButton.getYPositionInView(self)
                self.resetAnimationButton.button.frame.origin.y = self.resetAnimationButton.getYPositionInView(self)
            }, completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                self.labelsButton.button.frame.origin.y = self.buttonHomePosition.y
                self.playPauseButton.button.frame.origin.y = self.buttonHomePosition.y
                self.resetAnimationButton.button.frame.origin.y = self.buttonHomePosition.y

                self.labelsButton.button.frame.origin.x = self.labelsButton.getXPositionInView(self)
                self.playPauseButton.button.frame.origin.x = self.playPauseButton.getXPositionInView(self)
                self.resetAnimationButton.button.frame.origin.x = self.resetAnimationButton.getXPositionInView(self)
            }, completion: nil)
        }
    }
    
    
    // MARK: - Button Presses
    
    @objc private func settingsPressed() {
        showSettings = !showSettings
        
        if showSettings {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                self.settingsButton.transform = CGAffineTransform(rotationAngle: .pi)
            } completion: { _ in
                K.addHapticFeedback(withStyle: .medium)
            }

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                self.labelsButton.button.isHidden = false
                self.labelsButton.button.alpha = K.masterAlpha

                self.playPauseButton.button.isHidden = false
                self.playPauseButton.button.alpha = K.masterAlpha

                self.resetAnimationButton.button.isHidden = false
                self.resetAnimationButton.button.alpha = K.masterAlpha
                
                if UIDevice.current.orientation == .portrait {
                    self.labelsButton.button.frame.origin.y = self.labelsButton.getYPositionInView(self)
                    self.playPauseButton.button.frame.origin.y = self.playPauseButton.getYPositionInView(self)
                    self.resetAnimationButton.button.frame.origin.y = self.resetAnimationButton.getYPositionInView(self)
                }
                else {
                    self.labelsButton.button.frame.origin.x = self.labelsButton.getXPositionInView(self)
                    self.playPauseButton.button.frame.origin.x = self.playPauseButton.getXPositionInView(self)
                    self.resetAnimationButton.button.frame.origin.x = self.resetAnimationButton.getXPositionInView(self)
                }
            } completion: { _ in
                self.handlePlayPause()
            }
        }
        else {
            K.addHapticFeedback(withStyle: .medium)

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.settingsButton.transform = CGAffineTransform(rotationAngle: -.pi * 2)
            }, completion: nil)

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.labelsButton.button.alpha = 0.0
                self.playPauseButton.button.alpha = 0.0
                self.resetAnimationButton.button.alpha = 0.0
                
                if UIDevice.current.orientation == .portrait {
                    self.labelsButton.button.frame.origin.y = self.buttonHomePosition.y
                    self.playPauseButton.button.frame.origin.y = self.buttonHomePosition.y
                    self.resetAnimationButton.button.frame.origin.y = self.buttonHomePosition.y
                }
                else {
                    self.labelsButton.button.frame.origin.x = self.buttonHomePosition.x
                    self.playPauseButton.button.frame.origin.x = self.buttonHomePosition.x
                    self.resetAnimationButton.button.frame.origin.x = self.buttonHomePosition.x
                }
            } completion: { _ in
                self.labelsButton.button.isHidden = true
                self.playPauseButton.button.isHidden = true
                self.resetAnimationButton.button.isHidden = true
            }
        }
    }

    @objc private func labelsPressed() {
        K.addHapticFeedback(withStyle: .light)
        delegate?.settingsView(self, didPressLabelsButton: labelsButton)
    }
    
    @objc private func resetAnimationPressed() {
        K.addHapticFeedback(withStyle: .light)
        delegate?.settingsView(self, didPressResetAnimationButton: resetAnimationButton)
    }
    
    @objc private func playPausePressed() {
        K.addHapticFeedback(withStyle: .light)

        isPaused = !isPaused
        handlePlayPause()

        delegate?.settingsView(self, didPressPlayPauseButton: playPauseButton)
    }
    
    
    // MARK: - Helper Functions
    
    /**
     Helper function that produces a blinking animation when paused, and toggles the button image.
     */
    private func handlePlayPause() {
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
