load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("@rules_xcodeproj//xcodeproj:defs.bzl", "xcodeproj")
load("@rules_cc//cc:defs.bzl", "objc_library")

swift_library(
    name = "app_lib",
    srcs = ["App.swift"],
    tags = ["manual"],
    visibility = ["//visibility:public"],
    deps = ["@swiftpkg_swift_composable_architecture//:Sources_ComposableArchitecture"],
)

ios_application(
    name = "app",
    bundle_id = "com.example.app",
    families = ["iphone"],
    infoplists = ["Info.plist"],
    minimum_os_version = "16.0",
    sdk_frameworks = [
        "SystemConfiguration",
        "MobileCoreServices",
    ],
    visibility = ["//visibility:public"],
    deps = [":app_lib"],
)

xcodeproj(
    name = "xcodeproj",
    project_name = "App",
    tags = ["manual"],
    top_level_targets = [":app"],
)
