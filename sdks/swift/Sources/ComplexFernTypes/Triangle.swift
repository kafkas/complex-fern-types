import Foundation

public struct Triangle: Codable, Hashable, Sendable {
  public let type: String = "triangle"
  public let a: Double
  public let b: Double
  public let c: Double

  public init(a: Double, b: Double, c: Double) {
    self.a = a
    self.b = b
    self.c = c
  }

  private enum CodingKeys: String, CodingKey {
    case type, a, b, c
  }
}
