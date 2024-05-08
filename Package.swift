// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "HUD")

package.platforms = [
    .iOS(.v15),
    .macOS(.v12),
    .tvOS(.v15)
]

package.products = [
    .library(
        name: "HUD",
        targets: ["HUD"]),
]

package.targets = [
    .target(
        name: "HUD",
        resources: [.process("Resources")]
    ),
]

package.swiftLanguageVersions = [.v5]
