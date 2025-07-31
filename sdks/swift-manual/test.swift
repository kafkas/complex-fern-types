#!/usr/bin/env swift

// Simple test file that includes the types directly
// To run this file, use: swift test.swift

import Foundation

// Include the types directly (copied from the package)
public struct Triangle: Codable, Hashable, Sendable {
  public let type: String = "triangle"
  public let a: Double
  public let b: Double
  public let c: Double

  public init(a: Double, b: Double, c: Double) {
    self.a = a
    self.b = b
    self.c = c
  }

  private enum CodingKeys: String, CodingKey {
    case type, a, b, c
  }
}

public struct Square: Codable, Hashable, Sendable {
  public let type: String = "square"
  public let length: Double

  public init(length: Double) {
    self.length = length
  }

  private enum CodingKeys: String, CodingKey {
    case type, length
  }
}

public struct Circle: Codable, Hashable, Sendable {
  public let type: String = "circle"
  public let radius: Double

  public init(radius: Double) {
    self.radius = radius
  }

  private enum CodingKeys: String, CodingKey {
    case type, radius
  }
}

// Create a simple triangle
let myTriangle = Triangle(a: 6.0, b: 8.0, c: 10.0)
print("My triangle has sides: \(myTriangle.a), \(myTriangle.b), \(myTriangle.c)")

// Create a simple square
let mySquare = Square(length: 7.0)
print("My square has length: \(mySquare.length)")

// Create a simple circle
let myCircle = Circle(radius: 2.5)
print("My circle has radius: \(myCircle.radius)")

// Test JSON encoding
let encoder = JSONEncoder()
do {
    let triangleData = try encoder.encode(myTriangle)
    let triangleJSON = String(data: triangleData, encoding: .utf8) ?? "Error"
    print("\nTriangle JSON: \(triangleJSON)")
} catch {
    print("Error encoding: \(error)")
} 