import Foundation
import Darwin
import Sight
import XCTest

final class CanvasTests: XCTestCase {
  func testInstanceNoValue() {
    let canvas = Canvas<Any>(minBounds: .zero, maxBounds: .one, minimumCellSize: 10)
    XCTAssertNil(canvas.closestValue(to: .zero))
    XCTAssertNil(canvas.closestValue(to: .one))
    XCTAssertNil(canvas.closestValue(to: .zero / 2))
  }

  func testOneValue() {
    let canvas = Canvas<Int>(minBounds: .zero, maxBounds: .one, minimumCellSize: 10)
    let value = 1
    let valuePosition = SIMD2<Float>.one / 2

    canvas.add(value, at: valuePosition)

    XCTAssertEqual(value, canvas.closestValue(to: valuePosition))
  }

  func testFindValueOnEdge() {
    let minCellSize: Float = 1
    let canvas = Canvas<Int>(minBounds: .zero, maxBounds: .one * 10, minimumCellSize: minCellSize)
    let value = 1
    let valuePosition = SIMD2<Float>(x: 1, y: 0) * 10

    canvas.add(value, at: valuePosition)

    let outOfAreaSearchPosition = valuePosition - SIMD2<Float>(x: 1, y: 0) * minCellSize / 2 - 0.00001
    XCTAssertNil(canvas.closestValue(to: outOfAreaSearchPosition))

    let edgeSearchPosition = valuePosition - SIMD2<Float>(x: 1, y: 0) * minCellSize / 2
    XCTAssertNotNil(canvas.closestValue(to: edgeSearchPosition))
  }
}
