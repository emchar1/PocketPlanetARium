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
    func touchesBegan(in point: CGPoint)
    func touchesEnded()
}

class TapPlanetGesture: UIGestureRecognizer {
    var tapDelegate: TapPlanetGestureDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
//        guard let touch = touches.first, touches.count == 1 else {
//            return
//        }
//
//        let location = touch.location(in: self.view)
//        let hitResults = self.view?.hitTest(location, with: nil)
//
//        guard hitResults.count > 0,
//              let result = hitResults.first,
//              let planetNodeName = result.node.name,
//              let tappedPlanet = planetarium.getPlanet(withName: planetNodeName) else {
//            return
//        }
//        
        
        guard let touch = touches.first else {
            print("No touches.first found")
            return
        }
        
        tapDelegate?.touchesBegan(in: touch.location(in: self.view))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        tapDelegate?.touchesEnded()
    }
}
