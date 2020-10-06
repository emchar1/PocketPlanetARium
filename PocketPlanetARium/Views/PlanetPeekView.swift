//
//  PlanetPeekView.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/2/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

class PlanetPeekView: UIView {
    
    var planet: Planet?
    var planetTitle = UILabel()
    var planetDetails = UILabel()
    var instructions = UILabel()
    
    
    // MARK: - Initialization
    
    init(with planet: Planet) {
        super.init(frame: CGRect(x: 0, y: 0, width: 175, height: 200))

        self.planet = planet
        planetTitle.text = planet.getName()
        planetDetails.text = planet.getDetails().details
        instructions.text = "(deep press for more)"
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        clipsToBounds = true
        layer.cornerRadius = 10
        backgroundColor = UIColor(named: "BlueGrey900") ?? .gray

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: frame.width),
                                     heightAnchor.constraint(equalToConstant: frame.height)])
        
        setupLabel(&planetTitle,
                   frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 40),
                   font: UIFont(name: "Futura", size: 18.0),
                   alignment: .center)
        
        setupLabel(&planetDetails,
                   frame: CGRect(x: frame.origin.x + 8, y: 40, width: frame.size.width - 8, height: frame.size.height - 80),
                   font: UIFont(name: "Futura", size: 14.0))
        
        setupLabel(&instructions,
                   frame: CGRect(x: frame.origin.x, y: frame.size.height - 40, width: frame.size.width, height: 40),
                   font: UIFont(name: "Futura Medium Italic", size: 14.0),
                   alignment: .center)
    }
    
    private func setupLabel(_ label: inout UILabel, frame: CGRect, font: UIFont?, alignment: NSTextAlignment = .left) {
        label.backgroundColor = .clear
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
                if xCenter < frame.size.width / 2 {
                    xCenter = frame.size.width / 2
                }
                else if xCenter > superView.frame.size.width - frame.size.width / 2 {
                    xCenter = superView.frame.size.width - frame.size.width / 2
                }
                
            }
        }

        var yCenter: CGFloat = 0 {
            didSet {
                if yCenter < frame.size.height / 2 {
                    yCenter = frame.size.height / 2
                }
                else if yCenter > superView.frame.size.height {
                    yCenter = superView.frame.size.height
                }
            }
        }

        //Need to set these separately because for some reason it doesn't trigger didSet when set initially.
        xCenter = location.x
        yCenter = location.y - frame.size.height / 2
        alpha = 0
        
        superView.addSubview(self)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
            self.alpha = 1.0
        }, completion: nil)
        
        NSLayoutConstraint.activate([centerXAnchor.constraint(equalTo: superView.leadingAnchor, constant: xCenter),
                                     centerYAnchor.constraint(equalTo: superView.topAnchor, constant: yCenter)])
    }
}
