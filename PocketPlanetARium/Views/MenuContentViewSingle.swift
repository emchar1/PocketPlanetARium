//
//  MenuContentViewSingle.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/22/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

class MenuContentViewSingle: UIView {
    var superView: MenuBezelView!
    var contentLabel: UILabel!
    var menuItem: MenuItem
    
    
    init(in superView: MenuBezelView, with menuItem: MenuItem) {
        self.menuItem = menuItem
        self.superView = superView
        
        super.init(frame: CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height))
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentLabel = UILabel()
        contentLabel.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        contentLabel.textColor = .white
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        contentLabel.text = menuItem.item.description
        contentLabel.alpha = 0.0
        
        superView.addSubview(contentLabel)
  
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([contentLabel.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor,
                                                                       constant: K.padding),
                                     contentLabel.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor,
                                                                           constant: K.padding),
                                     superView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: contentLabel.bottomAnchor,
                                                                                           constant: K.padding),
                                     superView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor,
                                                                                             constant: K.padding)])
    }
}
