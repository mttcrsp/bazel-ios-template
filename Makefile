proj:
	bazel run //app:xcodeproj

pods:
	bazel run @rules_pods//:update_pods -- --src_root $(PWD)

spm:
	bazel run //:swift_update_pkgs

all:
	bazel build //app:all