// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "app1",
    platforms: [
        .iOS(.v18)
    ],
    targets: [
        .executableTarget(
            name: "app1",
            path: "Sources"
        )
    ]
)
