import Foundation

public struct Extensive: Codable, Hashable, Sendable {
    public let name: String
    public let creationDate: CalendarDate
    public let creationTime: Date
    public let nullableString: Nullable<String>
    public let optionalNullableString: Nullable<String>?
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        name: String,
        creationDate: CalendarDate,
        creationTime: Date,
        nullableString: Nullable<String>,
        optionalNullableString: Nullable<String>? = nil,
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.name = name
        self.creationDate = creationDate
        self.creationTime = creationTime
        self.nullableString = nullableString
        self.optionalNullableString = optionalNullableString
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.creationDate = try container.decode(CalendarDate.self, forKey: .creationDate)
        self.creationTime = try container.decode(Date.self, forKey: .creationTime)
        self.nullableString = try container.decode(Nullable<String>.self, forKey: .nullableString)
        self.optionalNullableString = try container.decodeIfPresent(Nullable<String>.self, forKey: .optionalNullableString)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.creationDate, forKey: .creationDate)
        try container.encode(self.creationTime, forKey: .creationTime)
        try container.encode(self.nullableString, forKey: .nullableString)
        try container.encodeIfPresent(self.optionalNullableString, forKey: .optionalNullableString)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case creationDate = "creation_date"
        case creationTime = "creation_time"
        case nullableString = "nullable_string"
        case optionalNullableString = "optional_nullable_string"
    }
}