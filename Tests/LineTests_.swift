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
    func testDistanceFromPointHorizontalLine() {
        let line = Line_(origin: Position(y: 1), direction: .x)
        let point = Position(x: 8, y: -2)
        let distance = line.distance(from: point)
        XCTAssertEqual(3, distance)
        XCTAssertFalse(line.contains(point))
    }

    func testDistanceFromPointVerticalLine() {
        let line = Line_(origin: Position(x: 10), direction: .z)
        let point = Position(y: -2, z: 5)
        let distance = line.distance(from: point)
        XCTAssertEqual(sqrt(104), distance)
        XCTAssertFalse(line.contains(point))
    }

    func testDistanceFromObliqueLine() {
        let line = Line_(origin: .origin, direction: Direction(x: sqrt(3), y: 1))
        let point = Position(x: 2)
        let distance = line.distance(from: point)
        XCTAssertEqual(1, distance)
        XCTAssertFalse(line.contains(point))
    }

    func testDistanceFromOrigin() {
        let line = Line_(origin: .origin, direction: Direction(x: sqrt(3), y: 1))
        let point = line.origin
        let distance = line.distance(from: point)
        XCTAssertEqual(0, distance)
        XCTAssertTrue(line.contains(point))
    }

    func testDistanceFromPointContained() {
        let line = Line_(origin: .origin, direction: Direction(x: sqrt(3), y: 1))
        let point = line.origin + 5 * line.direction
        let distance = line.distance(from: point)
        XCTAssertEqual(0, distance, accuracy: epsilon)
        XCTAssertTrue(line.contains(point))
    }
}
