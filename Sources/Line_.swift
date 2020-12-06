//
//  Line_.swift
//  Euclid
//
//  Created by Ioannis Kaliakatsos on 05.12.2020.
//  Copyright © 2020 Nick Lockwood. All rights reserved.
//

import Foundation

public struct Line_: Hashable, Codable {
    public let origin: Position
    public let direction: Direction
}

public extension Line_ {
    func distance(from point: Position) -> Double {
        let normalToLine = (point - origin).normal(to: direction)
        return normalToLine.norm
    }

    func contains(_ point: Position) -> Bool {
        return distance(from: point) < epsilon
    }
}
