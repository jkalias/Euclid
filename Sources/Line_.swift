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
    static let x = Line_(point: .origin, direction: .x)
    static let y = Line_(point: .origin, direction: .y)
    static let z = Line_(point: .origin, direction: .z)
}

public extension Line_ {
    func intersection(with line: Line_) -> Position? {
        guard !direction.isColinear(to: line.direction) else {
            // parallel lines, no intersection
            return nil
        }

        let commonPlaneNormal = direction.cross(line.direction)
        let commonPlane = Plane_(point: point, normal: commonPlaneNormal)

        if !commonPlane.contains(line.point) {
            // lines are skewed, no interesection
            return nil
        }

        let plane1 = Plane_(
            point: point,
            normal: commonPlaneNormal.cross(direction)
        )
        let plane2 = Plane_(
            point: line.point,
            normal: commonPlaneNormal.cross(line.direction)
        )
        guard let planeIntersection = plane1.intersection(with: plane2) else {
            // should never land here...
            return nil
        }

        let intersection = commonPlane.intersection(with: planeIntersection)

        return intersection
    }
}

public extension Line_ {
    static func == (lhs: Line_, rhs: Line_) -> Bool {
        return lhs.direction.isColinear(to: rhs.direction)
            && lhs.contains(rhs.point)
    }
}
