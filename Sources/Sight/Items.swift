import Foundation

// Wrapper for region item value.
public struct Items<T> {
  
  /// The value of the item that is a generic type/
  public let value: T
  
  /// Item position represent on a coordinate
  public let position: SIMD2<Float>
    
  /// Make the item is a public object
  public init(value: T, position: SIMD2<Float>) {
    self.value = value
    self.position = position
  }
  
}
