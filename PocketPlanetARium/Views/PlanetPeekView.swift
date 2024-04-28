//
//  PlanetPeekView.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/2/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

protocol PlanetPeekViewDelegate: AnyObject {
    func didTapPeekView()
}

class PlanetPeekView: UIView {
    
    var planet: Planet?
    var planetTitle = UILabel()
    var planetDetails = UILabel()
    var instructions = UILabel()
    var timer: Timer!

    weak var delegate: PlanetPeekViewDelegate?
    
    
    // MARK: - Initialization
    
    init(with planet: Planet) {
        let width = UIDevice.isiPad ? 250 : 175
        let height = UIDevice.isiPad ? 275 : 200
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))

        self.planet = planet
        planetTitle.text = planet.getName()
        planetDetails.text = planet.getDetails().details
        instructions.text = "(Tap to read more)"
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        clipsToBounds = true
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false

        let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
        blurredEffectView.frame = bounds
        
        addSubview(blurredEffectView)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: frame.width),
            heightAnchor.constraint(equalToConstant: frame.height)
        ])
        
        setupLabel(&planetTitle,
                   frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 40),
                   font: UIFont(name: UIFont.fontTitle, size: UIFont.fontSizePeekTitle),
                   alignment: .center,
                   backgroundColor: UIColor.color500)
        
        setupLabel(&planetDetails,
                   frame: CGRect(x: 8, y: 48, width: frame.size.width - 16, height: frame.size.height - 78),
                   font: UIFont(name: UIFont.fontFace, size: UIFont.fontSizePeekDetails),
                   alignment: .justified)
        
        setupLabel(&instructions,
                   frame: CGRect(x: frame.origin.x, y: frame.size.height - 30, width: frame.size.width, height: 30),
                   font: UIFont(name: UIFont.fontFaceItalic, size: UIFont.fontSizePeekDetails),
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
    
    
    // MARK: - UITouch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTapPeekView()
    }
    
    
    // MARK: - Screen Display
    
    func show(in superView: UIView, at location: CGPoint) {
        timer = Timer()
        
        var xCenter: CGFloat = 0 {
            didSet {
                if xCenter < frame.size.width / 2 + K.ScreenDimensions.padding {
                    xCenter = frame.size.width / 2 + K.ScreenDimensions.padding
                }
                else if xCenter > superView.frame.size.width - frame.size.width / 2 - K.ScreenDimensions.padding {
                    xCenter = superView.frame.size.width - frame.size.width / 2 - K.ScreenDimensions.padding
                }
                
            }
        }

        var yCenter: CGFloat = 0 {
            didSet {
                if yCenter < frame.size.height / 2 + K.ScreenDimensions.padding {
                    yCenter = frame.size.height / 2 + K.ScreenDimensions.padding
                }
                else if yCenter > superView.frame.size.height - K.ScreenDimensions.padding {
                    yCenter = superView.frame.size.height - K.ScreenDimensions.padding
                }
            }
        }

        //Need to set these separately because for some reason it doesn't trigger didSet when set initially.
        xCenter = location.x
        yCenter = location.y - (frame.size.height / 2) - (2 * K.ScreenDimensions.padding)
        alpha = 0
        
        superView.addSubview(self)
                
        timer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(unshow), userInfo: nil, repeats: false)

        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = UIColor.masterAlpha
        }, completion: nil)
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superView.leadingAnchor, constant: xCenter),
            centerYAnchor.constraint(equalTo: superView.topAnchor, constant: yCenter)
        ])
    }
    
    @objc func unshow() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
