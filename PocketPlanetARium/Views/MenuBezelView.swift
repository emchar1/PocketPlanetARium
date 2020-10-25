//
//  MenuBezelView.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/16/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

class MenuBezelView: UIView {
    var superView: UIView!
    var label: UILabel!
    var subLabel: UILabel?
    var menuContentView: UIView?
    
    init(in superView: UIView, showSubLabel: Bool) {
        self.superView = superView
        super.init(frame: .zero)
        
        setupView(showSubLabel: showSubLabel)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView(showSubLabel: Bool) {
        let bezelRatio: CGFloat = 612/335
        let possibleWidth = superView.frame.width - 2 * K.padding
        let possibleHeight = superView.frame.height - 6 * K.padding
        let width = bezelRatio < K.screenRatio ? possibleWidth : possibleHeight / bezelRatio
        let height = bezelRatio < K.screenRatio ? possibleWidth * bezelRatio : possibleHeight
        
        frame = CGRect(x: 0, y: 0, width: width, height: height)
        center = CGPoint(x: superView.frame.width / 2, y: superView.frame.height / 2)
        backgroundColor = UIColor(named: K.color900) ?? .gray
        
        layer.cornerRadius = 18
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10
        
        label = UILabel(frame: frame)
        label.frame.origin = .zero
        label.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        label.textColor = .white
        label.textAlignment = .center
        label.text = audioManager.launchMessage
        label.numberOfLines = 0
        label.alpha = 0.0
        addSubview(label)
        
        if showSubLabel {
            subLabel = UILabel(frame: CGRect(x: 0, y: height - 40, width: width, height: 40))
            subLabel!.font = UIFont(name: K.fontFace, size: K.fontSizePeekDetails)
            subLabel!.textColor = .white
            subLabel!.textAlignment = .center
            subLabel!.text = "(Swipe left to proceed)"
            addSubview(subLabel!)
        }
        
    }
    
    func addContentView(in controller: MenuContentViewLaunchDelegate, with menuItem: MenuItem) {
        if menuItem == MenuItem.lastItem {
            menuContentView = MenuContentViewLaunch(in: self, with: menuItem)

            if let menuContentView = menuContentView as? MenuContentViewLaunch {
                menuContentView.delegate = controller
            }
        }
        else {
            if menuItem.item.video == nil {
                menuContentView = MenuContentViewSingle(in: self, with: menuItem)
            }
            else {
                menuContentView = MenuContentView(in: self, with: menuItem)
            }
        }
        
        addSubview(menuContentView!)
    }
}
