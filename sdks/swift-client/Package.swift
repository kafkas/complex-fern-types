// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "ApiClient",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .executable(
            name: "ApiClient",
            targets: ["ApiClient"]
        )
    ],
    dependencies: [
        .package(name: "Api", path: "../swift")
    ],
    targets: [
        .executableTarget(
            name: "ApiClient",
            dependencies: [
                .product(name: "Api", package: "Api")
            ]
        )
    ]
)
