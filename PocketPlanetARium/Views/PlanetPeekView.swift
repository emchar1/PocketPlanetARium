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
    let planetTitle = UILabel()
    let planetDetails = UILabel()
    let instructions = UILabel()
    
    
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
        backgroundColor = UIColor(rgb: 0x212121)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: frame.width),
                                     heightAnchor.constraint(equalToConstant: frame.height)])
        
        planetTitle.backgroundColor = .clear
        planetTitle.font = UIFont(name: "Futura", size: 18.0)
        planetTitle.textAlignment = .center
        planetTitle.textColor = .white
        planetTitle.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 40)
        addSubview(planetTitle)
        
        planetDetails.backgroundColor = .clear
        planetDetails.font = UIFont(name: "Futura", size: 14.0)
        planetDetails.numberOfLines = 0
        planetDetails.textColor = .white
        planetDetails.frame = CGRect(x: frame.origin.x + 8, y: 40, width: frame.size.width - 8, height: frame.size.height - 80)
        addSubview(planetDetails)

        instructions.backgroundColor = .clear
        instructions.font = UIFont(name: "Futura Medium Italic", size: 14.0)
        instructions.textAlignment = .center
        instructions.textColor = .white
        instructions.frame = CGRect(x: frame.origin.x, y: frame.size.height - 40, width: frame.size.width, height: 40)
        addSubview(instructions)
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
