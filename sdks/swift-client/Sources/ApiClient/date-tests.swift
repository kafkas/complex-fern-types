import Api
import Foundation

func runDateTests() throws {
    print("=== Testing Extensive Type (CalendarDate and Date) ===")

    do {
        // Create test dates
        guard let testCalendarDate = CalendarDate(year: 2024, month: 3, day: 15) else {
            throw TestError.unexpectedResult("Failed to create test CalendarDate")
        }
        let testDateTime = Date(timeIntervalSince1970: 1_710_518_400)  // 2024-03-15T12:00:00Z

        // Test round-trip encoding/decoding
        let extensive = Extensive(
            name: "Test Project",
            creationDate: testCalendarDate,
            creationTime: testDateTime,
            nullableString: .string("abc"),
            nullableOptionalInt: .number(4),
            optionalNullableString: .string("abc"),
            additionalProperties: ["priority": JSONValue.string("high")]
        )
        try testRoundTrip(extensive, description: "Extensive with CalendarDate and Date")

        // Test JSON decoding with various date formats
        print("Testing Extensive decoding from JSON with different date formats...")

        // Test with ISO date string and ISO datetime string
        let extensiveJSON1 = """
            {
                "name": "Project Alpha",
                "creation_date": "2024-03-15",
                "creation_time": "2024-03-15T12:00:00Z",
                "custom_field": "custom_value"
            }
            """
        let decoded1 = try testJSONDecoding(
            extensiveJSON1, as: Extensive.self, description: "Extensive with ISO date/datetime")

        // Verify the decoded values
        if decoded1.creationDate.year == 2024 && decoded1.creationDate.month == 3
            && decoded1.creationDate.day == 15
        {
            print(
                "  ✅ CalendarDate correctly decoded: \(decoded1.creationDate.year)-\(decoded1.creationDate.month)-\(decoded1.creationDate.day)"
            )
        } else {
            throw TestError.unexpectedResult("CalendarDate not decoded correctly")
        }

        // Check that the datetime was parsed correctly (allowing for small time differences)
        let expectedTimestamp: TimeInterval = 1_710_518_400  // 2024-03-15T12:00:00Z
        let timeDifference = abs(
            decoded1.creationTime.timeIntervalSince1970 - expectedTimestamp)
        if timeDifference < 1.0 {  // Allow 1 second tolerance
            print("  ✅ Date correctly decoded: \(decoded1.creationTime)")
        } else {
            print("  ⚠️  Date decoded with time difference: \(timeDifference) seconds")
        }

        // Test edge cases - leap year
        let extensiveJSON3 = """
            {
                "name": "Leap Year Project",
                "creation_date": "2024-02-29",
                "creation_time": "2024-02-29T23:59:59Z"
            }
            """
        let decoded3 = try testJSONDecoding(
            extensiveJSON3, as: Extensive.self, description: "Extensive with leap year date")

        if decoded3.creationDate.year == 2024 && decoded3.creationDate.month == 2
            && decoded3.creationDate.day == 29
        {
            print(
                "  ✅ Leap year CalendarDate correctly decoded: \(decoded3.creationDate.year)-\(decoded3.creationDate.month)-\(decoded3.creationDate.day)"
            )
        } else {
            throw TestError.unexpectedResult("Leap year CalendarDate not decoded correctly")
        }

    } catch {
        print("  ❌ Extensive type test failed: \(error)")
        throw error
    }

    // Test 13: Extensive type error handling
    print("=== Testing Extensive Type Error Handling ===")

    // Test invalid date format
    let invalidDateJSON = """
        {
            "name": "Invalid Date Project",
            "creation_date": "2024-13-32",
            "creation_time": "2024-03-15T12:00:00Z"
        }
        """
    do {
        _ = try testJSONDecoding(
            invalidDateJSON, as: Extensive.self, description: "Invalid date format")
        throw TestError.unexpectedResult("Should have failed with invalid date")
    } catch TestError.decodingFailed(let message) {
        print("  ✅ Correctly failed with invalid date: \(message)")
    }

    // Test invalid datetime format
    let invalidDateTimeJSON = """
        {
            "name": "Invalid DateTime Project",
            "creation_date": "2024-03-15",
            "creation_time": "not-a-datetime"
        }
        """
    do {
        _ = try testJSONDecoding(
            invalidDateTimeJSON, as: Extensive.self, description: "Invalid datetime format")
        throw TestError.unexpectedResult("Should have failed with invalid datetime")
    } catch TestError.decodingFailed(let message) {
        print("  ✅ Correctly failed with invalid datetime: \(message)")
    }

    // Test missing required fields
    let missingFieldsJSON = """
        {
            "name": "Incomplete Project"
        }
        """
    do {
        _ = try testJSONDecoding(
            missingFieldsJSON, as: Extensive.self, description: "Missing required date fields")
        throw TestError.unexpectedResult("Should have failed with missing fields")
    } catch TestError.decodingFailed(let message) {
        print("  ✅ Correctly failed with missing required fields: \(message)")
    }

    print()

    // Test 14: CalendarDate edge cases and format validation
    print("=== Testing CalendarDate Edge Cases ===")

    // Test non-zero-padded format (should work for decoding)
    let nonPaddedJSON = """
        {
            "name": "Non-padded Date Test",
            "creation_date": "2024-3-5",
            "creation_time": "2024-03-05T10:00:00Z"
        }
        """

    do {
        let decoded = try testJSONDecoding(
            nonPaddedJSON, as: Extensive.self, description: "Non-zero-padded date")
        if decoded.creationDate.year == 2024 && decoded.creationDate.month == 3
            && decoded.creationDate.day == 5
        {
            print("  ✅ Non-zero-padded date correctly parsed: \(decoded.creationDate)")

            // Check that it encodes back to zero-padded format
            let reencoded = try encodeToJSON(decoded)
            let reencodedString = jsonString(from: reencoded)
            if reencodedString.contains("\"2024-03-05\"") {
                print("  ✅ Re-encoded to proper zero-padded format")
            } else {
                print("  ⚠️  Encoding format: \(reencodedString)")
            }
        }
    } catch {
        print("  ❌ Non-padded date test failed: \(error)")
    }

    // Test CalendarDate direct usage
    print("Testing CalendarDate direct initialization...")

    // Valid cases
    if let validDate = CalendarDate(year: 2024, month: 2, day: 29) {
        print("  ✅ Leap year date created: \(validDate)")
    } else {
        print("  ❌ Failed to create valid leap year date")
    }

    // Invalid cases that should fail
    if CalendarDate(year: 2023, month: 2, day: 29) == nil {
        print("  ✅ Correctly rejected Feb 29 on non-leap year")
    } else {
        print("  ❌ Should have rejected Feb 29 on non-leap year")
    }

    if CalendarDate(year: 2024, month: 13, day: 1) == nil {
        print("  ✅ Correctly rejected invalid month 13")
    } else {
        print("  ❌ Should have rejected month 13")
    }

    if CalendarDate(year: 2024, month: 4, day: 31) == nil {
        print("  ✅ Correctly rejected April 31")
    } else {
        print("  ❌ Should have rejected April 31")
    }

    // String initialization tests
    if let stringDate = CalendarDate("2024-12-31") {
        print("  ✅ String initialization works: \(stringDate)")
    } else {
        print("  ❌ String initialization failed")
    }

    // Edge case: non-padded string
    if let nonPaddedStringDate = CalendarDate("2024-1-1") {
        print("  ✅ Non-padded string accepted: \(nonPaddedStringDate)")
    } else {
        print("  ❌ Non-padded string rejected")
    }

    // Invalid string formats
    if CalendarDate("2024/03/15") == nil {
        print("  ✅ Correctly rejected wrong separator")
    } else {
        print("  ❌ Should have rejected wrong separator")
    }

    if CalendarDate("invalid-date") == nil {
        print("  ✅ Correctly rejected malformed date string")
    } else {
        print("  ❌ Should have rejected malformed date string")
    }
}
