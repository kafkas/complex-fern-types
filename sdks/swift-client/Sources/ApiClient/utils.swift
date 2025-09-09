import Foundation

enum TestError: Error {
    case encodingFailed(String)
    case decodingFailed(String)
    case unexpectedResult(String)
}

func encodeToJSON<T: Codable>(_ value: T) throws -> Data {
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(value)
    } catch {
        throw TestError.encodingFailed("Failed to encode \(type(of: value)): \(error)")
    }
}

func decodeFromJSON<T: Codable>(_ data: Data, as type: T.Type) throws -> T {
    do {
        let decoder = JSONDecoder()
        // Use custom strategy for robust ISO 8601 date parsing with fractional seconds
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            if let date = formatter.date(from: dateString) {
                return date
            }

            // Fallback for dates without fractional seconds
            formatter.formatOptions = [.withInternetDateTime]
            if let date = formatter.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container, debugDescription: "Invalid date format: \(dateString)")
        }
        return try decoder.decode(type, from: data)
    } catch {
        throw TestError.decodingFailed("Failed to decode \(type): \(error)")
    }
}

func jsonString(from data: Data) -> String {
    return String(data: data, encoding: .utf8) ?? "Invalid UTF-8"
}

func testRoundTrip<T: Codable & Equatable>(_ value: T, description: String) throws {
    print("Testing \(description)...")

    // Encode to JSON
    let jsonData = try encodeToJSON(value)
    let jsonStr = jsonString(from: jsonData)
    print("  Encoded: \(jsonStr)")

    // Decode back from JSON
    let decoded = try decodeFromJSON(jsonData, as: T.self)
    print("  Decoded: \(decoded)")

    // Verify round trip
    guard decoded == value else {
        throw TestError.unexpectedResult("Round trip failed for \(description)")
    }

    print("  ✅ Round trip successful!")
    print()
}

func testJSONDecoding<T: Codable>(_ jsonString: String, as type: T.Type, description: String) throws
    -> T
{
    print("Testing \(description) JSON decoding...")
    print("  JSON: \(jsonString)")

    guard let data = jsonString.data(using: .utf8) else {
        throw TestError.decodingFailed("Invalid UTF-8 in JSON string")
    }

    let decoded = try decodeFromJSON(data, as: type)
    print("  Decoded: \(decoded)")
    print("  ✅ Decoding successful!")
    print()

    return decoded
}
