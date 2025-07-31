public struct Triangle: Codable, Hashable, Sendable {
    public let a: Double
    public let b: Double
    public let c: Double
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
        try container.encode(self.a, forKey: .a)
        try container.encode(self.b, forKey: .b)
        try container.encode(self.c, forKey: .c)
    }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case a
        case b
        case c
    }
}