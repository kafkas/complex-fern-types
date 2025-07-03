import Foundation

public struct Square: Codable, Hashable, Sendable {
  public let length: Double

  public init(length: Double) {
    self.length = length
  }

}
