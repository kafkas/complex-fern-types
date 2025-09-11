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
        nullableString: .value("hello world"),              // nullable<string> with value
        nullableOptionalInt: .value(42),                    // nullable<optional<int>> with value  
        optionalNullableString: .value("optional value"),   // optional<nullable<string>> with value
        additionalProperties: ["priority": JSONValue.string("high")]
    )
    
    try testRoundTrip(extensiveWithValues, description: "Extensive with all values present")
    
    // Verify the values are accessible
    if case .value(let stringValue) = extensiveWithValues.nullableString {
        print("  ✅ nullableString has value: '\(stringValue)'")
    } else {
        throw TestError.unexpectedResult("nullableString should have a value")
    }
    
    if case .value(let intValue) = extensiveWithValues.nullableOptionalInt {
        print("  ✅ nullableOptionalInt has value: \(intValue)")
    } else {
        throw TestError.unexpectedResult("nullableOptionalInt should have a value")  
    }
    
    if let optionalNullable = extensiveWithValues.optionalNullableString,
       case .value(let optionalValue) = optionalNullable {
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
        nullableString: .null,                              // nullable<string> is null
        nullableOptionalInt: .null,                         // nullable<optional<int>> is null
        optionalNullableString: .null                       // optional<nullable<string>> is null
    )
    
    try testRoundTrip(extensiveWithNulls, description: "Extensive with nullable fields as null")
    
    // Verify null states
    if extensiveWithNulls.nullableString.isNull {
        print("  ✅ nullableString is correctly null")
    } else {
        throw TestError.unexpectedResult("nullableString should be null")
    }
    
    if extensiveWithNulls.nullableOptionalInt.isNull {
        print("  ✅ nullableOptionalInt is correctly null") 
    } else {
        throw TestError.unexpectedResult("nullableOptionalInt should be null")
    }
    
    if let optionalNullable = extensiveWithNulls.optionalNullableString,
       optionalNullable.isNull {
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
        nullableString: .value("present"),                  // nullable<string> with value
        nullableOptionalInt: .null,                         // nullable<optional<int>> is null
        optionalNullableString: nil                         // optional<nullable<string>> missing entirely
    )
    
    try testRoundTrip(extensiveWithMissing, description: "Extensive with optional field missing")
    
    // Verify missing state
    if extensiveWithMissing.optionalNullableString == nil {
        print("  ✅ optionalNullableString is correctly missing (nil)")
    } else {
        throw TestError.unexpectedResult("optionalNullableString should be nil/missing")
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
        "nullable_optional_int": 99,
        "optional_nullable_string": "json optional"
    }
    """
    
    let decodedAllValues = try testJSONDecoding(jsonAllValues, as: Extensive.self, 
                                                description: "JSON with all values")
    
    if case .value(let str) = decodedAllValues.nullableString,
       str == "json string" {
        print("  ✅ JSON nullable_string decoded correctly")
    }
    
    if case .value(let int) = decodedAllValues.nullableOptionalInt,
       int == 99 {
        print("  ✅ JSON nullable_optional_int decoded correctly")
    }
    
    if let opt = decodedAllValues.optionalNullableString,
       case .value(let optStr) = opt,
       optStr == "json optional" {
        print("  ✅ JSON optional_nullable_string decoded correctly")
    }
    
    // Scenario B: Nullable fields are explicit null
    let jsonWithNulls = """
    {
        "name": "JSON Test 2",
        "creation_date": "2024-03-15",
        "creation_time": "2024-03-15T12:00:00Z", 
        "nullable_string": null,
        "nullable_optional_int": null,
        "optional_nullable_string": null
    }
    """
    
    let decodedWithNulls = try testJSONDecoding(jsonWithNulls, as: Extensive.self,
                                                description: "JSON with explicit nulls")
    
    if decodedWithNulls.nullableString.isNull {
        print("  ✅ JSON nullable_string null decoded correctly")
    }
    
    if decodedWithNulls.nullableOptionalInt.isNull {
        print("  ✅ JSON nullable_optional_int null decoded correctly")  
    }
    
    if let opt = decodedWithNulls.optionalNullableString,
       opt.isNull {
        print("  ✅ JSON optional_nullable_string null decoded correctly")
    }
    
    // Scenario C: Optional field is missing
    let jsonMissingOptional = """
    {
        "name": "JSON Test 3",
        "creation_date": "2024-03-15",
        "creation_time": "2024-03-15T12:00:00Z",
        "nullable_string": "present",
        "nullable_optional_int": 123
    }
    """
    
    let decodedMissingOptional = try testJSONDecoding(jsonMissingOptional, as: Extensive.self,
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
    
    if let opt = decodedAllValues.optionalNullableString,
       opt.wrappedValue == "json optional" {
        print("  ✅ OptionalNullable.wrappedValue works correctly")  
    }
    
    // Test extension methods on Optional<Nullable<T>>
    if !decodedAllValues.optionalNullableString.isMissing {
        print("  ✅ Optional<Nullable<T>>.isMissing works correctly")
    }
    
    if !decodedAllValues.optionalNullableString.isExplicitlyNull {
        print("  ✅ Optional<Nullable<T>>.isExplicitlyNull works correctly")
    }
    
    if decodedAllValues.optionalNullableString.hasValue {
        print("  ✅ Optional<Nullable<T>>.hasValue works correctly")
    }
    
    // Test with null case
    if decodedWithNulls.optionalNullableString.isExplicitlyNull {
        print("  ✅ Optional<Nullable<T>>.isExplicitlyNull detects null correctly")
    }
    
    if !decodedWithNulls.optionalNullableString.hasValue {
        print("  ✅ Optional<Nullable<T>>.hasValue detects null correctly")
    }
    
    // Test with missing case
    if decodedMissingOptional.optionalNullableString.isMissing {
        print("  ✅ Optional<Nullable<T>>.isMissing detects missing correctly")
    }
    
    print("✅ All nullable type tests passed!")
    print()
}
