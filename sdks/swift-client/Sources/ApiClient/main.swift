import Api
import Foundation

func main() {
    print("🧪 Starting Shape Encoding/Decoding Tests\n")

    do {
        // Test 1: Standalone shapes (without discriminant)
        print("=== Testing Standalone Shapes (No Discriminant) ===")

        let triangle = Triangle(a: 5.5, b: 4.0, c: 5.0)
        try testRoundTrip(triangle, description: "Triangle")

        let square = Square(length: 10.0)
        try testRoundTrip(square, description: "Square")

        let circle = Circle(
            radius: 5.0,
            additionalProperties: ["some_extra_int": JSONValue.number(123)]
        )
        try testRoundTrip(circle, description: "Circle")

        // Test 2: Shape discriminated union nested types (with discriminant)
        print("=== Testing Shape Nested Types (With Discriminant) ===")

        let shapeTriangle = Shape.Triangle(a: 3.0, b: 4.0, c: 5.0, )
        try testRoundTrip(shapeTriangle, description: "Shape.Triangle")

        let shapeSquare = Shape.Square(
            length: 10.0,
            additionalProperties: ["some_extra_string": JSONValue.string("some_extra_value")]
        )
        try testRoundTrip(shapeSquare, description: "Shape.Square")

        let shapeCircle = Shape.Circle(radius: 5.0)
        try testRoundTrip(shapeCircle, description: "Shape.Circle")

        // Test 3: Shape enum discriminated union
        print("=== Testing Shape Discriminated Union ===")

        // Note: Shape.encode() is empty in the autogenerated code, so we test decoding only
        print("Testing Shape decoding from JSON...")

        let triangleJSON: String =
            #"{"type":"triangle","a":6.0,"b":8.0,"c":10.0, "some_extra_field": "some_extra_value"}"#
        _ = try testJSONDecoding(triangleJSON, as: Shape.self, description: "Shape.triangle")

        let squareJSON = #"{"type":"square","length":15.0}"#
        _ = try testJSONDecoding(squareJSON, as: Shape.self, description: "Shape.square")

        let circleJSON = #"{"type":"circle","radius":7.5}"#
        _ = try testJSONDecoding(circleJSON, as: Shape.self, description: "Shape.circle")

        // Test 4: Invalid discriminant handling
        print("=== Testing Invalid Discriminant Handling ===")

        let invalidJSON = #"{"type":"pentagon","sides":5}"#
        do {
            _ = try testJSONDecoding(
                invalidJSON, as: Shape.self, description: "Invalid discriminant")
            throw TestError.unexpectedResult("Should have failed with invalid discriminant")
        } catch TestError.decodingFailed(let message) {
            print("  ✅ Correctly failed with invalid discriminant: \(message)")
            print()
        }

        // Test 5: Missing discriminant handling
        print("=== Testing Missing Discriminant Handling ===")

        let missingTypeJSON = #"{"a":1.0,"b":2.0,"c":3.0}"#
        do {
            _ = try testJSONDecoding(
                missingTypeJSON, as: Shape.self, description: "Missing discriminant")
            throw TestError.unexpectedResult("Should have failed with missing discriminant")
        } catch TestError.decodingFailed(let message) {
            print("  ✅ Correctly failed with missing discriminant: \(message)")
            print()
        }

        // Test 6: Malformed JSON handling
        print("=== Testing Malformed JSON Handling ===")

        let malformedJSON = #"{"type":"triangle","a":"not_a_number","b":2.0,"c":3.0}"#
        do {
            _ = try testJSONDecoding(malformedJSON, as: Shape.self, description: "Malformed JSON")
            throw TestError.unexpectedResult("Should have failed with malformed JSON")
        } catch TestError.decodingFailed(let message) {
            print("  ✅ Correctly failed with malformed JSON: \(message)")
            print()
        }

        print("🎉 All tests passed successfully!")

    } catch {
        print("❌ Test failed: \(error)")
        exit(1)
    }
}

main()
