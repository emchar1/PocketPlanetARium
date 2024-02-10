//
//  Extension+UILabel.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 2/10/24.
//  Copyright © 2024 Eddie Char. All rights reserved.
//

import UIKit

extension UILabel {
    /**
     Sets the attributedText property of UILabel with an attributed string that displays the characters of the text at the given indices in subscript.
     - parameters:
        - text: the input text
        - indicesOfSubscripts: index range to apply the subscript to
        - setAsSuperScript: if true, set as a superscript, else set as subscript (default)
     */
    func setAttributedTextWithSubscripts(text: String, indicesOfSubscripts: [Int], setAsSuperscript: Bool = false) {
        let font = self.font!
        let subscriptFont = font.withSize(font.pointSize * 0.7)
        let subscriptOffset = (setAsSuperscript == false ? -1 : 1) * font.pointSize * 0.3
        let attributedString = NSMutableAttributedString(string: text,
                                                         attributes: [.font : font])
        
        for index in indicesOfSubscripts {
            let range = NSRange(location: index, length: 1)
            attributedString.setAttributes([.font: subscriptFont,
                                            .baselineOffset: subscriptOffset],
                                           range: range)
        }
        
        self.attributedText = attributedString
    }
}
