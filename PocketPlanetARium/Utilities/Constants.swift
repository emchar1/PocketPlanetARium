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
    struct ScreenDimensions {
        /**
         Returns the device's screen size
         */
        static let screenSize: CGSize = UIScreen.main.bounds.size
        
        /**
         Returns the screen ratio of the device.
         */
        static let screenRatio: CGFloat = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        
        /**
         Typical padding. Can be used for views, cells, etc. Takes into account screen size to determine what the padding should be.
         */
        static let padding: CGFloat = 20//UIScreen.main.bounds.width / 18.75
        
        /**
         Padding taking into account banner ad at the bottom. As per the documentation guide (https://developers.google.com/admob/ios/banner) the aspect ratio is similar to 320x50 industry standard.
         */
        static let paddingWithAd: CGFloat = UIScreen.main.bounds.height * (50 / 320) * 0.5 + (UIDevice.isiPad ? 20 : 10)
    }
    
    struct Math {
        /**
         Period of a planetary orbit.
         */
        static let period = 2 * Float.pi
                
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
