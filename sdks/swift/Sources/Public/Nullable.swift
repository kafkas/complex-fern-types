import Foundation

/// Represents a value that can be either a concrete value or explicit `null`.
/// Use this for `nullable<T>` fields that are always present in JSON.
public enum Nullable<Wrapped>: Codable, Hashable, Sendable
where Wrapped: Codable & Hashable & Sendable {
    case value(Wrapped)
    case null

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
        } else {
            let wrappedValue = try container.decode(Wrapped.self)
            self = .value(wrappedValue)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .value(let wrapped):
            try container.encode(wrapped)
        case .null:
            try container.encodeNil()
        }
    }

    /// Returns the wrapped value if present, otherwise nil
    public var wrappedValue: Wrapped? {
        switch self {
        case .value(let wrapped):
            return wrapped
        case .null:
            return nil
        }
    }

    /// Returns true if this contains an explicit null value
    public var isNull: Bool {
        switch self {
        case .value(_):
            return false
        case .null:
            return true
        }
    }

    /// Convenience initializer from optional value
    public init(_ value: Wrapped?) {
        if let value = value {
            self = .value(value)
        } else {
            self = .null
        }
    }
}

// MARK: - Helper Extensions for Optional<Nullable<T>> Encoding/Decoding

extension KeyedDecodingContainer {
    /// Decodes a Nullable<T>? value, properly handling missing vs null vs value
    /// Use this for `optional<nullable<T>>` fields
    public func decodeNullableIfPresent<T>(
        _ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> Nullable<T>? where T: Decodable {
        if contains(key) {
            if try decodeNil(forKey: key) {
                return .null
            } else {
                let value = try decode(type, forKey: key)
                return .value(value)
            }
        } else {
            return nil
        }
    }
}

extension KeyedEncodingContainer {
    /// Encodes a Nullable<T>? value, properly handling missing vs null vs value
    /// Use this for `optional<nullable<T>>` fields
    public mutating func encodeNullableIfPresent<T>(
        _ value: Nullable<T>?, forKey key: KeyedEncodingContainer<K>.Key
    ) throws where T: Encodable {
        switch value {
        case nil:
            // Don't encode the key at all - field is missing
            break
        case .some(.null):
            try encodeNil(forKey: key)
        case .some(.value(let wrapped)):
            try encode(wrapped, forKey: key)
        }
    }
}
