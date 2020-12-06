//
//  Line_.swift
//  Euclid
//
//  Created by Ioannis Kaliakatsos on 05.12.2020.
//  Copyright © 2020 Nick Lockwood. All rights reserved.
//

import Foundation

public struct Line_: Hashable, Codable {
    public let point: Position
    public let direction: Direction
}

public extension Line_ {
    func distance(to other: Position) -> Distance {
        return (other - point).normal(to: direction)
    }

    func contains(_ other: Position) -> Bool {
        let d = distance(to: other).norm
        return d < epsilon
    }
}

public extension Line_ {
    static func == (lhs: Line_, rhs: Line_) -> Bool {
        return lhs.direction.isColinear(to: rhs.direction)
            && lhs.contains(rhs.point)
    }
}
