// swift-tools-version: 5.9
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
