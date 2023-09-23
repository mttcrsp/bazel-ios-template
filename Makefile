proj:
	bazel run //app:xcodeproj

pods:
	bazel run @rules_pods//:update_pods -- --src_root $(PWD)

all:
	bazel build //app:all