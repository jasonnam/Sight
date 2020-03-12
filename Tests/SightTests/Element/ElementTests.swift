@testable import Sight
import XCTest

final class ElementTests: XCTestCase {
  func testInstanceValue() {
    for value in 1...10 {
      let element = Element(value: value, position: .zero)
      XCTAssertEqual(element.value, value)
    }
  }

  func testInstancePosition() {
    // Verify all possible combinations of positive/negative values.
    let positions: [SIMD2<Float>] = [
      .zero,
      .init(x: 0, y: 1),
      .init(x: 1, y: 1),
      .init(x: 1, y: 0),
      .init(x: 1, y: -1),
      .init(x: 0, y: -1),
      .init(x: -1, y: -1),
      .init(x: -1, y: 0),
      .init(x: -1, y: 1)
    ]

    for position in positions {
      let element = Element(value: (), position: position)
      XCTAssertEqual(element.position, position)
    }
  }

  func testInstanceDistance() {
    let position = SIMD2<Float>(x: 0, y: 1)

    for distance in 0...10 {
      let element = Element(value: (), position: .zero)
      let distanceFromElement = element.distance(from: position * Float(distance))
      XCTAssertEqual(distanceFromElement, Float(distance))
    }
  }
}
