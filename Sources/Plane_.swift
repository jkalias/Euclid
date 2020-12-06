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
public struct Plane_: Hashable, Codable {
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

public extension Plane_ {
    func distance(from position: Position) -> Double {
        let d = (position - point).projection(on: normal).norm
        return d
    }

    func contains(_ position: Position) -> Bool {
        return (position - point).isNormal(to: normal)
    }
}

public extension Plane_ {
    func intersection(with line: Line_) -> Position? {
        // https://en.wikipedia.org/wiki/Line–plane_intersection#Algebraic_form
        guard !line.direction.isNormal(to: normal) else {
            return nil
        }
        let dotproduct = line.direction.dot(normal)
        let d = (point - line.origin).dot(normal) / dotproduct
        let intersection = line.origin + d * line.direction
        return intersection
    }
}
