//
//  LineSegmentTests_.swift
//  EuclidTests
//
//  Created by Ioannis Kaliakatsos on 06.12.2020.
//  Copyright © 2020 Nick Lockwood. All rights reserved.
//

@testable import Euclid
import XCTest

class LineSegmentTests_: XCTestCase {
    func testConstructorEqualPoints() {
        XCTAssertNil(LineSegment_(start: .origin, end: .origin))
    }

    func testDirection() {
        let p1 = Position(x: 1, y: 2, z: 3)
        let p2 = Position(x: 5, y: 1, z: 9)
        let segment = LineSegment_(start: p1, end: p2)!
        XCTAssertEqual(Direction(x: 4, y: -1, z: 6), segment.direction)
    }

    func testIntersectionOutsideOfLegalBounds() {
        let segment1 = LineSegment_(
            start: .origin,
            end: Position(x: 5)
        )!
        let segment2 = LineSegment_(
            start: Position(x: 1, y: 1),
            end: Position(x: 3, y: 8)
        )!
        XCTAssertFalse(segment1.intersects(segment2))
    }

    func testIntersectionOnLegalBoundsButOnDifferentPlanes() {
        let segment1 = LineSegment_(
            start: .origin,
            end: Position(x: 5)
        )!
        let segment2 = LineSegment_(
            start: Position(x: 1, y: -1, z: 10),
            end: Position(x: 1, y: 8, z: 10)
        )!
        XCTAssertFalse(segment1.intersects(segment2))
    }

    func testIntersection() {
        let segment1 = LineSegment_(
            start: .origin,
            end: Position(x: 5)
        )!
        let segment2 = LineSegment_(
            start: Position(x: 1, y: -1),
            end: Position(x: 1, y: 8)
        )!
        XCTAssertTrue(segment1.intersects(segment2))
    }

    func testIntersectionOnEnd() {
        let segment1 = LineSegment_(
            start: .origin,
            end: Position(x: 5)
        )!
        let segment2 = LineSegment_(
            start: Position(x: 5),
            end: Position(x: 1, y: 8)
        )!
        XCTAssertTrue(segment1.intersects(segment2))
    }

    func testIntersectionOnStart() {
        let segment1 = LineSegment_(
            start: .origin,
            end: Position(x: 5)
        )!
        let segment2 = LineSegment_(
            start: .origin,
            end: Position(x: 1, y: 8)
        )!
        XCTAssertTrue(segment1.intersects(segment2))
    }
}
