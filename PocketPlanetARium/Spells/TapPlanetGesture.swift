//
//  TapPlanetGestures.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/30/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import Foundation
import UIKit

protocol TapPlanetGestureDelegate {
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent)
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent)
}

class TapPlanetGesture: UIGestureRecognizer {
    var tapDelegate: TapPlanetGestureDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        tapDelegate?.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        tapDelegate?.touchesEnded(touches, with: event)
    }
}
