//
//  Plane_.swift
//  Euclid
//
//  Created by Ioannis Kaliakatsos on 05.12.2020.
//  Copyright © 2020 Nick Lockwood. All rights reserved.
//

import Foundation

/// A plane described in its Hesse normal form
/// https://en.wikipedia.org/wiki/Hesse_normal_form
public struct Plane_: Hashable {
    public let point: Position
    public let normal: Direction

    public init(point: Position, normal: Direction) {
        self.point = point

        let isHesseNormalForm = (point - .origin)
            .projection(on: normal)
            .direction
            .isParallel(to: normal)

        self.normal = isHesseNormalForm
            ? normal
            : normal.opposite
    }
}

extension Plane_: Codable {
    private enum CodingKeys: CodingKey {
        case normal, point
    }

    public init(from decoder: Decoder) throws {
        if var container = try? decoder.unkeyedContainer() {
            let x = try container.decode(Double.self)
            let y = try container.decode(Double.self)
            let z = try container.decode(Double.self)
            normal = Direction(x: x, y: y, z: z)
            let px = try container.decode(Double.self)
            let py = try container.decode(Double.self)
            let pz = try container.decode(Double.self)
            point = Position(x: px, y: py, z: pz)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            normal = try container.decode(Direction.self, forKey: .normal)
            point = try container.decode(Position.self, forKey: .point)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(normal.x)
        try container.encode(normal.y)
        try container.encode(normal.z)
        try container.encode(point.x)
        try container.encode(point.y)
        try container.encode(point.z)
    }
}

public extension Plane_ {
    static let xy = Plane_(point: .origin, normal: .z)
    static let xz = Plane_(point: .origin, normal: .y)
    static let yz = Plane_(point: .origin, normal: .x)
}

public extension Plane_ {
    func translated(by offset: Distance) -> Plane_ {
        return Plane_(
            point: point.translated(by: offset),
            normal: normal
        )
    }
}

public extension Plane_ {
    func distance(to position: Position) -> Distance {
        return (position - point).projection(on: normal)
    }

    func contains(_ position: Position) -> Bool {
        let d = distance(to: position).norm
        return d <= epsilon
    }
}

public extension Plane_ {
    func intersection(with line: Line_) -> Position? {
        // https://en.wikipedia.org/wiki/Line–plane_intersection#Algebraic_form
        guard !line.direction.isNormal(to: normal) else {
            return nil
        }
        let dotproduct = line.direction.dot(normal)
        let d = (point - line.point).dot(normal) / dotproduct
        let intersection = line.point + d * line.direction
        return intersection
    }

    func intersection(with plane: Plane_) -> Line_? {
        // https://en.wikipedia.org/wiki/Plane_(geometry)#Line_of_intersection_between_two_planes
        guard !normal.isColinear(to: plane.normal) else {
            return nil
        }

        let h1 = distance(to: .origin).norm
        let h2 = plane.distance(to: .origin).norm

        let dotProduct = normal.dot(plane.normal)
        let denominator = 1 - dotProduct * dotProduct

        let c1 = (h1 - h2 * dotProduct) / denominator
        let c2 = (h2 - h1 * dotProduct) / denominator

        let linePoint = Position(c1 * normal + c2 * plane.normal)
        let lineDirection = normal.cross(plane.normal)
        return Line_(point: linePoint, direction: lineDirection)
    }
}

public extension Plane_ {
    static func == (lhs: Plane_, rhs: Plane_) -> Bool {
        return lhs.normal.isColinear(to: rhs.normal)
            && lhs.contains(rhs.point)
    }
}
