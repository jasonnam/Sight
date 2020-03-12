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

    // Just out of area position.
    let outOfAreaSearchPosition = valuePosition - SIMD2<Float>(x: 1, y: 0) * minCellSize / 2 - 0.00001
    XCTAssertNil(canvas.closestValue(to: outOfAreaSearchPosition))

    // On the edge position.
    let edgeSearchPosition = valuePosition - SIMD2<Float>(x: 1, y: 0) * minCellSize / 2
    XCTAssertNotNil(canvas.closestValue(to: edgeSearchPosition))
  }

  func testTwoValuesCompete() {
    let canvas = Canvas<Int>(minBounds: .zero, maxBounds: .one, minimumCellSize: 1)
    let zeroValue = 0
    let oneValue = 1
    let oneValuePosition = SIMD2<Float>(x: 1, y: 0)
    canvas.add(zeroValue, at: .zero)
    canvas.add(oneValue, at: oneValuePosition)

    // From zero to halfway we should get `zeroValue`.
    for i in 0...5 {
      let position = SIMD2<Float>(x: 0.1 * Float(i), y: 0)
      XCTAssertEqual(canvas.closestValue(to: position), zeroValue)
    }

    // From halfway till the end we should get `oneValue`.
    for i in 6...10 {
      let position = SIMD2<Float>(x: 0.1 * Float(i), y: 0)
      XCTAssertEqual(canvas.closestValue(to: position), oneValue)
    }
  }
}
