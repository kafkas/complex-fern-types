import Api
import Foundation

func runNullableTests() throws {
    print("=== Testing Nullable Type System ===")

    // Test 1: All values present
    print("--- Test 1: All Values Present ---")
    let extensiveWithValues = Extensive(
        name: "Test Project",
        creationDate: .init(year: 2024, month: 3, day: 15)!,
        creationTime: .init(timeIntervalSince1970: 1_710_518_400),
        nullableString: .value("hello world"),  // nullable<string> with value                 // nullable<optional<int>> with value
        optionalNullableString: .value("optional value"),  // optional<nullable<string>> with value
        additionalProperties: ["priority": JSONValue.string("high")]
    )

    try testRoundTrip(extensiveWithValues, description: "Extensive with all values present")

    // Verify the values are accessible
    if case .value(let stringValue) = extensiveWithValues.nullableString {
        print("  ✅ nullableString has value: '\(stringValue)'")
    } else {
        throw TestError.unexpectedResult("nullableString should have a value")
    }

    if case .value(let optionalValue) = extensiveWithValues.optionalNullableString {
        print("  ✅ optionalNullableString has value: '\(optionalValue)'")
    } else {
        throw TestError.unexpectedResult("optionalNullableString should have a value")
    }

    // Test 2: Nullable fields are explicit null
    print("--- Test 2: Nullable Fields Are Null ---")
    let extensiveWithNulls = Extensive(
        name: "Null Test Project",
        creationDate: .init(year: 2024, month: 3, day: 15)!,
        creationTime: .init(timeIntervalSince1970: 1_710_518_400),
        nullableString: .null,  // nullable<string> is null
        optionalNullableString: .null  // optional<nullable<string>> is null
    )

    try testRoundTrip(extensiveWithNulls, description: "Extensive with nullable fields as null")

    // Verify null states
    if extensiveWithNulls.nullableString.isNull {
        print("  ✅ nullableString is correctly null")
    } else {
        throw TestError.unexpectedResult("nullableString should be null")
    }

    if extensiveWithNulls.optionalNullableString?.isNull == true {
        print("  ✅ optionalNullableString is correctly null")
    } else {
        throw TestError.unexpectedResult("optionalNullableString should be present but null")
    }

    // Test 3: Optional field is missing entirely
    print("--- Test 3: Optional Field Missing ---")
    let extensiveWithMissing = Extensive(
        name: "Missing Test Project",
        creationDate: .init(year: 2024, month: 3, day: 15)!,
        creationTime: .init(timeIntervalSince1970: 1_710_518_400),
        nullableString: .value("present"),  // nullable<string> with value
        optionalNullableString: nil  // optional<nullable<string>> missing entirely
    )

    try testRoundTrip(extensiveWithMissing, description: "Extensive with optional field missing")

    // Verify missing state
    if extensiveWithMissing.optionalNullableString == nil {
        print("  ✅ optionalNullableString is correctly missing")
    } else {
        throw TestError.unexpectedResult("optionalNullableString should be missing")
    }

    // Test 4: Test JSON parsing scenarios
    print("--- Test 4: JSON Parsing Scenarios ---")

    // Scenario A: All fields present with values
    let jsonAllValues = """
        {
            "name": "JSON Test 1",
            "creation_date": "2024-03-15", 
            "creation_time": "2024-03-15T12:00:00Z",
            "nullable_string": "json string",
            "optional_nullable_string": "json optional"
        }
        """

    let decodedAllValues = try testJSONDecoding(
        jsonAllValues, as: Extensive.self,
        description: "JSON with all values")

    if case .value(let str) = decodedAllValues.nullableString,
        str == "json string"
    {
        print("  ✅ JSON nullable_string decoded correctly")
    }

    if case .value(let optStr) = decodedAllValues.optionalNullableString,
        optStr == "json optional"
    {
        print("  ✅ JSON optional_nullable_string decoded correctly")
    }

    // Scenario B: Nullable fields are explicit null
    let jsonWithNulls = """
        {
            "name": "JSON Test 2",
            "creation_date": "2024-03-15",
            "creation_time": "2024-03-15T12:00:00Z", 
            "nullable_string": null,
            "optional_nullable_string": null
        }
        """

    let decodedWithNulls = try testJSONDecoding(
        jsonWithNulls, as: Extensive.self,
        description: "JSON with explicit nulls")

    if decodedWithNulls.nullableString.isNull {
        print("  ✅ JSON nullable_string null decoded correctly")
    }
    if decodedWithNulls.optionalNullableString?.isNull == true {
        print("  ✅ JSON optional_nullable_string null decoded correctly")
    }

    // Scenario C: Optional field is missing
    let jsonMissingOptional = """
        {
            "name": "JSON Test 3",
            "creation_date": "2024-03-15",
            "creation_time": "2024-03-15T12:00:00Z",
            "nullable_string": "present"
        }
        """

    let decodedMissingOptional = try testJSONDecoding(
        jsonMissingOptional, as: Extensive.self,
        description: "JSON with missing optional field")

    if decodedMissingOptional.optionalNullableString == nil {
        print("  ✅ Missing optional_nullable_string handled correctly")
    }

    // Test 5: Test convenience accessors
    print("--- Test 5: Convenience Accessors ---")

    // Test wrappedValue access
    if decodedAllValues.nullableString.wrappedValue == "json string" {
        print("  ✅ Nullable.wrappedValue works correctly")
    }

    if decodedAllValues.optionalNullableString?.wrappedValue == "json optional" {
        print("  ✅ Nullable<T>?.wrappedValue works correctly")
    }

    // Test native Swift optional patterns for Nullable<T>?
    if decodedAllValues.optionalNullableString != nil {
        print("  ✅ Missing detection (!= nil) works correctly")
    }

    if decodedAllValues.optionalNullableString?.isNull != true {
        print("  ✅ Null detection (?.isNull != true) works correctly")
    }

    if decodedAllValues.optionalNullableString?.wrappedValue != nil {
        print("  ✅ Value detection (?.wrappedValue != nil) works correctly")
    }

    // Test with null case
    if decodedWithNulls.optionalNullableString?.isNull == true {
        print("  ✅ Null detection (?.isNull == true) works correctly")
    }

    if decodedWithNulls.optionalNullableString?.wrappedValue == nil {
        print("  ✅ Value detection with null (?.wrappedValue == nil) works correctly")
    }

    // Test with missing case
    if decodedMissingOptional.optionalNullableString == nil {
        print("  ✅ Missing detection (== nil) works correctly")
    }

    print("✅ All nullable type tests passed!")
    print()
}
