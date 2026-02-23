// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "app1",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .iOSApplication(
            name: "app1",
            targets: ["app1"],
            bundleIdentifier: "com.example.app1",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .flamingo),
            accentColor: .presetColor(.pink),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "app1",
            path: "Sources"
        )
    ]
)
