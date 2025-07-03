// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "ComplexFernTypes",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "ComplexFernTypes",
            targets: ["ComplexFernTypes"]
        ),
        .executable(
            name: "test",
            targets: ["TestApp"]
        )
    ],
    targets: [
        .target(
            name: "ComplexFernTypes",
            dependencies: []
        ),
        .executableTarget(
            name: "TestApp",
            dependencies: ["ComplexFernTypes"]
        )
    ]
) 