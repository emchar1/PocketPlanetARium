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
    let heightOffset: CGFloat = 200
    let superView: UIView!
    let creditsLabel: UILabel!
    let creditsText = """
    Credits


    Art Assets
    Solar System Scope
    Icons8


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
                                                  height: superView.frame.height + heightOffset))
        super.init(frame: CGRect(x: 0,
                                 y: padding,
                                 width: superView.frame.width,
                                 height: superView.frame.height - 2 * padding))
        
        backgroundColor = K.color900
        layer.masksToBounds = true
        
        let shadowAttribute = NSShadow()
        shadowAttribute.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowAttribute.shadowColor = UIColor.darkGray
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: K.fontTitle, size: K.fontSizeMenu + 4)!,
            .foregroundColor: UIColor.getRandom(redRange: 175...255, greenRange: 175...255, blueRange: 175...255),
            .shadow: shadowAttribute]
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: K.fontFace, size: K.fontSizeMenu)!,
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle]
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: true,
            .foregroundColor: K.colorIcyBlue]
        
        let creditsAttributedText = NSMutableAttributedString(string: creditsText, attributes: nil)
        creditsAttributedText.addAttributes(textAttributes, range: NSRange(location: 0, length: creditsText.count))
        creditsAttributedText.addAttributes(titleAttributes, range: NSRange(location: 0, length: 7))
        creditsAttributedText.addAttributes(subtitleAttributes, range: NSRange(location: 7, length: 14))
        creditsAttributedText.addAttributes(subtitleAttributes, range: NSRange(location: 49, length: 26))
        creditsAttributedText.addAttributes(subtitleAttributes, range: NSRange(location: 198, length: 17))
        creditsAttributedText.addAttributes(subtitleAttributes, range: NSRange(location: 252, length: 10))
        
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
    
    /**
     Plays the credits page animation.
     */
    func play() {
        resetView()

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 30.0, delay: 0, options: .curveLinear, animations: {
            self.creditsLabel.frame.origin.y = -self.superView.frame.height - self.heightOffset
        }, completion: { _ in
            self.removeFromView()
        })
    }
    
    /**
     Handles screen taps, i.e. remove credits page view.
     */
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        removeFromView()
    }
    
    /**
     Resets the location of the credits page, resets the alpha channel to 0, and adds the view to the superView.
     */
    private func resetView() {
        creditsLabel.frame.origin.y = superView.frame.height
        alpha = 0.0
        superView.addSubview(self)
    }
    
    /**
     Resets the page (with animation) and removes it from the superview.
     */
    private func removeFromView() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
}
