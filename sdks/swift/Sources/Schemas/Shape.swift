import Foundation

public enum Shape: Codable, Hashable, Sendable {
    case triangle(Triangle)
    case square(Square)
    case circle(Circle)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let discriminant = try container.decode(String.self, forKey: .type)
        switch discriminant {
        case "triangle":
            self = .triangle(try Triangle(from: decoder))
        case "square":
            self = .square(try Square(from: decoder))
        case "circle":
            self = .circle(try Circle(from: decoder))
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unknown shape discriminant value: \(discriminant)"
                )
            )
        }
    }

    public func encode(to encoder: Encoder) throws -> Void {
        switch self {
        case .triangle(let data):
            try data.encode(to: encoder)
        case .square(let data):
            try data.encode(to: encoder)
        case .circle(let data):
            try data.encode(to: encoder)
        }
    }

    public struct Triangle: Codable, Hashable, Sendable {
        public let type: String = "triangle"
        public let a: Double
        public let b: Double
        public let c: Double
        /// Additional properties that are not explicitly defined in the schema
        public let additionalProperties: [String: JSONValue]

        public init(
            a: Double,
            b: Double,
            c: Double,
            additionalProperties: [String: JSONValue] = .init()
        ) {
            self.a = a
            self.b = b
            self.c = c
            self.additionalProperties = additionalProperties
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.a = try container.decode(Double.self, forKey: .a)
            self.b = try container.decode(Double.self, forKey: .b)
            self.c = try container.decode(Double.self, forKey: .c)
            self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
        }

        public func encode(to encoder: Encoder) throws -> Void {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try encoder.encodeAdditionalProperties(self.additionalProperties)
            try container.encode(self.type, forKey: .type)
            try container.encode(self.a, forKey: .a)
            try container.encode(self.b, forKey: .b)
            try container.encode(self.c, forKey: .c)
        }

        /// Keys for encoding/decoding struct properties.
        enum CodingKeys: String, CodingKey, CaseIterable {
            case type
            case a
            case b
            case c
        }
    }

    public struct Square: Codable, Hashable, Sendable {
        public let type: String = "square"
        public let length: Double
        /// Additional properties that are not explicitly defined in the schema
        public let additionalProperties: [String: JSONValue]

        public init(
            length: Double,
            additionalProperties: [String: JSONValue] = .init()
        ) {
            self.length = length
            self.additionalProperties = additionalProperties
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.length = try container.decode(Double.self, forKey: .length)
            self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
        }

        public func encode(to encoder: Encoder) throws -> Void {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try encoder.encodeAdditionalProperties(self.additionalProperties)
            try container.encode(self.type, forKey: .type)
            try container.encode(self.length, forKey: .length)
        }

        /// Keys for encoding/decoding struct properties.
        enum CodingKeys: String, CodingKey, CaseIterable {
            case type
            case length
        }
    }

    public struct Circle: Codable, Hashable, Sendable {
        public let type: String = "circle"
        public let radius: Double
        /// Additional properties that are not explicitly defined in the schema
        public let additionalProperties: [String: JSONValue]

        public init(
            radius: Double,
            additionalProperties: [String: JSONValue] = .init()
        ) {
            self.radius = radius
            self.additionalProperties = additionalProperties
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.radius = try container.decode(Double.self, forKey: .radius)
            self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
        }

        public func encode(to encoder: Encoder) throws -> Void {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try encoder.encodeAdditionalProperties(self.additionalProperties)
            try container.encode(self.type, forKey: .type)
            try container.encode(self.radius, forKey: .radius)
        }

        /// Keys for encoding/decoding struct properties.
        enum CodingKeys: String, CodingKey, CaseIterable {
            case type
            case radius
        }
    }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case type
    }
}