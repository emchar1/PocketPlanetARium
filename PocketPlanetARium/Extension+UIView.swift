//
//  Extension+UIView.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 2/10/24.
//  Copyright © 2024 Eddie Char. All rights reserved.
//

import UIKit

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
