//
//  Extension+UserDefaults.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 1/21/21.
//  Copyright © 2021 Eddie Char. All rights reserved.
//

import Foundation

extension UserDefaults {
    static let userDefaultsKey_SoundIsMuted = "SoundIsMuted"
    static let userDefaultsKey_HintsAreOff = "HintsAreOff"
    static let userDefaultsKey_LaunchedBefore = "LaunchedBefore2.0"
    
    enum Key: String {
        case reviewWorthyActionCount
        case lastReviewRequestAppVersion
    }
    
    func integer(forKey key: Key) -> Int {
        return integer(forKey: key.rawValue)
    }
    
    func string(forKey key: Key) -> String? {
        return string(forKey: key.rawValue)
    }
    
    func set(_ integer: Int, forKey key: Key) {
        set(integer, forKey: key.rawValue)
    }
    
    func set(_ object: Any?, forKey key: Key) {
        set(object, forKey: key.rawValue)
    }
}
