import Foundation

public struct Square: Codable, Hashable, Sendable {
  public let type: String = "square"
  public let length: Double

  public init(length: Double) {
    self.length = length
  }

  private enum CodingKeys: String, CodingKey {
    case type, length
  }
}
