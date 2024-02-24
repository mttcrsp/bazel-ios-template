// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "SPM",
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      .upToNextMajor(from: "1.8.2")
    ),
  ]
)
