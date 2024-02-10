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
    //UserDefault Keys
    static let userDefaultsKey_SoundIsMuted = "SoundIsMuted"
    static let userDefaultsKey_HintsAreOff = "HintsAreOff"
    static let userDefaultsKey_LaunchedBefore = "LaunchedBefore"
    
    //Fonts
    static let fontTitle = "Age-Normal"
    static let fontFace = "Prime-Regular"
    static let fontFaceItalic = "Prime-Light"
    static let fontFaceSecondary = "PantonNarrowDemo-Black"
    static let fontFaceSecondaryItalic = "PantonNarrowDemo-BlackItalic"
    static let fontSizeMenu: CGFloat = UIDevice.isiPad ? 28 : 18
    static let fontSizePeekTitle: CGFloat = UIDevice.isiPad ? 28 : 18
    static let fontSizePeekDetails: CGFloat = UIDevice.isiPad ? 20 : 14
    
    //Color Themes
    static var colorName = "BlueGrey"
    static let color000 = UIColor(named: "\(K.colorName)000") ?? .gray
    static let color100 = UIColor(named: "\(K.colorName)100") ?? .gray
    static let color300 = UIColor(named: "\(K.colorName)300") ?? .gray
    static let color500 = UIColor(named: "\(K.colorName)500") ?? .gray
    static let color700 = UIColor(named: "\(K.colorName)700") ?? .gray
    static let color900 = UIColor(named: "\(K.colorName)900") ?? .gray
    static let colorIcyBlue = UIColor(red: 175, green: 255, blue: 255)
    


    /**
     Returns the screen ratio of the device.
     */
    static let screenRatio: CGFloat = UIScreen.main.bounds.height / UIScreen.main.bounds.width

    /**
     Typical padding. Can be used for views, cells, etc. Takes into account screen size to determine what the padding should be.
     */
    static let padding: CGFloat = 20//UIScreen.main.bounds.width / 18.75
    
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
