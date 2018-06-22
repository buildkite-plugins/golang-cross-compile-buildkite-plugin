# Golang Build Buildkite Plugin

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) for building golang binaries against different versions of golang.

This plugin creates a step for each build target and runs them in parallel. It's ideal for build matrixes against multiple architectures, operating systems and golang versions.

If you just need to build against a single target, use the simpler [golang plugin](https://github.com/buildkite-plugins/golang-buildkite-plugin).

## Example

Build a golang binary with a variety of targets.

```yml
steps:
  - plugins:
      - golang-build#v1.0.0:
          build: main.go
          package: github.com/buildkite/github-release
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
