import Foundation
import GameplayKit

/// The canvas where we can place our values.
public struct Canvas<T> {
  /// The GameplayKit data structure used to organize objects based on their
  /// locations in a two-dimensional space.
  ///
  /// - SeeAlso: [Apple Documentation](https://developer.apple.com/documentation/gameplaykit/gkquadtree)
  let tree: GKQuadtree<Element<T>>

  /// The minimum dimension (width and height) of an area of interest.
  ///
  /// Given a position when searching for values, the result will return a value
  /// only the (square) area in the canvas with this dimension has a value in
  /// it.
  let minCellSize: Float

  /// Initializes a new `Canvas` instance.
  ///
  /// - Parameters:
  ///   - minBounds: The minimun location bound.
  ///     Used (internally) to structure and organize the values. The more
  ///     accurate this value is, the better.
  ///   - maxBounds: The maximum location bound.
  ///     Used (internally) to structure and organize the values. The more
  ///     accurate this value is, the better.
  ///   - minimumCellSize: The minimum dimension (width and height) of an
  ///     area of interest.
  public init(
    minBounds: SIMD2<Float>,
    maxBounds: SIMD2<Float>,
    minimumCellSize: Float
  ) {
    let quad = GKQuad(quadMin: minBounds, quadMax: maxBounds)
    self.init(boundingQuad: quad, minimumCellSize: minimumCellSize)
  }

  /// Initializes a new `Canvas` instance.
  ///
  /// - SeeAlso: `init(bounds: float2x2, minimumCellSize: Float)`.
  init(boundingQuad quad: GKQuad, minimumCellSize minCellSize: Float) {
    self.minCellSize = minCellSize
    tree = GKQuadtree<Element>(boundingQuad: quad, minimumCellSize: minCellSize)
  }

  /// Adds the value at the specified position.
  ///
  /// If multiple values are placed at the same position, only one of them will
  /// be returned during a query (which one is random).
  ///
  /// - Parameters:
  ///   - value: The value to be added in the canvas.
  ///   - position: The coordinate of the new value in the canvas.
  public func add(_ value: T, at position: SIMD2<Float>) {
    let element = Element(value: value, position: position)
    tree.add(element, at: element.position)
  }

  /// Returns all elements whose corresponding locations overlap the square
  /// region with center on the specified `position`, and `minCellSize`
  /// dimensions.
  ///
  /// - Parameter location: The center of the region we're interest in.
  func elements(at location: SIMD2<Float>) -> [Element<T>] {
    let quadMin = location - minCellSize / 2
    let quadMax = location + minCellSize / 2
    let quad = GKQuad(quadMin: quadMin, quadMax: quadMax)
    return elements(in: quad)
  }

  /// Returns all elements whose corresponding locations overlap the specified
  /// region.
  ///
  /// - Parameter quad: The axis-aligned rectangle in 2D space to search.
  func elements(in quad: GKQuad) -> [Element<T>] {
    tree.elements(in: quad)
  }

  /// Returns the value whose location is closest to the specified point
  /// (if any).
  ///
  /// A value will be returned only if its region (specified with `minCellSize`)
  /// overlaps the square region centered in `point` and with `minCellSize`
  /// dimension.
  public func closestValue(to point: SIMD2<Float>) -> T? {
    elements(at: point)
      .filter { $0.distance(from: point) <= minCellSize / 2 }
      .sorted { $0.distance(from: point) < $1.distance(from: point) }
      .first?
      .value
  }
}
