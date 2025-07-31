public enum Shape: Codable, Hashable, Sendable {
    case triangle(Triangle)
    case square(Square)
    case circle(Circle)

    struct Triangle {
        public let triangle: Triangle
    }

    struct Square {
        public let square: Square
    }

    struct Circle {
        public let circle: Circle
    }
}