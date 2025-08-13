import Foundation

public struct Account: Codable, Hashable, Sendable {
    public let addressType: Country
    public let name: String
    public let isOpen: Bool
    public let country: Country
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        addressType: Country,
        name: String,
        isOpen: Bool,
        country: Country,
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.addressType = addressType
        self.name = name
        self.isOpen = isOpen
        self.country = country
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.addressType = try container.decode(Country.self, forKey: .addressType)
        self.name = try container.decode(String.self, forKey: .name)
        self.isOpen = try container.decode(Bool.self, forKey: .isOpen)
        self.country = try container.decode(Country.self, forKey: .country)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.addressType, forKey: .addressType)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.isOpen, forKey: .isOpen)
        try container.encode(self.country, forKey: .country)
    }

    public enum Country: String, Codable, Hashable, CaseIterable, Sendable {
        case country
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case addressType = "address_type"
        case name
        case isOpen = "is_open"
        case country
    }
}