//
//  Constants.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 9/20/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit


// MARK: - K struct

/**
 A struct of Constants for commonly used properties and functions.
 */
struct K {
    static let userDefaultsKey_SoundIsMuted = "SoundIsMuted"
    static let userDefaultsKey_HintsAreOff = "HintsAreOff"
    
    static let fontFace = "Futura"
    static let fontFaceItalic = "Futura Medium Italic"
    static let fontSizeMenu: CGFloat = 18
    static let fontSizePeekTitle: CGFloat = 18
    static let fontSizePeekDetails: CGFloat = 14
    
    static var color = "BlueGrey"
    static let color000 = "\(K.color)000"
    static let color100 = "\(K.color)100"
    static let color300 = "\(K.color)300"
    static let color500 = "\(K.color)500"
    static let color700 = "\(K.color)700"
    static let color900 = "\(K.color)900"


    /**
     Returns the screen ratio of the device.
     */
    static let screenRatio: CGFloat = UIScreen.main.bounds.height / UIScreen.main.bounds.width

    /**
     Typical padding. Can be used for views, cells, etc. Takes into account screen size to determine what the padding should be.
     */
    static let padding: CGFloat = UIScreen.main.bounds.width / 18.75
    
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


// MARK: - Class Extensions

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
    func stopBlink(to alpha: CGFloat) {
        self.layer.removeAllAnimations()
        self.alpha = alpha
    }
    
}


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
