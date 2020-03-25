import ObjectiveC

/// A `Region` element.
///
/// Represents an element in the region.
final class Element<T>: NSObject {
  /// Value associated with the element.
  let value: T

  /// Element's `Region` coordinate.
  let position: SIMD2<Float>

  /// Initializes a new `Element` instances with the specified parameters.
  ///
  /// - Parameters:
  ///   - value: A value associated with this element.
  ///   - position: The coordinate of this element in the region.
  init(value: T, position: SIMD2<Float>) {
    self.value = value
    self.position = position
    super.init()
  }

  /// Computes the distance between this instance and the specified coordinate.
  ///
  /// - Parameter position: Coordinate of the location we would like to compute
  ///   the distance of.
  func distance(from position: SIMD2<Float>) -> Float {
    (self.position - position).length()
  }
}
