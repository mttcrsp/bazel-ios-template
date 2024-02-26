workspace(name = "bazel-ios-template")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# PodToBUILD

http_archive(
    name = "rules_pods",
    sha256 = "ffdfe8c7a4c73cca5d7b7a67daa6ccdd046355637dbdb9b1366d021b4ad339b5",
    urls = ["https://github.com/pinterest/PodToBUILD/releases/download/6.3.2-370b622/PodToBUILD.zip"],
)

# @unused Used by Pods.WORKSPACE
load("@rules_pods//BazelExtensions:workspace.bzl", "new_pod_repository")

# rules_swiftformat

http_archive(
    name = "rules_swift_tidy",
    sha256 = "16f0927d5838dad9edb64b5318e8b6e166c3c0873054290e09f6d0c7f335f425",
    strip_prefix = "rules_swiftformat-178f24d403a08b4b743cf65f0a0aeb46a2fe68d5",
    urls = ["http://github.com/cgrindel/rules_swiftformat/archive/178f24d.tar.gz"],
)

load("@rules_swift_tidy//swiftformat:deps.bzl", "swiftformat_rules_dependencies")

swiftformat_rules_dependencies()

load("@cgrindel_bazel_starlib//:deps.bzl", "bazel_starlib_dependencies")

bazel_starlib_dependencies()

load("@build_bazel_rules_swift//swift:repositories.bzl", "swift_rules_dependencies")

swift_rules_dependencies()

load("@build_bazel_rules_swift//swift:extras.bzl", "swift_rules_extra_dependencies")

swift_rules_extra_dependencies()

load("@rules_swift_tidy//swiftformat:defs.bzl", "swiftformat_register_prebuilt_toolchains")

swiftformat_register_prebuilt_toolchains()
