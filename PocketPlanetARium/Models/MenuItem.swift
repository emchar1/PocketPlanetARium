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
            return (0, "This is page zero")
        case .item1:
            return (1, "This is page one")
        case .item2:
            return (2, "This is page two")
        case .item3:
            return (3, "This is page three")
        case .item4:
            return (4, "This is page four")
        }
    }
}
