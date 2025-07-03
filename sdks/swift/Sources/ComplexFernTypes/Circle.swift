import Foundation

public struct Circle: Codable, Hashable, Sendable {
  public let type: String = "circle"
  public let radius: Double

  public init(radius: Double) {
    self.radius = radius
  }

  private enum CodingKeys: String, CodingKey {
    case type, radius
  }
}
