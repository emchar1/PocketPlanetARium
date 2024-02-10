//
//  Extension+UIColor.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 2/10/24.
//  Copyright © 2024 Eddie Char. All rights reserved.
//

import UIKit

extension UIColor {
    /**
     Generates a random color
     */
    static var randomColor: UIColor {
        return UIColor(red: Int.random(in: 0...255), green: Int.random(in: 0...255), blue: Int.random(in: 0...255))
    }
    
    var descriptionBits: String {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            
            return "UIColor: (R: \(iRed), G: \(iGreen), B: \(iBlue), A: \(fAlpha))"
        }
        
        return "Invalid color!"
    }

    /**
     Allows you to initialize a color with no alpha parameter.
     - parameters:
        - red: red component from 0 to 255
        - green: green component from 0 to 255
        - blue: blue component from 0 to, wait for it, 255
     */
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    /**
     Allows you to initialize a color using a hex value.
     - parameter rgb: the hex value in the format 0xFFFFF
    */
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    /**
     Generates a random color within a restricted range of RGB values.
     - parameters:
        - redRange: R range to clamp inputs to within 0...255.
        - greenRange: G range to clamp inputs to within 0...255.
        - blueRange: B range to clamp inputs to within 0...255.
     - My descriptions are lame. I need to get better at documentaton... 🤪
     */
    static func getRandom(redRange: ClosedRange<Int> = 0...255,
                                    greenRange: ClosedRange<Int> = 0...255,
                                    blueRange: ClosedRange<Int> = 0...255) -> UIColor {
        let redRangeNormalized = redRange.clamped(to: 0...255)
        let greenRangeNormalized = greenRange.clamped(to: 0...255)
        let blueRangeNormalized = blueRange.clamped(to: 0...255)
        
        return UIColor(red: Int.random(in: redRangeNormalized), green: Int.random(in: greenRangeNormalized), blue: Int.random(in: blueRangeNormalized))
    }
}
