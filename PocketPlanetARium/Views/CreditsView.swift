//
//  CreditsView.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 11/21/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

class CreditsView: UIView {
    let padding: CGFloat = 20
    let superView: UIView!
    let creditsLabel: UILabel!
    let creditsText = """
    Credits


    Art Assets
    Solar System Scope


    Sound FX (AudioJungle.net)
    3DHome
    audiopros
    BANT
    biggest
    HappyMusicHappySounds
    NewSoundFX
    royaltyfreesounds
    Stockwaves
    Stormwave Audio
    volkovsound


    Background Music
    The Hollywood Edge
    Phillip Mariani


    Created by
    Eddie Char


    © 2020
    """
    
    init(in superView: UIView) {
        self.superView = superView
        self.creditsLabel = UILabel(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: superView.frame.width,
                                                  height: superView.frame.height))
        super.init(frame: CGRect(x: 0,
                                 y: padding,
                                 width: superView.frame.width,
                                 height: superView.frame.height - 2 * padding))
        
        backgroundColor = K.color900
//        backgroundColor = .systemPink
        layer.masksToBounds = true
        
//        creditsLabel.backgroundColor = .purple
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: K.fontTitle, size: K.fontSizeMenu + 2)!,
            .foregroundColor: UIColor.getRandom(redRange: 175...255, greenRange: 175...255, blueRange: 175...255)]
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: K.fontFace, size: K.fontSizeMenu)!,
            .foregroundColor: UIColor.white]
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: true,
            .foregroundColor: K.colorIcyBlue]
        let creditsAttributedText = NSMutableAttributedString(string: creditsText, attributes: nil)
        creditsAttributedText.addAttributes(titleAttributes, range: NSRange(location: 0, length: 7))
        creditsAttributedText.addAttributes(textAttributes, range: NSRange(location: 7, length: creditsText.count - 7))
        creditsAttributedText.addAttributes(subtitleAttributes, range: NSRange(location: 7, length: 14))
        creditsAttributedText.addAttributes(subtitleAttributes, range: NSRange(location: 42, length: 26))
        creditsAttributedText.addAttributes(subtitleAttributes, range: NSRange(location: 191, length: 17))
        creditsAttributedText.addAttributes(subtitleAttributes, range: NSRange(location: 245, length: 10))
        print(creditsText.count)
        
        creditsLabel.attributedText = creditsAttributedText
        creditsLabel.textAlignment = .center
        creditsLabel.numberOfLines = 0
        addSubview(creditsLabel)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unable to load init!")
    }
    
    func play() {
        resetView()

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 30.0, delay: 0, options: .curveLinear, animations: {
            self.creditsLabel.frame.origin.y = -self.superView.frame.height
        }, completion: { _ in
            self.removeFromView()
        })
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        removeFromView()
    }
    
    private func resetView() {
        creditsLabel.frame.origin.y = superView.frame.height
        alpha = 0.0
        superView.addSubview(self)
    }
    
    private func removeFromView() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
}
