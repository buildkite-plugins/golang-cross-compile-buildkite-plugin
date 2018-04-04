# Golang Buildkite Plugin (Alpha)

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) for building golang binaries against different versions of golang.

## Example

Build a golang binary with a specific golang version:

```yml
steps:
  - plugins:
      golang-build#v1.0.0:
        build: main.go
        package: github.com/buildkite/github-release
        golang:
          version: 1.10.0
          os: linux
          arch: amd64
```

## License

MIT (see [LICENSE](LICENSE))
