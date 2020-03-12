import Foundation
import GameplayKit

struct Canvas<T> {
  private let tree: GKQuadtree<Element<T>>
  private let minCellSize: Float

  public init(bounds: float2x2, minimumCellSize: Float) {
    let quad = GKQuad(quadMin: bounds[0], quadMax: bounds[1])
    self.init(boundingQuad: quad, minimumCellSize: minimumCellSize)
  }

  init(boundingQuad quad: GKQuad, minimumCellSize minCellSize: Float) {
    self.minCellSize = minCellSize
    tree = GKQuadtree<Element>(boundingQuad: quad, minimumCellSize: minCellSize)
  }
  
  func add(_ value: T, at position: SIMD2<Float>) {
    let element = Element(value: value, position: position)
    tree.add(element, at: element.position)
  }
  
  func elements(at point: SIMD2<Float>) -> [Element<T>] {
    let quadMin = SIMD2<Float>(x: point.x - minCellSize / 2, y: point.y - minCellSize / 2)
    let quadMax = SIMD2<Float>(x: point.x + minCellSize / 2, y: point.y + minCellSize / 2)
    let quad = GKQuad(quadMin: quadMin, quadMax: quadMax)
    return elements(in: quad)
  }
  
  func elements(in quad: GKQuad) -> [Element<T>] {
    tree.elements(in: quad)
  }
  
  func clostesElement(to point: SIMD2<Float>) -> T? {
    elements(at: point)
      .sorted { $0.distance(from: point) < $1.distance(from: point) }
      .first?
      .value
  }
}
