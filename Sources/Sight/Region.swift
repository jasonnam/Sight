import GameplayKit

/// Space where we values are placed.
public struct Region<T> {
  /// GameplayKit data structure used to organize objects based on their
  /// locations in a two-dimensional space.
  ///
  /// - SeeAlso: [Apple Documentation](https://developer.apple.com/documentation/gameplaykit/gkquadtree)
  let tree: GKQuadtree<Element<T>>

  /// The spatial area radius of interest.
  let searchRadius: Float

  /// Initializes a new `Region` instance.
  ///
  /// - Parameters:
  ///   - minBounds: The minimun position bound.
  ///   - maxBounds: The maximum position bound.
  ///   - searchRadius: The search radius of the area of interest.
  ///   - minimumCellSize: The inner Quadtree minimumCellSize. This is your
  ///     leverage on the library perfomance/memory-usage.
  public init(
    minBounds: SIMD2<Float>,
    maxBounds: SIMD2<Float>,
    searchRadius: Float,
    minimumCellSize: Float = 1
  ) {
    let quad = GKQuad(quadMin: minBounds, quadMax: maxBounds)
    self.init(
      boundingQuad: quad,
      searchRadius: searchRadius,
      minimumCellSize: minimumCellSize
    )
  }

  /// Initializes a new `Region` instance.
  ///
  /// - SeeAlso: `init(quadMin:maxBounds:searchRadius:)`.
  init(boundingQuad quad: GKQuad, searchRadius: Float, minimumCellSize: Float) {
    self.searchRadius = searchRadius
    tree = GKQuadtree(boundingQuad: quad, minimumCellSize: minimumCellSize)
  }

  /// Adds the value at the specified position.
  ///
  /// If multiple values are placed at the same position, only one of them will
  /// be returned during a query (which one is random).
  ///
  /// - Parameters:
  ///   - value: The value to be added in the region.
  ///   - position: The coordinate of the new value in the region.
  public func add(_ value: T, at position: SIMD2<Float>) {
    let element = Element(value: value, position: position)
    tree.add(element, at: element.position)
  }

  /// Returns all elements whose corresponding positions overlap the square
  /// region with center on the specified `position`, and `searchRadius * 2`
  /// edge length.
  ///
  /// - Parameter position: The center of the region we're interest in.
  func elements(at position: SIMD2<Float>) -> [Element<T>] {
    let quadMin = position - searchRadius
    let quadMax = position + searchRadius
    let quad = GKQuad(quadMin: quadMin, quadMax: quadMax)
    return elements(in: quad)
  }

  /// Returns all elements whose corresponding positions overlap the specified
  /// region.
  ///
  /// - Parameter quad: The axis-aligned rectangle in 2D space to search.
  func elements(in quad: GKQuad) -> [Element<T>] {
    tree.elements(in: quad)
  }

  /// Returns the value whose position is closest to the specified position
  /// (if any).
  ///
  /// A value will be returned only if its region (specified with `minimumCellSize`)
  /// overlaps the square region centered in `position` and with
  /// `minimumCellSize` dimension.
  public func closestValue(to position: SIMD2<Float>) -> T? {
    if
      let closestElement: Element = elements(at: position)
        .min(by: { $0.distance(from: position) < $1.distance(from: position) }),
      closestElement.distance(from: position) <= searchRadius {
      return closestElement.value
    }
    return nil
  }
}
