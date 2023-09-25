workspace(name = "bazel-ios-template")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
  name = "rules_pods",
  urls = ["https://github.com/pinterest/PodToBUILD/releases/download/6.3.2-370b622/PodToBUILD.zip"],
  sha256 = "ffdfe8c7a4c73cca5d7b7a67daa6ccdd046355637dbdb9b1366d021b4ad339b5",
)

load("@rules_pods//BazelExtensions:workspace.bzl", "new_pod_repository")
