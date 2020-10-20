//
//  MenuItem.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/13/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import Foundation

typealias MenuIndex = (index: Int, description: String)

enum MenuItem: CaseIterable {
    case item0, item1, item2, item3, item4
    
    var item: MenuIndex {
        switch self {
        case .item0:
            return (0, "Imagine the universe in the palm of your hand... With the Pocket PlanetARium, you can do just that. Get up, move around, and discover the planets in augmented reality!")
        case .item1:
            return (1, "When first launching the app, make sure to hold your phone at a comfortable distance from your face, perpendicular to the floor. Make sure the lighting in the room is adequate to get the best experience.")
        case .item2:
            return (2, "Pinch with two fingers in the PlanetARium to zoom in and out. The PlanetARium will scale from as small as 10 feet to as large as one mile in diameter!")
        case .item3:
            return (3, "Tap on any planet to get quick info. Continue to press deeper to get more details on the planet.")
        case .item4:
            return (4, "View: Solar System\nSound: On\nHints on Startup: On")
        }
    }
}
