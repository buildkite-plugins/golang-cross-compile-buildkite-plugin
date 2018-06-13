# Golang Build Buildkite Plugin

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) for building golang binaries against different versions of golang.

## Example

Build a golang binary with a variety of targets. This makes use of golang's native cross-compile facilities.

```yml
steps:
  - plugins:
      - golang-build#v1.0.0:
          build: main.go
          package: github.com/buildkite/github-release
          vars:
            "main.Version": "${BUILDKITE_TAG}"
          flags: ["-s", "-w"]
          targets:
            - version: 1.10.2
              goos: linux
              goarch: amd64
            - version: 1.10.2
              goos: windows
              goarch: amd64
            - version: 1.10.2
              goos: darwin
              goarch: amd64
```

## License

MIT (see [LICENSE](LICENSE))
