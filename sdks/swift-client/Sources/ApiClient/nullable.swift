import Api
import Foundation

func runNullableTests() throws {
    print("=== Testing Nullable Tests ===")

    let extensive = Extensive(
        name: "Test Project",
        creationDate: .init(year: 2024, month: 3, day: 15)!,
        creationTime: .init(timeIntervalSince1970: 1_710_518_400),
        nullableString: .string("abc"),
        nullableOptionalInt: .number(4),
        optionalNullableString: .string("abc"),
        additionalProperties: ["priority": JSONValue.string("high")]
    )

    print(extensive)
}
