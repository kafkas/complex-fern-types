import Foundation

extension Requests {
    public struct SendInlinedRequest: Codable, Hashable, Sendable {
        public let someString: String
        public let someInt: Int
        /// Additional properties that are not explicitly defined in the schema
        public let additionalProperties: [String: JSONValue]

        public init(
            someString: String,
            someInt: Int,
            additionalProperties: [String: JSONValue] = .init()
        ) {
            self.someString = someString
            self.someInt = someInt
            self.additionalProperties = additionalProperties
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.someString = try container.decode(String.self, forKey: .someString)
            self.someInt = try container.decode(Int.self, forKey: .someInt)
            self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
        }

        public func encode(to encoder: Encoder) throws -> Void {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try encoder.encodeAdditionalProperties(self.additionalProperties)
            try container.encode(self.someString, forKey: .someString)
            try container.encode(self.someInt, forKey: .someInt)
        }

        /// Keys for encoding/decoding struct properties.
        enum CodingKeys: String, CodingKey, CaseIterable {
            case someString
            case someInt
        }
    }
}