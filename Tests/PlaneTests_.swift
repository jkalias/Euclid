//
//  PlaneTests_.swift
//  EuclidTests
//
//  Created by Ioannis Kaliakatsos on 05.12.2020.
//  Copyright © 2020 Nick Lockwood. All rights reserved.
//

@testable import Euclid
import XCTest

private let epsilon = Double.ulpOfOne.squareRoot()

class PlaneTests_: XCTestCase {
    func testHessNormalForm1() {
        let normalInput = Direction(x: 3, y: 1, z: 4)
        let plane = Plane_(
            point: Position(x: 1, y: 1, z: 2),
            normal: normalInput
        )
        XCTAssertEqual(plane.normal, normalInput)
    }

    func testHessNormalForm2() {
        let normalInput = Direction(x: -2, y: -3, z: -1)
        let plane = Plane_(
            point: Position(x: 1, y: 1, z: 2),
            normal: normalInput
        )
        XCTAssertEqual(plane.normal, normalInput.opposite)
    }

    func testDistanceFromPointPlaneThroughOrigin() {
        let normal = Direction(x: 1, y: -5, z: 7)
        let plane = Plane_(point: .origin, normal: normal)
        let point = plane.point + 10 * normal
        XCTAssertEqual(10, plane.distance(from: point), accuracy: epsilon)
    }

    func testDistanceFromPointWithOffsetFromOrigin() {
        let normal = Direction(x: 1, y: -5, z: 7)
        let plane = Plane_(
            point: Position(x: -3, y: 5, z: -7),
            normal: normal
        )
        let point = plane.point - 7 * normal
        XCTAssertEqual(7, plane.distance(from: point))
    }

    func testDistanceFromOrigin() {
        let plane = Plane_(
            point: Position(x: 1, y: 1, z: 1),
            normal: Direction(x: 1, y: 1, z: 1)
        )
        let distance = plane.distance(from: .origin)
        XCTAssertEqual(sqrt(3), distance, accuracy: epsilon)
    }

    func testDistanceXYPlane() {
        let plane = Plane_(point: Position(x: 10, y: 1), normal: .z)
        let distance = plane.distance(from: Position(x: -7, y: 3, z: 86))
        XCTAssertEqual(86, distance)
    }

    func testDistanceYZPlane() {
        let plane = Plane_(point: Position(y: 10, z: -3), normal: Direction.x.opposite)
        let distance = plane.distance(from: Position(x: -7, y: 3, z: 86))
        XCTAssertEqual(7, distance, accuracy: epsilon)
    }

    func testDistanceXZPlane() {
        let plane = Plane_(point: Position(x: -2, z: 8), normal: .y)
        let distance = plane.distance(from: Position(x: -7, y: 3, z: 86))
        XCTAssertEqual(3, distance)
    }

    func testContainsPoint() {
        let plane = Plane_(
            point: Position(x: 1, y: 1, z: 1),
            normal: Direction(x: 1, y: 1, z: 1)
        )
        XCTAssertFalse(plane.contains(.origin))
        XCTAssertTrue(plane.contains(plane.point))
    }

    func testIntersectWithParallelLine() {
        let line = Line_(origin: .origin, direction: Direction(x: 4, y: -5))
        let plane = Plane_(point: Position(x: -3, y: 2), normal: .z)
        XCTAssertNil(plane.intersection(with: line))
    }

    func testIntersectWithNormalLine() {
        let line = Line_(origin: Position(x: 1, y: 5, z: 60), direction: .z)
        let plane = Plane_(point: Position(x: -3, y: 2), normal: .z)
        let expected = Position(x: 1, y: 5)
        XCTAssertEqual(expected, plane.intersection(with: line)!)
    }

    func testIntersectionWithSkewedLine() {
        let line = Line_(
            origin: Position(x: 8, y: 8, z: 10),
            direction: Direction(x: 1, y: 1, z: 1)
        )
        let plane = Plane_(point: Position(x: 5, y: -7, z: 2), normal: .z)
        let expected = Position(x: 0, y: 0, z: 2)
        XCTAssertEqual(expected, plane.intersection(with: line)!)
    }
}
