#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
export DOCKER_STUB_DEBUG=/dev/tty

@test "Running a build against a single target" {
  stub docker \
    "build main.go : echo building golang binary"

  export BUILDKITE_PLUGIN_GOLANG_BUILD_BUILD="main.go"
  export BUILDKITE_PLUGIN_GOLANG_BUILD_PACKAGE="main.go"
  export BUILDKITE_PLUGIN_GOLANG_BUILD_TARGETS_0="1.10.0"

  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "building golang binary"

  unstub docker
  unset BUILDKITE_PLUGIN_GOLANG_BUILD_BUILD
  unset BUILDKITE_PLUGIN_GOLANG_BUILD_PACKAGE
  unset BUILDKITE_PLUGIN_GOLANG_BUILD_TARGETS_0
}
