//
//  PlanetPeekView.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/2/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

//******TEST
protocol PlanetPeekViewDelegate {
    func planetPeekView(_ controller: PlanetPeekView, willPerformSegue: Bool)
}





class PlanetPeekView: UIView {
    
    var planet: Planet?
    var planetTitle = UILabel()
    var planetDetails = UILabel()
    var instructions = UILabel()
    
    
    
    //******TEST
    var delegate: PlanetPeekViewDelegate?
    
    
    // MARK: - Initialization
    
    init(with planet: Planet) {
        let width = UIDevice.current.orientation.isPortrait ? 175 : 200
        let height = UIDevice.current.orientation.isPortrait ? 200 : 175
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))

        self.planet = planet
        planetTitle.text = planet.getName()
        planetDetails.text = planet.getDetails().details
        instructions.text = "(press hard to read more)"
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        clipsToBounds = true
        layer.cornerRadius = 10
        
        let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
        blurredEffectView.frame = bounds
        addSubview(blurredEffectView)


        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: frame.width),
                                     heightAnchor.constraint(equalToConstant: frame.height)])

        setupLabel(&planetTitle,
                   frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 40),
                   font: UIFont(name: K.fontTitle, size: K.fontSizePeekTitle),
                   alignment: .center,
                   backgroundColor: UIColor(named: K.color500) ?? .gray)
        
        setupLabel(&planetDetails,
                   frame: CGRect(x: frame.origin.x + 8, y: 40, width: frame.size.width - 8, height: frame.size.height - 70),
                   font: UIFont(name: K.fontFace, size: K.fontSizePeekDetails))
        
        setupLabel(&instructions,
                   frame: CGRect(x: frame.origin.x, y: frame.size.height - 30, width: frame.size.width, height: 30),
                   font: UIFont(name: K.fontFaceItalic, size: K.fontSizePeekDetails),
                   alignment: .center)
        
    }
    
    private func setupLabel(_ label: inout UILabel, frame: CGRect, font: UIFont?, alignment: NSTextAlignment = .left, backgroundColor: UIColor = .clear) {
        label.backgroundColor = backgroundColor
        label.font = font
        label.textColor = .white
        label.textAlignment = alignment
        label.numberOfLines = 0
        label.frame = frame
        
        addSubview(label)
    }
    
    
    // MARK: - Screen Display
    
    func show(in superView: UIView, at location: CGPoint) {
        var xCenter: CGFloat = 0 {
            didSet {
                if xCenter < frame.size.width / 2 + K.padding {
                    xCenter = frame.size.width / 2 + K.padding
                }
                else if xCenter > superView.frame.size.width - frame.size.width / 2 - K.padding {
                    xCenter = superView.frame.size.width - frame.size.width / 2 - K.padding
                }
                
            }
        }

        var yCenter: CGFloat = 0 {
            didSet {
                if yCenter < frame.size.height / 2 + K.padding {
                    yCenter = frame.size.height / 2 + K.padding
                }
                else if yCenter > superView.frame.size.height - K.padding {
                    yCenter = superView.frame.size.height - K.padding
                }
            }
        }

        //Need to set these separately because for some reason it doesn't trigger didSet when set initially.
        xCenter = location.x
        yCenter = location.y - (frame.size.height / 2) - (2 * K.padding)
        alpha = 0
        
        superView.addSubview(self)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = K.masterAlpha
        }, completion: nil)
        
        NSLayoutConstraint.activate([centerXAnchor.constraint(equalTo: superView.leadingAnchor, constant: xCenter),
                                     centerYAnchor.constraint(equalTo: superView.topAnchor, constant: yCenter)])
    }
    
    
    
    
    
    
    //******TEST
    func performSegue(to size: CGSize) {
        UIView.animate(withDuration: 5.0, delay: 0, options: .curveEaseInOut, animations: {
            self.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            self.alpha = 0.0
        }, completion: { _ in
            self.delegate?.planetPeekView(self, willPerformSegue: true)
            self.removeFromSuperview()
        })
    }
}
