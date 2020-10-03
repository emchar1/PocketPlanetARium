//
//  PlanetPeekView.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/2/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

class PlanetPeekView: UIView {

    
    // MARK: - Initialization
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 400, height: 200))

//        translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: frame.width),
//                                     heightAnchor.constraint(equalToConstant: frame.height)])
        

        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
