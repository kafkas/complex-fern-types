import Foundation

/// Represents a value that is always present in JSON but can be either a concrete value or explicit `null`.
/// This maps to `nullable<T>` in Fern - the field is always present, but the value can be null.
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
}

// For `optional<nullable<T>>` patterns, simply use `Nullable<T>?`
// This gives you three states naturally:
// - `nil` = missing from JSON
// - `.null` = present in JSON as explicit null
// - `.value(x)` = present in JSON with actual value

// MARK: - Convenience Extensions

extension Nullable {
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
        if case .null = self {
            return true
        }
        return false
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

// MARK: - Extensions for Optional Nullable Pattern

extension Optional where Wrapped: NullableProtocol {
    /// Returns the deeply wrapped value if present, otherwise nil
    /// For Nullable<String>?, this returns String?
    public var wrappedValue: Wrapped.WrappedType? {
        return self?.wrappedValue
    }

    /// Returns true if this field is missing from JSON (the outer optional is nil)
    public var isMissing: Bool {
        return self == nil
    }

    /// Returns true if this field was present but explicitly null
    public var isExplicitlyNull: Bool {
        return self?.isNull == true
    }

    /// Returns true if this field has a concrete value (not null or missing)
    public var hasValue: Bool {
        return self?.wrappedValue != nil
    }
}

/// Protocol to enable extensions on Optional<Nullable<T>>
public protocol NullableProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType? { get }
    var isNull: Bool { get }
}

extension Nullable: NullableProtocol {
    public typealias WrappedType = Wrapped
}
