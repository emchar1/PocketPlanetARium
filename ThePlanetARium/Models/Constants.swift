//
//  Constants.swift
//  ThePlanetARium
//
//  Created by Eddie Char on 9/20/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

struct K {
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
