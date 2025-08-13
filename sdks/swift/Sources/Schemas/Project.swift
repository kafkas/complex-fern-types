import Foundation

public struct Project: Codable, Hashable, Sendable {
    public let isOpen: JSONValue
    public let name: String
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        isOpen: JSONValue,
        name: String,
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.isOpen = isOpen
        self.name = name
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isOpen = try container.decode(JSONValue.self, forKey: .isOpen)
        self.name = try container.decode(String.self, forKey: .name)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.isOpen, forKey: .isOpen)
        try container.encode(self.name, forKey: .name)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case isOpen = "is_open"
        case name
    }
}