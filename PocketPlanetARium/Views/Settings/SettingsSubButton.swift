//
//  SettingsSubButton.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 2/10/24.
//  Copyright © 2024 Eddie Char. All rights reserved.
//

import UIKit


// MARK: - Settings Sub Button Struct

struct SettingsSubButton {
    var button = UIButton()
    var buttonOrder: CGFloat
    
    func getCollapsedPosition(in view: UIView) -> CGPoint {
        return CGPoint(x: view.frame.width - SettingsView.buttonSize,
                       y: view.frame.height - SettingsView.buttonSize)
    }
    
    func getExpandedPosition(in view: UIView) -> CGPoint {
        let offset = (buttonOrder + 1) * SettingsView.buttonSize + buttonOrder * SettingsView.buttonSpacing
        
        return CGPoint(x: view.frame.width - offset,
                       y: view.frame.height - offset)
    }
}
