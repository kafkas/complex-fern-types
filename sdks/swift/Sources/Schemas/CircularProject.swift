import Foundation

public struct CircularProject: Codable, Hashable, Sendable {
    public let name: String
    public let creationDate: CalendarDate
    public let workspace: Indirect<CircularWorkspace>
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        name: String,
        creationDate: CalendarDate,
        workspace: CircularWorkspace,
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.name = name
        self.creationDate = creationDate
        self.workspace = Indirect(workspace)
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.creationDate = try container.decode(CalendarDate.self, forKey: .creationDate)
        self.workspace = try container.decode(Indirect<CircularWorkspace>.self, forKey: .workspace)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.creationDate, forKey: .creationDate)
        try container.encode(self.workspace, forKey: .workspace)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case creationDate = "creation_date"
        case workspace
    }
}