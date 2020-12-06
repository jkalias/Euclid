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
        XCTAssertEqual(10, plane.distance(to: point).norm, accuracy: epsilon)
    }

    func testDistanceFromPointWithOffsetFromOrigin() {
        let normal = Direction(x: 1, y: -5, z: 7)
        let plane = Plane_(
            point: Position(x: -3, y: 5, z: -7),
            normal: normal
        )
        let point = plane.point - 7 * normal
        XCTAssertEqual(7, plane.distance(to: point).norm)
    }

    func testDistanceFromOrigin() {
        let plane = Plane_(
            point: Position(x: 1, y: 1, z: 1),
            normal: Direction(x: 1, y: 1, z: 1)
        )
        let distance = plane.distance(to: .origin).norm
        XCTAssertEqual(sqrt(3), distance, accuracy: epsilon)
    }

    func testDistanceXYPlane() {
        let plane = Plane_(point: Position(x: 10, y: 1), normal: .z)
        let distance = plane.distance(to: Position(x: -7, y: 3, z: 86)).norm
        XCTAssertEqual(86, distance)
    }

    func testDistanceYZPlane() {
        let plane = Plane_(point: Position(y: 10, z: -3), normal: Direction.x.opposite)
        let distance = plane.distance(to: Position(x: -7, y: 3, z: 86)).norm
        XCTAssertEqual(7, distance, accuracy: epsilon)
    }

    func testDistanceXZPlane() {
        let plane = Plane_(point: Position(x: -2, z: 8), normal: .y)
        let distance = plane.distance(to: Position(x: -7, y: 3, z: 86)).norm
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
        let line = Line_(point: .origin, direction: Direction(x: 4, y: -5))
        let plane = Plane_(point: Position(x: -3, y: 2), normal: .z)
        XCTAssertNil(plane.intersection(with: line))
    }

    func testIntersectWithNormalLine() {
        let line = Line_(point: Position(x: 1, y: 5, z: 60), direction: .z)
        let plane = Plane_(point: Position(x: -3, y: 2), normal: .z)
        let expected = Position(x: 1, y: 5)
        XCTAssertEqual(expected, plane.intersection(with: line)!)
    }

    func testIntersectionWithSkewedLine() {
        let line = Line_(
            point: Position(x: 8, y: 8, z: 10),
            direction: Direction(x: 1, y: 1, z: 1)
        )
        let plane = Plane_(point: Position(x: 5, y: -7, z: 2), normal: .z)
        let expected = Position(x: 0, y: 0, z: 2)
        XCTAssertEqual(expected, plane.intersection(with: line)!)
    }

    func testIntersectionWithParallelPlane() {
        XCTAssertNil(Plane_.xy.intersection(with: Plane_.xy.translate(by: Distance(z: 1))))
    }

    func testIntersectWithPlaneResultsInXAxis() {
        let intersection = Plane_.xy.intersection(with: .xz)
        XCTAssertEqual(Line_(point: .origin, direction: .x), intersection)
    }

    func testIntersectWithPlaneResultsInYAxis() {
        let intersection = Plane_.xy.intersection(with: .yz)
        XCTAssertEqual(Line_(point: .origin, direction: .y), intersection)
    }

    func testIntersectWithPlaneResultsInZAxis() {
        let intersection = Plane_.yz.intersection(with: .xz)
        XCTAssertEqual(Line_(point: .origin, direction: .z), intersection)
    }

    func testIntersectionWithPlaneResultsInSkewedLine() {
        let plane1 = Plane_(
            point: .origin,
            normal: Direction(x: -1, y: -1, z: 1)
        )
        let plane2 = Plane_(
            point: Position(x: 5, y: 5),
            normal: Direction(x: 1, y: -1)
        )
        let expected = Line_(point: .origin, direction: Direction(x: 1, y: 1, z: 2))
        let intersection12 = plane1.intersection(with: plane2)
        XCTAssertEqual(expected, intersection12)

        let intersection21 = plane2.intersection(with: plane1)
        XCTAssertEqual(expected, intersection21)
    }
}
