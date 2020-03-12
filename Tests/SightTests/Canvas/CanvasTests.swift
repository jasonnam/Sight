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
}
