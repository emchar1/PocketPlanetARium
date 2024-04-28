//
//  Extension+UIFont.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 4/28/24.
//  Copyright © 2024 Eddie Char. All rights reserved.
//

import UIKit

extension UIFont {
    //Fonts
    static let fontTitle = "Age-Normal"
    static let fontFace = "Prime-Regular"
    static let fontFaceItalic = "Prime-Light"
    static let fontFaceSecondary = "PantonNarrowDemo-Black"
    static let fontFaceSecondaryItalic = "PantonNarrowDemo-BlackItalic"
    
    //Sizes
    static let fontSizeMenu: CGFloat = UIDevice.isiPad ? 28 : 18
    static let fontSizePeekTitle: CGFloat = UIDevice.isiPad ? 28 : 18
    static let fontSizePeekDetails: CGFloat = UIDevice.isiPad ? 20 : 14
}
