// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "app1",
    platforms: [
        .iOS(.v17)
    ],
    targets: [
        .executableTarget(
            name: "app1",
            path: "Sources"
        )
    ]
)
