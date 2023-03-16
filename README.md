# Golang Cross Compile Buildkite Plugin [![Build status](https://badge.buildkite.com/ffa65d9131a0e6ea354d16a61961ec147e2e51d3447413d0dc.svg?branch=master)](https://buildkite.com/buildkite/plugins-golang-cross-compile)

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) for building golang binaries against different operating systems, archictures and versions of golang.

This plugin creates a step for each build target and runs them in parallel. It's ideal for build matrixes against multiple architectures, operating systems and golang versions.

If you just need to build against a single target, use the simpler [golang plugin](https://github.com/buildkite-plugins/golang-buildkite-plugin), or if you want to avoid using docker you can use the the [gopath checkout plugin](https://github.com/buildkite-plugins/gopath-checkout-buildkite-plugin).

## Example

Build a golang binary across a set of architectures and versions.

```yml
steps:
  - plugins:
      - golang-cross-compile#v1.4.0:
          build: main.go
          import: github.com/buildkite/example
          targets:
            - version: "1.11"
              goos: linux
              goarch: amd64
              gomodule: "on"
            - version: "1.11"
              goos: windows
              goarch: amd64
              gomodule: "on"
            - version: "1.11"
              goos: darwin
              goarch: amd64
              gomodule: "on"
```

## Configuration

### `build` (optional)

The golang file to build. Can either be a relative package like `./cmd/helloworld` or a path to a file like `cli/main.go`. Defaults to `main.go`

Example: `1.10.2`

### `import`(required)

The golang package to use in the gopath in the container.

Exmaple: `github.com/buildkite/agent`

### `bin-prefix`(optional)

By default the basename of the import package is used for the binary name, use `bin-prefix` to specify a different one.

Exmaple: `buildkite-agent`

### `static`(optional)

Create a statically compiled binary, useful for alpine docker images.

### `targets` (required)

A list of targets to run in parallel. Each target can have a `version`, `goos`, `goarch` and `gomodule`.

## License

MIT (see [LICENSE](LICENSE))
