import Foundation

/// A Canvas element.
///
/// Represents an element in the canvas.
final class Element<T>: NSObject {
  /// Value associated with the element.
  let value: T

  /// Canvas coordinate of the element.
  let position: SIMD2<Float>

  /// Initializes a new `Element` instances with the specified parameters.
  ///
  /// - Parameters:
  ///   - value: A value associated with this element.
  ///   - position: The coordinate of this element in the canvas.
  init(value: T, position: SIMD2<Float>) {
    self.value = value
    self.position = position
    super.init()
  }

  /// Computes the distance between this instance and the specified coordinate.
  ///
  /// - Parameter position: Coordinate of the point we would like to compute the
  ///   distance of.
  func distance(from position: SIMD2<Float>) -> Float {
    let Δposition: SIMD2<Float> = self.position - position
    return sqrt(pow(Δposition.x, 2) + pow(Δposition.y, 2))
  }
}
