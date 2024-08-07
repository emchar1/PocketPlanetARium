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
    let heightOffset: CGFloat = 0
    let superView: UIView!
    let creditsLabel: UILabel!
    let creditsText = """
    Credits


    Art Assets
    Solar System Scope
    Freepik
    Icons8


    Sound FX (AudioJungle.net)
    Audio Pros
    BANT
    Happy Music Happy Sounds
    NewSoundFX
    Stockwaves
    Stormwave Audio
    Volkov Sound


    Background Music
    The Hollywood Edge
    Phillip Mariani


    Created by
    Eddie Char
    
    
    
    © 2024 5Play Apps, LLC
    All rights reserved.
    """
    
    init(in superView: UIView) {
        self.superView = superView
        self.creditsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height * 1.5 + heightOffset))
        
        super.init(frame: CGRect(x: 0, y: padding, width: superView.frame.width, height: superView.frame.height - 2 * padding))
        
        backgroundColor = UIColor.color900
        layer.masksToBounds = true
        
        let shadowAttribute = NSShadow()
        shadowAttribute.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowAttribute.shadowColor = UIColor.darkGray
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: UIFont.fontTitle, size: UIFont.fontSizeMenu + 4)!,
            .foregroundColor: UIColor.getRandom(redRange: 175...255, greenRange: 175...255, blueRange: 175...255),
            .shadow: shadowAttribute]
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: UIFont.fontFace, size: UIFont.fontSizeMenu)!,
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle]
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: true,
            .foregroundColor: UIColor.colorIcyBlue]
        
        let creditsAttributedText = NSMutableAttributedString(string: creditsText, attributes: nil)
        creditsAttributedText.addAttributes(textAttributes, range: NSRange(location: 0, length: creditsText.count))
        creditsAttributedText.addAttributes(titleAttributes, range: NSRange(location: 0, length: 7))
        creditsAttributedText.addAttributes(subtitleAttributes, range: NSRange(location: 10, length: 10))
        creditsAttributedText.addAttributes(subtitleAttributes, range: NSRange(location: 57, length: 26))
        creditsAttributedText.addAttributes(subtitleAttributes, range: NSRange(location: 178, length: 16))
        creditsAttributedText.addAttributes(subtitleAttributes, range: NSRange(location: 232, length: 10))
        
        creditsLabel.attributedText = creditsAttributedText
        creditsLabel.textAlignment = .center
        creditsLabel.numberOfLines = 0
        addSubview(creditsLabel)
        
        let gradientHeight: CGFloat = 80
        let gradientTop = CAGradientLayer()
        gradientTop.frame = CGRect(x: 0, y: 0, width: frame.width, height: gradientHeight)
        gradientTop.colors = [UIColor.color900.cgColor, UIColor.color900.withAlphaComponent(0.0).cgColor]
        gradientTop.locations = [0, 1.0]
        layer.addSublayer(gradientTop)
        
        let gradientBottom = CAGradientLayer()
        gradientBottom.frame = CGRect(x: 0, y: frame.height - gradientHeight, width: frame.width, height: gradientHeight)
        gradientBottom.colors = [UIColor.color900.withAlphaComponent(0.0).cgColor, UIColor.color900.cgColor]
        gradientBottom.locations = [0, 1.0]
        layer.addSublayer(gradientBottom)
                
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
        
        UIView.animate(withDuration: 37.5, delay: 0, options: .curveLinear, animations: {
            self.creditsLabel.frame.origin.y = -self.creditsLabel.frame.size.height
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
