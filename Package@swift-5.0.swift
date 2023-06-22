// swift-tools-version: 5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let package = Package(name: "HUD")

package.platforms = [.iOS(.v14)]

package.products = [
    .library(
        name: "HUD",
        targets: ["HUD"]),
]

package.targets = [
    .target(
        name: "HUD"),
]

package.swiftLanguageVersions = [.v5]
