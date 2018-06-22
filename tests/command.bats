#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
# export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty

@test "Running a build against a multiple target" {
  export BUILDKITE_ORGANIZATION_SLUG="buildkite"
  export BUILDKITE_PIPELINE_SLUG="agent"
  export BUILDKITE_PLUGIN_GOLANG_BUILD_DEBUG=true
  export BUILDKITE_PLUGIN_GOLANG_BUILD_BUILD="main.go"
  export BUILDKITE_PLUGIN_GOLANG_BUILD_PACKAGE="github.com/buildkite/agent"
  export BUILDKITE_PLUGIN_GOLANG_BUILD_BIN_PREFIX="buildkite-agent"
  export BUILDKITE_PLUGIN_GOLANG_BUILD_TARGETS_0_VERSION="1.10.1"
  export BUILDKITE_PLUGIN_GOLANG_BUILD_TARGETS_0_GOOS="linux"
  export BUILDKITE_PLUGIN_GOLANG_BUILD_TARGETS_0_GOARCH="amd64"
  export BUILDKITE_PLUGIN_GOLANG_BUILD_TARGETS_1_VERSION="1.10.2"
  export BUILDKITE_PLUGIN_GOLANG_BUILD_TARGETS_1_GOOS="darwin"
  export BUILDKITE_PLUGIN_GOLANG_BUILD_TARGETS_1_GOARCH="386"


  expected_yaml=$(cat <<YAML
steps:
  - name: ":go: linux/amd64"
    command: go build -v -o 'buildkite-agent-linux-amd64' 'main.go'
    plugins:
      golang#v2.0.0:
        import: buildkite.com/buildkite/agent
        version: 1.10.1
        environment:
          - GOOS=linux
          - GOARCH=amd64
  - name: ":go: darwin/386"
    command: go build -v -o 'buildkite-agent-darwin-386' 'main.go'
    plugins:
      golang#v2.0.0:
        import: buildkite.com/buildkite/agent
        version: 1.10.2
        environment:
          - GOOS=darwin
          - GOARCH=386
YAML
  )

  stub buildkite-agent \
    "pipeline upload : exit 0"

  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "$expected_yaml"

  unstub buildkite-agent
}
