//
//  Constants.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 9/20/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

/**
 A struct of Constants for commonly used properties and functions.
 */
struct K {
    /**
     Period of a planetary orbit.
     */
    static let period = 2 * Float.pi
    
    /**
     Master alpha transparency to apply across all views for a uniform appearance.
     */
    static let masterAlpha: CGFloat = 1.0
    
    /**
    Calculates the hypotenuse of a polygon with up to 3 sides.
    - parameters:
       - x: side #1
       - y: side #2
       - z: side #3
    - returns: the hypotenuse in meters as a Float
    */
    static func hypotenuse(x: Float = 0, y: Float = 0, z: Float = 0) -> Float {
        return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
    }
    
    /**
    Converts degrees value to radians.
    - parameter degrees: The degree value
    - returns: The radians value
    */
    static func degToRad(_ degrees: Float) -> Float {
        return degrees * Float.pi / 180
    }

    /**
    Converts radians value to degrees.
    - parameter radians: The radians value
    - returns: The degrees value
    */
    static func radToDeg(_ radians: Float) -> Float {
        return 180 * radians / Float.pi
    }
    
    /**
     Adds a haptic feedback vibration.
     - parameter style: style of feedback to produce
     */
    static func addHapticFeedback(withStyle style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

}


extension Comparable {
    /**
     Imposes a lower and upper limit to a value.
     - parameters:
        - min: lower limit
        - max: upper limit
     */
    func clamp(min minValue: Self, max maxValue: Self) -> Self {
        return max(min(self, maxValue), minValue)
    }
}


extension UIColor {
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
}


extension UIView {
    /**
     Applies a blinking animation to a view, i.e. a UIButton.
     - parameters:
        - duration: length of the blink
        - delay: initial delay time before blinking begins
        - alpha: transparency of the blink in range of 0 to 1.
     */
    func blink(duration: TimeInterval = 0.8, delay: TimeInterval = 0.8, alpha: CGFloat = 0.1) {
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn, .autoreverse, .repeat, .allowUserInteraction], animations: {
            self.alpha = alpha
        })
    }
    
    /**
     Applies a blinking animation to a view, i.e. a UIButton.
     - parameter rate: length and delay of the blink
     */
    func blink(rate: TimeInterval = 0.8) {
        blink(duration: rate, delay: rate, alpha: 0.1)
    }
    
    /**
     Returns the UIView to its original state, i.e. non-blink.
     - parameter alpha: original alpha level to return the view to
     */
    func stopBlink(to alpha: CGFloat = K.masterAlpha) {
        self.layer.removeAllAnimations()
        self.alpha = alpha
    }
}
