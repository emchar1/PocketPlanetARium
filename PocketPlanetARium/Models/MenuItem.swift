//
//  MenuItem.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/13/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import Foundation

enum MenuItem: CaseIterable {
    case item0, item1, item2, item3, item4

    static let firstItemIndex: Int = 0
    static let lastItemIndex: Int = 4
    static let firstItem: MenuItem = item0
    static let lastItem: MenuItem = item4

    typealias MenuIndex = (index: Int, description: String, video: (name: String, type: String)?)

    var item: MenuIndex {
        let menuIndex: MenuIndex
        
        switch self {
        case .item0:
            menuIndex = (0, "Imagine the universe in the palm of your hand...\n\nWith the Pocket PlanetARium, you can do just that. Get up, move around, and discover the planets in Augmented Reality - a truly immersive experience!", nil)
        case .item1:
            menuIndex = (1, "In order to enjoy the PlanetARium, you will need to allow the app access to your camera. To allow access swipe left, then tap OK on the pop-up window.", nil)
        case .item2:
            menuIndex = (2, "This app can also deliver personalized ads to you. To enable this feature swipe left, then tap Allow on the pop-up window.", nil)
        case .item3:
            menuIndex = (3, "Thank you for your responses!\n\nWhen first launching the app, make sure to hold your device at a comfortable distance from your face, perpendicular to the floor.\n\nMake sure the lighting in the room is adequate to get the best experience.", nil)
        case .item4:
            menuIndex = (4, "View: Solar System\n\nSound: On\n\nHints: On\n\nStartup: On\n\nCredits", nil) //Filler needed so that the menu page will be included
        }
        
        return menuIndex
    }
    
    
}
