//
//  MenuItem.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/13/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import Foundation

typealias MenuIndex = (index: Int, description: String, video: (name: String, type: String)?)

enum MenuItem: CaseIterable {
    case item0, item1, item2, item3, item4, item5
    
    var item: MenuIndex {
        switch self {
        case .item0:
            return (0, "Imagine the universe in the palm of your hand...\n\nWith the Pocket PlanetARium, you can do just that. Get up, move around, and discover the planets in Augmented Reality!", nil)
        case .item1:
            return (1, "When first launching the app, make sure to hold your device at a comfortable distance from your face, perpendicular to the floor.\n\nMake sure the lighting in the room is adequate to get the best experience.", nil)
        case .item2:
            return (2, "Pinch with two fingers to zoom in and out. The PlanetARium will scale from as small as 10 feet to as large as one mile in diameter!", (name: "planetPinch", type: "mov"))
        case .item3:
            return (3, "Tap and hold on any planet to get quick info. Continue to press harder to get more details on the planet.", (name: "planetHardPress", type: "mov"))
        case .item4:
            return (4, "Use the controls at the bottom right to toggle the sound on/off, display planet names, pause animation, and reset your location.\n\nIf you lose your positioning, reset your location to place you back in the center of the PlanetARium.", (name: "planetSettings", type: "mov"))
        case .item5:
            return (5, "View: Solar System\nSound: On\nHints on Startup: On", nil)
        }
    }
}
