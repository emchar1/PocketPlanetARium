//
//  PopPlanetDetailsGesture.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 11/1/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import Foundation
import UIKit

protocol PopPlanetDetailsGestureDelegate: AnyObject {
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent)
}

class PopPlanetDetailsGesture: UIGestureRecognizer {
    weak var popDelegate: PopPlanetDetailsGestureDelegate?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        popDelegate?.touchesMoved(touches, with: event)
    }
}
