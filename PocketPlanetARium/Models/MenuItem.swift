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
    case item0, item1, item2, item3, item4, item5
    
    var item: MenuIndex {
        switch self {
        case .item0:
            return (0, "Imagine the universe in the palm of your hand...")
        case .item1:
            return (1, "Get up, move around, and discover the planets in augmented reality!")
        case .item2:
            return (2, "Pinch to zoom in and out.")
        case .item3:
            return (3, "Tap on a planet to get more info.")
        case .item4:
            return (4, "But remember to always be aware of your surroundings!")
        case .item5:
            return (5, "Menu items\nMenu items\nMenu items.")
        }
    }
}
