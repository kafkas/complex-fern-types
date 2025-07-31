import Foundation

public enum Shape: Codable, Hashable, Sendable {
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

  case triangle(ComplexFernTypes.Triangle)
  case square(ComplexFernTypes.Square)
  case circle(ComplexFernTypes.Circle)

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let type = try container.decode(String.self, forKey: .type)
    switch type {
    case "triangle":
      self = .triangle(try ComplexFernTypes.Triangle(from: decoder))
    case "square":
      self = .square(try ComplexFernTypes.Square(from: decoder))
    case "circle":
      self = .circle(try ComplexFernTypes.Circle(from: decoder))
    default:
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Unknown shape type: \(type)"
        )
      )
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    switch self {
    case .triangle(let data):
      try container.encode("triangle", forKey: .type)
      try data.encode(to: encoder)
    case .square(let data):
      try container.encode("square", forKey: .type)
      try data.encode(to: encoder)
    case .circle(let data):
      try container.encode("circle", forKey: .type)
      try data.encode(to: encoder)
    }
  }

  private enum CodingKeys: String, CodingKey {
    case type = "type"
  }
}
