# Golang Buildkite Plugin

A [Buildkite](https://buildkite.com/) plugin for building golang binaries against different versions of golang.

**This is in the process of being developed and is not ready for use yet!**

## Example

Build a golang binary with a specific golang version

```yml
steps:
  - plugins:
      golang-build#v1.0.0:
        build: main.go
        package: github.com/buildkite/github-release
        version: 1.10.0
```

## License

MIT (see [LICENSE](LICENSE))
