import Api
import Foundation

func main() async {
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
        
        // Test Shape enum encoding/decoding round trips
        let triangleShape: Shape = .triangle(Shape.Triangle(a: 6.0, b: 8.0, c: 10.0))
        try testRoundTrip(triangleShape, description: "Shape.triangle enum case")
        
        let squareShape: Shape = .square(Shape.Square(length: 15.0))
        try testRoundTrip(squareShape, description: "Shape.square enum case")
        
        let circleShape: Shape = .circle(Shape.Circle(radius: 7.5))
        try testRoundTrip(circleShape, description: "Shape.circle enum case")
        
        // Test Shape enum with additional properties
        let triangleShapeWithExtras: Shape = .triangle(Shape.Triangle(
            a: 1.0, 
            b: 2.0, 
            c: 3.0,
            additionalProperties: ["custom_field": JSONValue.string("custom_value")]
        ))
        try testRoundTrip(triangleShapeWithExtras, description: "Shape.triangle with additional properties")
        
        // Test decoding from JSON strings
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

        // Test 7: DocumentPath undiscriminated union
        print("=== Testing DocumentPath Undiscriminated Union ===")
        
        // Test string variant
        let stringPath = DocumentPath.string("users/123")
        try testRoundTrip(stringPath, description: "DocumentPath.string")
        
        // Test string array variant  
        let stringArrayPath = DocumentPath.stringArray(["users", "123", "profile"])
        try testRoundTrip(stringArrayPath, description: "DocumentPath.stringArray")
        
        // Test int variant
        let intPath = DocumentPath.int(42)
        try testRoundTrip(intPath, description: "DocumentPath.int")
        
        // Test DocumentPath decoding from JSON strings
        print("Testing DocumentPath decoding from JSON...")
        
        let stringJSON = #""users/123""#
        let decodedString = try testJSONDecoding(stringJSON, as: DocumentPath.self, description: "DocumentPath from string JSON")
        if case .string(let value) = decodedString {
            print("  ✅ Correctly decoded as string: \(value)")
        } else {
            throw TestError.unexpectedResult("Expected string variant")
        }
        
        let stringArrayJSON = #"["users", "123", "profile"]"#
        let decodedStringArray = try testJSONDecoding(stringArrayJSON, as: DocumentPath.self, description: "DocumentPath from string array JSON")
        if case .stringArray(let value) = decodedStringArray {
            print("  ✅ Correctly decoded as string array: \(value)")
        } else {
            throw TestError.unexpectedResult("Expected stringArray variant")
        }
        
        let intJSON = #"42"#
        let decodedInt = try testJSONDecoding(intJSON, as: DocumentPath.self, description: "DocumentPath from int JSON")
        if case .int(let value) = decodedInt {
            print("  ✅ Correctly decoded as int: \(value)")
        } else {
            throw TestError.unexpectedResult("Expected int variant")
        }
        
        // Test 8: DocumentPath with ambiguous cases
        print("=== Testing DocumentPath Ambiguous Cases ===")
        
        // Test numeric string (should be decoded as string, not int)
        let numericStringJSON = #""123""#
        let decodedNumericString = try testJSONDecoding(numericStringJSON, as: DocumentPath.self, description: "DocumentPath from numeric string")
        if case .string(let value) = decodedNumericString {
            print("  ✅ Correctly decoded numeric string as string: \(value)")
        } else {
            throw TestError.unexpectedResult("Expected string variant for numeric string")
        }
        
        // Test single-element array with string (should be decoded as array, not string)
        let singleElementArrayJSON = #"["single"]"#
        let decodedSingleArray = try testJSONDecoding(singleElementArrayJSON, as: DocumentPath.self, description: "DocumentPath from single-element array")
        if case .stringArray(let value) = decodedSingleArray {
            print("  ✅ Correctly decoded single-element array as stringArray: \(value)")
        } else {
            throw TestError.unexpectedResult("Expected stringArray variant for single-element array")
        }
        
        // Test 9: DocumentPath invalid type handling
        print("=== Testing DocumentPath Invalid Type Handling ===")
        
        let booleanJSON = #"true"#
        do {
            _ = try testJSONDecoding(booleanJSON, as: DocumentPath.self, description: "Invalid boolean type")
            throw TestError.unexpectedResult("Should have failed with invalid boolean type")
        } catch TestError.decodingFailed(let message) {
            print("  ✅ Correctly failed with invalid boolean type: \(message)")
        }
        
        let objectJSON = #"{"key": "value"}"#
        do {
            _ = try testJSONDecoding(objectJSON, as: DocumentPath.self, description: "Invalid object type")
            throw TestError.unexpectedResult("Should have failed with invalid object type")
        } catch TestError.decodingFailed(let message) {
            print("  ✅ Correctly failed with invalid object type: \(message)")
        }
        
        // Test array with non-string elements
        let mixedArrayJSON = #"["string", 123, true]"#
        do {
            _ = try testJSONDecoding(mixedArrayJSON, as: DocumentPath.self, description: "Invalid mixed array type")
            throw TestError.unexpectedResult("Should have failed with invalid mixed array type")
        } catch TestError.decodingFailed(let message) {
            print("  ✅ Correctly failed with invalid mixed array type: \(message)")
        }
        
        print()

        // Test 10: File download functionality
        print("=== Testing File Download ===")
        
        do {
            let apiClient = ApiClient(baseURL: "http://localhost:8080")
            
            print("Downloading file...")
            let fileData = try await apiClient.service.downloadFile()
            print("  ✅ File downloaded successfully!")
            print("  📄 File size: \(fileData.count) bytes")
            
            // Check if the downloaded data looks like a PDF
            let dataString = String(data: fileData.prefix(10), encoding: .utf8) ?? ""
            if dataString.hasPrefix("%PDF") {
                print("  ✅ Downloaded content appears to be a PDF file")
            } else {
                print("  ⚠️  Downloaded content might not be a PDF (first 10 bytes: \(dataString))")
            }
            
            // Optionally save the file to verify
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = documentsPath.appendingPathComponent("downloaded_sample.pdf")
            try fileData.write(to: filePath)
            print("  💾 File saved to: \(filePath.path)")
            
        } catch {
            print("  ❌ File download failed: \(error)")
            throw error
        }
        
        // Test 11: File upload functionality
        print("=== Testing File Upload ===")
        
        do {
            let apiClient = ApiClient(baseURL: "http://localhost:8080")
            
            // Read the Swift icon PNG file for upload
            let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            let pngFilePath = currentDirectory.appendingPathComponent("swift-icon.png")
            
            guard let testFileData = try? Data(contentsOf: pngFilePath) else {
                throw TestError.unexpectedResult("Could not read swift-icon.png file")
            }
            
            print("Reading Swift icon PNG file for upload...")
            print("  📄 File: swift-icon.png")
            print("  📄 File size: \(testFileData.count) bytes")
            print("  📝 Content type: PNG image")
            
            // Verify it's a valid PNG by checking the header
            let pngHeader = testFileData.prefix(8)
            let expectedPNGHeader = Data([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])
            if pngHeader == expectedPNGHeader {
                print("  ✅ Valid PNG file format confirmed")
            } else {
                print("  ⚠️  File may not be a valid PNG")
            }
            
            print("Uploading PNG file to server...")
            let uploadResponse = try await apiClient.service.uploadFile(request: testFileData)
            print("  ✅ File uploaded successfully!")
            print("  📤 Server response: \(uploadResponse)")
            
            // Verify the response indicates success
            if uploadResponse.contains("uploaded successfully") && uploadResponse.contains("\(testFileData.count) bytes") {
                print("  ✅ Upload verified - server received correct file size")
                if uploadResponse.contains("uploaded_file.png") {
                    print("  ✅ File saved with correct PNG extension")
                }
            } else {
                print("  ⚠️  Upload response may indicate an issue")
            }
            
        } catch {
            print("  ❌ File upload failed: \(error)")
            throw error
        }

        print()

        print("🎉 All tests passed successfully!")

    } catch {
        print("❌ Test failed: \(error)")
        exit(1)
    }
}

await main()
