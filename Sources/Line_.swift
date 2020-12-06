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

    func translated(by offset: Distance) -> Line_ {
        return Line_(point: point.translated(by: offset), direction: direction)
    }
}

public extension Line_ {
    func intersection(with _: Line_) -> Position? {
        return nil
    }
}

public extension Line_ {
    static func == (lhs: Line_, rhs: Line_) -> Bool {
        return lhs.direction.isColinear(to: rhs.direction)
            && lhs.contains(rhs.point)
    }
}
