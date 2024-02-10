//
//  Extension+Comparable.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 2/10/24.
//  Copyright © 2024 Eddie Char. All rights reserved.
//

import Foundation

extension Comparable {
    /**
     Imposes a lower and upper limit to a value.
     - parameters:
        - min: lower limit
        - max: upper limit
     */
    func clamp(min minValue: Self, max maxValue: Self) -> Self {
        return max(min(self, maxValue), minValue)
    }
}
