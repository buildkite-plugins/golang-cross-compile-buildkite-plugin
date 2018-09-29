#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
# export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty

@test "Running a build against a multiple target" {
  export BUILDKITE_ORGANIZATION_SLUG="buildkite"
  export BUILDKITE_PIPELINE_SLUG="agent"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_DEBUG=true
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_BUILD="main.go"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_PACKAGE="github.com/buildkite/agent"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_BIN_PREFIX="buildkite-agent"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_0_VERSION="1.10.1"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_0_GOOS="linux"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_0_GOARCH="amd64"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_1_VERSION="1.10.2"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_1_GOOS="darwin"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_1_GOARCH="386"

  expected_yaml=$(cat <<YAML
steps:
  - name: ":go: 1.10.1 :linux: amd64"
    command: go build -v -o 'buildkite-agent-linux-amd64' 'main.go'
    artifact_paths:
      - "buildkite-agent-linux-amd64"
    plugins:
      golang#v2.0.0:
        import: buildkite.com/buildkite/agent
        version: 1.10.1
        environment:
          - GOOS=linux
          - GOARCH=amd64
  - name: ":go: 1.10.2 :darwin: 386"
    command: go build -v -o 'buildkite-agent-darwin-386' 'main.go'
    artifact_paths:
      - "buildkite-agent-darwin-386"
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

@test "Running a windows build creates an exe" {
  export BUILDKITE_ORGANIZATION_SLUG="buildkite"
  export BUILDKITE_PIPELINE_SLUG="agent"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_DEBUG=true
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_BUILD="main.go"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_PACKAGE="github.com/buildkite/agent"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_BIN_PREFIX="buildkite-agent"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_0_VERSION="1.10.1"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_0_GOOS="windows"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_0_GOARCH="amd64"

  expected_yaml=$(cat <<YAML
steps:
  - name: ":go: 1.10.1 :windows: amd64"
    command: go build -v -o 'buildkite-agent-windows-amd64.exe' 'main.go'
    artifact_paths:
      - "buildkite-agent-windows-amd64.exe"
    plugins:
      golang#v2.0.0:
        import: buildkite.com/buildkite/agent
        version: 1.10.1
        environment:
          - GOOS=windows
          - GOARCH=amd64
YAML
  )

  stub buildkite-agent \
    "pipeline upload : exit 0"


  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "$expected_yaml"

  unstub buildkite-agent
}

@test "Running static build" {
  export BUILDKITE_ORGANIZATION_SLUG="buildkite"
  export BUILDKITE_PIPELINE_SLUG="agent"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_DEBUG=true
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_BUILD="main.go"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_PACKAGE="github.com/buildkite/agent"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_BIN_PREFIX="buildkite-agent"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_STATIC="true"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_0_VERSION="1.10.1"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_0_GOOS="linux"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_0_GOARCH="amd64"

  expected_yaml=$(cat <<YAML
steps:
  - name: ":go: 1.10.1 :linux: amd64"
    command: go build -v -o 'buildkite-agent-linux-amd64' -a -ldflags '-d -s -w' -tags netgo -installsuffix netgo 'main.go'
    artifact_paths:
      - "buildkite-agent-linux-amd64"
    plugins:
      golang#v2.0.0:
        import: buildkite.com/buildkite/agent
        version: 1.10.1
        environment:
          - GOOS=linux
          - GOARCH=amd64
          - CGO_ENABLED=0
YAML
  )

  stub buildkite-agent \
    "pipeline upload : exit 0"


  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "$expected_yaml"

  unstub buildkite-agent
}

@test "Running a build with gomodules" {
  export BUILDKITE_ORGANIZATION_SLUG="buildkite"
  export BUILDKITE_PIPELINE_SLUG="agent"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_DEBUG=true
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_BUILD="main.go"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_PACKAGE="github.com/buildkite/agent"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_BIN_PREFIX="buildkite-agent"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_0_VERSION="1.10.1"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_0_GOOS="linux"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_0_GOARCH="amd64"
  export BUILDKITE_PLUGIN_GOLANG_CROSS_COMPILE_TARGETS_0_GOMODULE="on"

  expected_yaml=$(cat <<YAML
steps:
  - name: ":go: 1.10.1 :linux: amd64"
    command: go build -v -o 'buildkite-agent-linux-amd64' 'main.go'
    artifact_paths:
      - "buildkite-agent-linux-amd64"
    plugins:
      golang#v2.0.0:
        import: buildkite.com/buildkite/agent
        version: 1.10.1
        environment:
          - GOOS=linux
          - GOARCH=amd64
          - GO111MODULE=on
YAML
  )

  stub buildkite-agent \
    "pipeline upload : exit 0"


  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "$expected_yaml"

  unstub buildkite-agent
}
