public enum Shape: Codable, Hashable, Sendable {
    case triangle(Triangle)
    case square(Square)
    case circle(Circle)

    public struct Triangle: Codable, Hashable, Sendable {
        public let type: String = "triangle"
        public let a: Double
        public let b: Double
        public let c: Double
        public let additionalProperties: [String: JSONValue]
    }

    public struct Square: Codable, Hashable, Sendable {
        public let type: String = "square"
        public let length: Double
        public let additionalProperties: [String: JSONValue]
    }

    public struct Circle: Codable, Hashable, Sendable {
        public let type: String = "circle"
        public let radius: Double
        public let additionalProperties: [String: JSONValue]
    }
}