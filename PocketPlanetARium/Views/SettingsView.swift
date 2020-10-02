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
        CGPoint(x: self.frame.origin.x, y: self.frame.height - SettingsView.buttonSize)
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
        
    init() {
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: SettingsView.buttonSize,
                                 height: 4 * SettingsView.buttonSize + 3 * SettingsView.buttonSpacing))

        initializeButtons()
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: frame.width),
                                     heightAnchor.constraint(equalToConstant: frame.height)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeButtons() {
        settingsButton.frame = CGRect(x: buttonHomePosition.x,
                                      y: buttonHomePosition.y,
                                      width: SettingsView.buttonSize,
                                      height: SettingsView.buttonSize)
        settingsButton.setBackgroundImage(UIImage(named: "settings"), for: .normal)
        settingsButton.tintColor = .white
        settingsButton.layer.shadowOpacity = 0.4
        settingsButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        settingsButton.alpha = K.masterAlpha
        settingsButton.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
        self.addSubview(settingsButton)
                
        setupButton(&labelsButton,
                    systemName: "textformat",
                    backgroundColor: UIColor(rgb: 0xD0D8DC),
                    targetAction: #selector(labelsPressed))
        
        setupButton(&playPauseButton,
                    systemName: "pause.fill",
                    backgroundColor: UIColor(rgb: 0x93A4AD),
                    targetAction: #selector(playPausePressed))

        setupButton(&resetAnimationButton,
                    systemName: "arrow.counterclockwise",
                    backgroundColor: UIColor(rgb: 0x667C89),
                    targetAction: #selector(resetAnimationPressed))
        
    }

    private func setupButton(_ settingsSubButton: inout SettingsSubButton, systemName: String, backgroundColor: UIColor, targetAction: Selector) {
        settingsSubButton.button.frame = CGRect(x: self.buttonHomePosition.x,
                                                y: self.buttonHomePosition.y,
                                                width: SettingsView.buttonSize,
                                                height: SettingsView.buttonSize)
        settingsSubButton.button.setImage(UIImage(systemName: systemName), for: .normal)
        settingsSubButton.button.tintColor = .white
        settingsSubButton.button.alpha = K.masterAlpha
        settingsSubButton.button.backgroundColor = backgroundColor
        settingsSubButton.button.layer.cornerRadius = 0.5 * SettingsView.buttonSize
        settingsSubButton.button.clipsToBounds = true
        settingsSubButton.button.isHidden = true
        settingsSubButton.button.addTarget(self, action: targetAction, for: .touchUpInside)
        self.addSubview(settingsSubButton.button)
    }
    
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
                self.labelsButton.button.frame.origin.y = self.labelsButton.getYPositionInView(self)
                self.labelsButton.button.alpha = K.masterAlpha

                self.playPauseButton.button.isHidden = false
                self.playPauseButton.button.frame.origin.y = self.playPauseButton.getYPositionInView(self)
                self.playPauseButton.button.alpha = K.masterAlpha

                self.resetAnimationButton.button.isHidden = false
                self.resetAnimationButton.button.frame.origin.y = self.resetAnimationButton.getYPositionInView(self)
                self.resetAnimationButton.button.alpha = K.masterAlpha
            } completion: { _ in
                self.handlePause()
            }
        }
        else {
            K.addHapticFeedback(withStyle: .medium)

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.settingsButton.transform = CGAffineTransform(rotationAngle: -.pi * 2)
            }, completion: nil)

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.labelsButton.button.frame.origin.y = self.buttonHomePosition.y
                self.labelsButton.button.alpha = 0.0

                self.playPauseButton.button.frame.origin.y = self.buttonHomePosition.y
                self.playPauseButton.button.alpha = 0.0

                self.resetAnimationButton.button.frame.origin.y = self.buttonHomePosition.y
                self.resetAnimationButton.button.alpha = 0.0
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
    
    @objc private func playPausePressed() {
        K.addHapticFeedback(withStyle: .light)

        isPaused = !isPaused
        handlePause()

        delegate?.settingsView(self, didPressPlayPauseButton: playPauseButton)
    }
    
    @objc private func resetAnimationPressed() {
        K.addHapticFeedback(withStyle: .light)
        delegate?.settingsView(self, didPressResetAnimationButton: resetAnimationButton)
    }
    
    func handlePause() {
        if isPaused {
            playPauseButton.button.blink()
            playPauseButton.button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        else {
            playPauseButton.button.stopBlink()
            playPauseButton.button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
}
