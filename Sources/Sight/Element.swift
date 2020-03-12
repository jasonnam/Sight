import Foundation

final class Element<T>: NSObject {
  let value: T
  let position: SIMD2<Float>

  init(value: T, position: SIMD2<Float>) {
    self.value = value
    self.position = position
    super.init()
  }

  func distance(from point: SIMD2<Float>) -> Float {
    let xDelta: Float = position.x - point.x
    let yDelta: Float = position.y - point.y
    return sqrt(pow(xDelta, 2) + pow(yDelta, 2))
  }
}
