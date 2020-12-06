//
//  LineTests_.swift
//  EuclidTests
//
//  Created by Ioannis Kaliakatsos on 05.12.2020.
//  Copyright © 2020 Nick Lockwood. All rights reserved.
//

@testable import Euclid
import XCTest

private let epsilon = Double.ulpOfOne.squareRoot()

class LineTests_: XCTestCase {
    func testDistanceFromPoint() {
        let line = Line_(point: Position(y: 1), direction: Direction(x: 1, y: 2, z: 3))
        let point = Position(x: 8, y: -2)
        let distance = line.distance(to: point)
        XCTAssertEqual(
            Distance(
                x: 7.8571428571428567,
                y: -3.2857142857142856,
                z: -0.4285714285714286
            ),
            distance
        )
        XCTAssertFalse(line.contains(point))
    }

    func testDistanceFromPointVerticalLine() {
        let line = Line_(point: Position(x: 10), direction: .z)
        let point = Position(y: -2, z: 5)
        let distance = line.distance(to: point).norm
        XCTAssertEqual(sqrt(104), distance)
        XCTAssertFalse(line.contains(point))
    }

    func testDistanceFromObliqueLine() {
        let line = Line_(point: .origin, direction: Direction(x: sqrt(3), y: 1))
        let point = Position(x: 2)
        let distance = line.distance(to: point).norm
        XCTAssertEqual(1, distance)
        XCTAssertFalse(line.contains(point))
    }

    func testDistanceFromOrigin() {
        let line = Line_(point: .origin, direction: Direction(x: sqrt(3), y: 1))
        let point = line.point
        let distance = line.distance(to: point).norm
        XCTAssertEqual(0, distance)
        XCTAssertTrue(line.contains(point))
    }

    func testDistanceFromPointContained() {
        let line = Line_(point: .origin, direction: Direction(x: sqrt(3), y: 1))
        let point = line.point + 5 * line.direction
        let distance = line.distance(to: point).norm
        XCTAssertEqual(0, distance, accuracy: epsilon)
        XCTAssertTrue(line.contains(point))
    }

    func testIntersectionWithParallelLine() {
        let line = Line_(point: .origin, direction: .x)
        XCTAssertNil(line.intersection(with: line.translated(by: Distance(y: 1))))
    }

    func testIntersectionWithSelf() {
        let line = Line_(point: .origin, direction: .x)
        XCTAssertNil(line.intersection(with: line))
    }

    func testIntersectionNormalLinesWithSamePoint() {
        XCTAssertEqual(.origin, Line_.x.intersection(with: .y))
    }

    func testIntersectionNormalLinesWithDifferentPoint() {
        XCTAssertEqual(.origin, Line_.x.translated(by: Distance(x: 2)).intersection(with: .y))
    }

    func testIntersectionWithLine() {
        let line1 = Line_(point: Position(y: 2), direction: .x)
        let line2 = Line_(point: Position(x: 9, y: 3, z: 1), direction: Direction(x: 1, y: 1, z: 1))
        let expected = Position(x: 8, y: 2)
        let intersection = line1.intersection(with: line2)
        XCTAssertEqual(expected, intersection)
    }
}
