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
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 8

        let attributedString = NSMutableAttributedString(string: menuItem.item.description)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        contentLabel = UILabel()
        contentLabel.font = UIFont(name: UIFont.fontFace, size: UIFont.fontSizeMenu)
        contentLabel.attributedText = attributedString
        contentLabel.textColor = .white
        contentLabel.numberOfLines = 0
        contentLabel.alpha = 0.0
        
        superView.addSubview(contentLabel)
  
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([contentLabel.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor,
                                                                       constant: K.ScreenDimensions.padding),
                                     contentLabel.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor,
                                                                           constant: K.ScreenDimensions.padding),
                                     superView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: contentLabel.bottomAnchor,
                                                                                           constant: K.ScreenDimensions.padding),
                                     superView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor,
                                                                                             constant: K.ScreenDimensions.padding)])
    }
}
