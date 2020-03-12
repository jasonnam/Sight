@testable import Sight
import XCTest

final class ElementTests: XCTestCase {
  func testElementValue() {
    for value in 1...10 {
      let element = Element(value: value, position: .zero)
      XCTAssertEqual(element.value, value)
    }
  }

  func testElementPosition() {
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
}
