//
//  LineSegment_.swift
//  Euclid
//
//  Created by Ioannis Kaliakatsos on 06.12.2020.
//  Copyright © 2020 Nick Lockwood. All rights reserved.
//

import Foundation

public struct LineSegment_: Hashable, Codable {
    public let start: Position
    public let end: Position

    /// Creates a line segment from a start and end point
    public init?(start: Position, end: Position) {
        guard start != end else {
            return nil
        }
        self.start = start
        self.end = end
    }
}

public extension LineSegment_ {
    var direction: Direction {
        return (end - start).direction
    }

    func intersects(_ other: LineSegment_) -> Bool {
        let line1 = Line_(point: start, direction: direction)
        let line2 = Line_(point: other.start, direction: other.direction)
        guard let intersection = line1.intersection(with: line2) else {
            return false
        }
        return contains(unchecked: intersection) && other.contains(unchecked: intersection)
    }

    func contains(_ point: Position) -> Bool {
        if !(point - start).direction.isColinear(to: direction) {
            return false
        }
        return contains(unchecked: point)
    }

    private func contains(unchecked point: Position) -> Bool {
        let ratio = (point - start).dot(direction) / (end - start).norm
        return ratio >= -epsilon && ratio <= 1 + epsilon
    }
}
