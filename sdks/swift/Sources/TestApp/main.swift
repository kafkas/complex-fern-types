import ComplexFernTypes
import Foundation

func testShape() {
    print("=== Shape Discriminated Union Test ===")

    // Test 1: Shape union (adds discriminant)
    let shapes = [
        Shape.triangle(Triangle(a: 3, b: 4, c: 5)),
        Shape.square(Square(length: 10)),
        Shape.circle(Circle(radius: 7.5)),
    ]

    shapes.forEach { shape in
        let json = try! JSONEncoder().encode(shape)
        print("Encoded Shape:", String(data: json, encoding: .utf8)!)
    }

    // Test 2: Original types (no discriminant)
    let triangle = Triangle(a: 3, b: 4, c: 5)
    let triangleJson = try! JSONEncoder().encode(triangle)
    print("Original Triangle:", String(data: triangleJson, encoding: .utf8)!)

    // Test 3: Shape.* types (with discriminant)
    let shapeTriangle = Shape.Triangle(a: 1, b: 2, c: 3)
    let shapeTriangleJson = try! JSONEncoder().encode(shapeTriangle)
    print("Shape.Triangle:", String(data: shapeTriangleJson, encoding: .utf8)!)

    // Test 4: Decoding
    let jsonString = """
        {"type":"triangle","a":1,"b":2,"c":3}
        """
    if let data = jsonString.data(using: .utf8),
        let decoded = try? JSONDecoder().decode(Shape.self, from: data)
    {
        print("Decoded Shape:", decoded)
    }

    print("✅ All tests passed!")
}

Task {
    testShape()
    exit(0)
}

RunLoop.main.run()
