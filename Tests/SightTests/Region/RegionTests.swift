import Foundation
import Darwin
import Sight
import XCTest

final class RegionTests: XCTestCase {
  func testInstanceNoValue() {
    let region = Region<Any>(minBounds: .zero, maxBounds: .one, searchRadius: 10)
    XCTAssertNil(region.closestValue(to: .zero))
    XCTAssertNil(region.closestValue(to: .one))
    XCTAssertNil(region.closestValue(to: .zero / 2))
  }

  func testOneValue() {
    let region = Region<Int>(minBounds: .zero, maxBounds: .one, searchRadius: 10)
    let value = 1
    let valuePosition = SIMD2<Float>.one / 2

    region.add(value, at: valuePosition)

    XCTAssertEqual(value, region.closestValue(to: valuePosition))
  }

  func testFindValueOnEdge() {
    let searchRadius: Float = 0.5
    let region = Region<Int>(minBounds: .zero, maxBounds: .one * 10, searchRadius: searchRadius)
    let value = 1
    let valuePosition = SIMD2<Float>(x: 1, y: 0) * 10

    region.add(value, at: valuePosition)

    // Just out of area position.
    let outOfAreaSearchPosition = valuePosition - SIMD2<Float>(x: 1, y: 0) * searchRadius - 0.00001
    XCTAssertNil(region.closestValue(to: outOfAreaSearchPosition))

    // On the edge position.
    let edgeSearchPosition = valuePosition - SIMD2<Float>(x: 1, y: 0) * searchRadius
    XCTAssertNotNil(region.closestValue(to: edgeSearchPosition))
  }

  func testTwoValuesCompete() {
    let region = Region<Int>(minBounds: .zero, maxBounds: .one, searchRadius: 1)
    let zeroValue = 0
    let oneValue = 1
    let oneValuePosition = SIMD2<Float>(x: 1, y: 0)
    region.add(zeroValue, at: .zero)
    region.add(oneValue, at: oneValuePosition)

    // From zero to halfway we should get `zeroValue`.
    for i in 0...5 {
      let position = SIMD2<Float>(x: 0.1 * Float(i), y: 0)
      XCTAssertEqual(region.closestValue(to: position), zeroValue)
    }

    // From halfway till the end we should get `oneValue`.
    for i in 6...10 {
      let position = SIMD2<Float>(x: 0.1 * Float(i), y: 0)
      XCTAssertEqual(region.closestValue(to: position), oneValue)
    }
  }

  func testOutOfBounds() {
    let region = Region<Void>(minBounds: .zero, maxBounds: .one, searchRadius: 0.1)
    region.add((), at: .zero)

    for i in 1...10 {
      let position = SIMD2<Float>(x: -0.1 * Float(i), y: 0)
      XCTAssertNil(region.closestValue(to: position), "fail for \(i)")
    }

    let position = SIMD2<Float>(x: -0.09, y: 0)
    XCTAssertNotNil(region.closestValue(to: position))
  }
}
