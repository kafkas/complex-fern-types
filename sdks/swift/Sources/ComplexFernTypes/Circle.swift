import Foundation

public struct Circle: Codable, Hashable, Sendable {
  public let radius: Double

  public init(radius: Double) {
    self.radius = radius
  }

}
