//
//  CodingTests.swift
//  EuclidTests
//
//  Created by Nick Lockwood on 20/11/2020.
//  Copyright © 2020 Nick Lockwood. All rights reserved.
//

@testable import Euclid
import XCTest

class CodingTests: XCTestCase {
    private func decode<T: Decodable>(_ string: String) throws -> T {
        let data = string.data(using: .utf8)!
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func encode<T: Encodable>(_ value: T) throws -> String {
        let data = try JSONEncoder().encode(value)
        return String(data: data, encoding: .utf8)!
    }

    // MARK: Angle

    func testDecodingAngle() {
        XCTAssertEqual(try decode("[2]"), [Angle.radians(2)])
    }

    func testDecodingAngle2() {
        XCTAssertEqual(try decode("{\"radians\": 2}"), Angle.radians(2))
    }

    func testDecodingAngle3() {
        XCTAssertEqual(try decode("{\"degrees\": 180}"), Angle.pi)
    }

    // MARK: Vector

    func testDecodingVector3() {
        XCTAssertEqual(try decode("[1, 2, 3]"), Vector(1, 2, 3))
    }

    func testDecodingVector2() {
        XCTAssertEqual(try decode("[1, 2]"), Vector(1, 2, 0))
    }

    func testDecodingKeyedVector() {
        XCTAssertEqual(try decode("{\"z\": 1}"), Vector(0, 0, 1))
    }

    func testDecodingInvalidVectors() {
        XCTAssertThrowsError(try decode("[1]") as Vector)
    }

    func testEncodingVector3() {
        XCTAssertEqual(try encode(Vector(1, 2, 3)), "[1,2,3]")
    }

    func testEncodingVector2() {
        XCTAssertEqual(try encode(Vector(1, 2, 0)), "[1,2]")
    }

    // MARK: Position

    func testDecodingPosition3() {
        XCTAssertEqual(try decode("[1, 2, 3]"), Position(x: 1, y: 2, z: 3))
    }

    func testDecodingPosition2() {
        XCTAssertEqual(try decode("[1, 2]"), Position(x: 1, y: 2, z: 0))
    }

    func testDecodingKeyedPosition() {
        XCTAssertEqual(try decode("{\"z\": 1}"), Position(z: 1))
    }

    func testDecodingInvalidPositions() {
        XCTAssertThrowsError(try decode("[1]") as Position)
    }

    func testEncodingPosition3() {
        XCTAssertEqual(try encode(Position(x: 1, y: 2, z: 3)), "[1,2,3]")
    }

    func testEncodingPosition2() {
        XCTAssertEqual(try encode(Position(x: 1, y: 2, z: 0)), "[1,2]")
    }

    // MARK: Distance

    func testDecodingDistance3() {
        XCTAssertEqual(try decode("[1, 2, 3]"), Distance(x: 1, y: 2, z: 3))
    }

    func testDecodingDistance2() {
        XCTAssertEqual(try decode("[1, 2]"), Distance(x: 1, y: 2, z: 0))
    }

    func testDecodingKeyedDistance() {
        XCTAssertEqual(try decode("{\"z\": 1}"), Distance(z: 1))
    }

    func testDecodingInvalidDistances() {
        XCTAssertThrowsError(try decode("[1]") as Distance)
    }

    func testEncodingDistance3() {
        XCTAssertEqual(try encode(Distance(x: 1, y: 2, z: 3)), "[1,2,3]")
    }

    func testEncodingDistance2() {
        XCTAssertEqual(try encode(Distance(x: 1, y: 2, z: 0)), "[1,2]")
    }

    // MARK: Direction

    func testDecodingDirection3() {
        XCTAssertEqual(try decode("[0.5, 0.5, 0.707106781186548]"), Direction(x: 1 / 2, y: 1 / 2, z: 1 / sqrt(2)))
    }

    func testDecodingDirection2() {
        XCTAssertEqual(try decode("[1, 2]"), Direction(x: 1, y: 2, z: 0))
    }

    func testDecodingKeyedDirection() {
        XCTAssertEqual(try decode("{\"z\": 1}"), Direction.z)
    }

    func testDecodingInvalidDirections() {
        XCTAssertThrowsError(try decode("[1]") as Direction)
    }

    func testEncodingDirection3() {
        #if os(Linux)
        XCTAssertEqual(
            try encode(Direction(x: 1, y: 2, z: 3)),
            "[0.267261241912424,0.534522483824849,0.801783725737273]"
        )
        #else
        XCTAssertEqual(
            try encode(Direction(x: 1, y: 2, z: 3)),
            "[0.2672612419124244,0.53452248382484879,0.80178372573727319]"
        )
        #endif
    }

    func testEncodingDirection2() {
        #if os(Linux)
        XCTAssertEqual(try encode(Direction(x: 1, y: 2)), "[0.447213595499958,0.894427190999916]")
        #else
        XCTAssertEqual(try encode(Direction(x: 1, y: 2)), "[0.44721359549995793,0.89442719099991586]")
        #endif
    }

    // MARK: Vertex

    func testDecodingVertex() {
        XCTAssertEqual(try decode("""
        {
            "position": [1, 2, 2],
            "normal": [1, 0, 0],
            "texcoord": [0, 1]
        }
        """), Vertex(Vector(1, 2, 2), Vector(1, 0, 0), Vector(0, 1)))
    }

    func testDecodingVertexWithoutTexcoord() {
        XCTAssertEqual(try decode("""
        {
            "position": [1, 2, 2],
            "normal": [1, 0, 0]
        }
        """), Vertex(Vector(1, 2, 2), Vector(1, 0, 0), .zero))
    }

    func testDecodingVertexWithInvalidNormal() {
        XCTAssertEqual(try decode("""
        {
            "position": [1, 2, 2],
            "normal": [1, 2, 2]
        }
        """), Vertex(
            Vector(1, 2, 2),
            Vector(0.3333333333333333, 0.6666666666666666, 0.6666666666666666),
            .zero
        ))
    }

    // MARK: Plane

    func testDecodingKeyedPlane() {
        XCTAssertEqual(try decode("""
        {
            "normal": [0, 0, 1],
            "w": 1
        }
        """), Plane(normal: Vector(0, 0, 1), w: 1))
    }

    func testDecodingUnkeyedPlane() {
        XCTAssertEqual(try decode("[0, 0, 1, 0]"), Plane(normal: Vector(0, 0, 1), w: 0))
    }

    func testEncodingPlane() {
        XCTAssertEqual(try encode(Plane(normal: Vector(0, 0, 1), w: 0)), "[0,0,1,0]")
    }

    // MARK: Plane_

    func testDecodingKeyedPlane_() {
        XCTAssertEqual(try decode("""
        {
            "normal": [0, 0, 1],
            "point": [1, 2, 3]
        }
        """), Plane_(point: Position(x: 1, y: 2, z: 3), normal: .z))
    }

    func testDecodingUnkeyedPlane_() {
        XCTAssertEqual(
            try decode("[1, 2, 3, 4, 5, 6]"),
            Plane_(point: Position(x: 4, y: 5, z: 6), normal: Direction(x: 1, y: 2, z: 3))
        )
    }

    func testEncodingPlane_() {
        XCTAssertEqual(try encode(Plane_(point: Position(x: 1, y: 2, z: 3), normal: .z)), "[0,0,1,1,2,3]")
    }

    // MARK: Polygon

    func testDecodingPolygon() {
        XCTAssertEqual(try decode("""
        {
            "vertices": [
                {
                    "position": [0, 0],
                    "normal": [0, 0, 1],
                },
                {
                    "position": [1, 0],
                    "normal": [0, 0, 1],
                },
                {
                    "position": [1, 1],
                    "normal": [0, 0, 1],
                }
            ]
        }
        """), Polygon([
            Vertex(Vector(0, 0), Vector(0, 0, 1)),
            Vertex(Vector(1, 0), Vector(0, 0, 1)),
            Vertex(Vector(1, 1), Vector(0, 0, 1)),
        ]))
    }

    func testKeylessPolygon() {
        XCTAssertEqual(try decode("""
        [
            {
                "position": [0, 0],
                "normal": [0, 0, 1],
            },
            {
                "position": [1, 0],
                "normal": [0, 0, 1],
            },
            {
                "position": [1, 1],
                "normal": [0, 0, 1],
            }
        ]
        """), Polygon([
            Vertex(Vector(0, 0), Vector(0, 0, 1)),
            Vertex(Vector(1, 0), Vector(0, 0, 1)),
            Vertex(Vector(1, 1), Vector(0, 0, 1)),
        ]))
    }

    func testDecodingPolygonWithPlane() {
        XCTAssertEqual(
            try decode("""
            {
                "vertices": [
                    {
                        "position": [0, 0],
                        "normal": [0, 0, 1],
                    },
                    {
                        "position": [1, 0],
                        "normal": [0, 0, 1],
                    },
                    {
                        "position": [1, 1],
                        "normal": [0, 0, 1],
                    }
                ],
                "plane": [0, 0, 1, 0]
            }
            """),
            Polygon(
                unchecked: [
                    Vertex(Vector(0, 0), Vector(0, 0, 1)),
                    Vertex(Vector(1, 0), Vector(0, 0, 1)),
                    Vertex(Vector(1, 1), Vector(0, 0, 1)),
                ],
                plane: Plane(normal: Vector(0, 0, 1), w: 0)
            )
        )
    }

    // MARK: Material

    func testEncodingPolygonWithNilMaterial() throws {
        let polygon = Polygon(shape: .square(), material: nil)
        let encoded = try encode(polygon)
        let decoded = try decode(encoded) as Euclid.Polygon
        XCTAssertNil(decoded.material)
    }

    func testEncodingPolygonWithStringMaterial() throws {
        let polygon = Polygon(shape: .square(), material: "foo")
        let encoded = try encode(polygon)
        let decoded = try decode(encoded) as Euclid.Polygon
        XCTAssertEqual(decoded.material, polygon?.material)
    }

    func testEncodingPolygonWithIntMaterial() throws {
        let polygon = Polygon(shape: .square(), material: 5)
        let encoded = try encode(polygon)
        let decoded = try decode(encoded) as Euclid.Polygon
        XCTAssertEqual(decoded.material, polygon?.material)
    }

    func testEncodingPolygonWithDataMaterial() throws {
        let polygon = Polygon(shape: .square(), material: "foo".data(using: .utf8))
        let encoded = try encode(polygon)
        let decoded = try decode(encoded) as Euclid.Polygon
        XCTAssertEqual(decoded.material, polygon?.material)
    }

    func testEncodingPolygonWithUnsupportedMaterial() throws {
        struct Foo: Hashable {}
        let polygon = Polygon(shape: .square(), material: Foo())
        XCTAssertThrowsError(try encode(polygon))
    }

    func testEncodingPolygonWithOSColorMaterial() throws {
        #if canImport(UIKit)
        let polygon = Polygon(shape: .square(), material: UIColor.red)
        XCTAssertEqual(decoded.material, polygon?.material)
        #elseif canImport(AppKit)
        let polygon = Polygon(shape: .square(), material: NSColor.red)
        #else
        let polygon = Polygon(shape: .square())
        #endif
        let encoded = try encode(polygon)
        let decoded = try decode(encoded) as Euclid.Polygon
        XCTAssertEqual(decoded.material, polygon?.material)
    }

    // MARK: Mesh

    func testDecodingMesh() {
        XCTAssertEqual(
            try decode("""
            {
                "polygons": [
                    {
                        "vertices": [
                            {
                                "position": [0, 0],
                                "normal": [0, 0, 1],
                            },
                            {
                                "position": [1, 0],
                                "normal": [0, 0, 1],
                            },
                            {
                                "position": [1, 1],
                                "normal": [0, 0, 1],
                            }
                        ]
                    }
                ]
            }
            """),
            Mesh([
                Polygon(
                    unchecked: [
                        Vertex(Vector(0, 0), Vector(0, 0, 1)),
                        Vertex(Vector(1, 0), Vector(0, 0, 1)),
                        Vertex(Vector(1, 1), Vector(0, 0, 1)),
                    ],
                    plane: Plane(normal: Vector(0, 0, 1), w: 0)
                ),
            ])
        )
    }

    // MARK: PathPoint

    func testDecodingPathPoint3() {
        XCTAssertEqual(try decode("[1, 2, 3]"), PathPoint.point(1, 2, 3))
    }

    func testDecodingPathPoint2() {
        XCTAssertEqual(try decode("[1, 2]"), PathPoint.point(1, 2))
    }

    func testDecodingCurvedUnkeyedPathPoint3() {
        XCTAssertEqual(try decode("[1, 2, 3, true]"), PathPoint.curve(1, 2, 3))
    }

    func testDecodingCurvedPathPoint2() {
        XCTAssertEqual(try decode("[1, 2, true]"), PathPoint.curve(1, 2))
    }

    // MARK: Path

    func testDecodingSimplePath() {
        XCTAssertEqual(try decode("[[1, 2, 3], [2, 0]]"), Path([.point(1, 2, 3), .point(2, 0)]))
    }

    func testDecodingKeyedPath() {
        XCTAssertEqual(try decode("""
        { "points": [[1, 2, 3], [2, 0]] }
        """), Path([.point(1, 2, 3), .point(2, 0)]))
    }

    func testDecodingSubpath() {
        XCTAssertEqual(try decode("""
        {
            "subpaths": [
                [[1, 2, 3], [2, 0]]
            ]
        }
        """), Path(subpaths: [Path([.point(1, 2, 3), .point(2, 0)])]))
    }

    // MARK: Rotation

    func testDecodingIdentityRotation() {
        XCTAssertEqual(try decode("[]"), Rotation.identity)
        XCTAssertEqual(try decode("{}"), Rotation.identity)
    }

    func testDecodingRollRotation() {
        XCTAssertEqual(try decode("[1]"), Rotation(roll: .radians(1)))
        XCTAssertEqual(try decode("""
        { "radians": 1 }
        """), Rotation(roll: .radians(1)))
    }

    func testDecodingPitchYawRollRotation() {
        XCTAssertEqual(
            try decode("[1, 2, 3]"),
            Rotation(pitch: .radians(1), yaw: .radians(2), roll: .radians(3))
        )
    }

    func testDecodingAxisAngleRotation() {
        XCTAssertEqual(try decode("[0, 0, -1, 1]"), Rotation(roll: .radians(-1)))
        XCTAssertEqual(try decode("""
        { "axis": [0, 0, -1], "radians": 1 }
        """), Rotation(roll: .radians(-1)))
    }

    func testEncodeAndDecodingRotation() throws {
        let rotation = Rotation(axis: Vector(1, 0, 0), angle: .radians(2))!
        let encoded = try encode(rotation)
        XCTAssert(try rotation.isEqual(to: decode(encoded)))
    }
}
