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
    var menuContentView: MenuContentView?
    
    init(in superView: UIView) {
        self.superView = superView
        super.init(frame: .zero)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
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
        label.text = "Constructing PlanetARium..."
        label.alpha = 0.0
        addSubview(label)
    }
    
    func addContentView(in controller: MenuContentViewDelegate, with menuItem: MenuItem) {
        menuContentView = MenuContentView(in: self, with: menuItem)
        menuContentView!.delegate = controller
        addSubview(menuContentView!)
    }
}
