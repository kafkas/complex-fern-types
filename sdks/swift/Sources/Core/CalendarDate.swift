import Foundation

/// Represents a calendar date without time information, following RFC 3339 section 5.6 (`YYYY-MM-DD` format)
public struct CalendarDate: Codable, Hashable, Sendable, CustomStringConvertible, Comparable {
    public let year: Int
    public let month: Int
    public let day: Int

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    /// Creates a CalendarDate from a `YYYY-MM-DD` string
    public init(_ dateString: String) throws {
        let components = dateString.split(separator: "-")
        guard components.count == 3,
            let year = Int(components[0]),
            let month = Int(components[1]),
            let day = Int(components[2])
        else {
            throw CalendarDateError.invalidFormat(dateString)
        }
        self.init(year: year, month: month, day: day)
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        String(format: "%04d-%02d-%02d", year, month, day)
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        try self.init(dateString)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }

    // MARK: - Comparable
    public static func < (lhs: CalendarDate, rhs: CalendarDate) -> Bool {
        if lhs.year != rhs.year { return lhs.year < rhs.year }
        if lhs.month != rhs.month { return lhs.month < rhs.month }
        return lhs.day < rhs.day
    }
}

public enum CalendarDateError: Error, LocalizedError {
    case invalidFormat(String)

    public var errorDescription: String? {
        switch self {
        case .invalidFormat(let string):
            return "Invalid date format: '\(string)'. Expected YYYY-MM-DD"
        }
    }
}
