import Foundation

extension SIMD2 where SIMD2.Scalar: FloatingPoint {
  /// Returns the vector lenght.
  func length() -> Scalar {
    sqrt((self * self).sum())
  }
}
