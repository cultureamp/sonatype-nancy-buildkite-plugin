# Sonatype Nancy Buildkite Plugin

A Buildkite plugin for using Sonatype's community [Nancy dependency
checker](https://github.com/sonatype-nexus-community/nancy) for Go.

This plugin is authored separately to Nancy, and is in no way connected to or
affiliated with Sonatype.

## Overview

This plugin uses a Go image to extract the dependency list for the current
project, and passes that output through Nancy. The build fails if Nancy
indicates that vulnerable dependencies are found.

Note that if Nancy configuration is committed to the repository, it will be
respected by default.

## Example

Add the following to your `pipeline.yml`:

```yml
steps:
  - plugins:
      - cultureamp/sonatype-nancy#v1.0.0
```

Optionally, a specific Go version or a working directory can be supplied:

```yml
steps:
  - plugins:
      - cultureamp/sonatype-nancy#v1.0.0:
          go-version: '1.17'
          working-directory: 'src'
```

## Configuration

### `go-version` (Optional, string)

The version of the Go Docker image to use. By default, '1-alpine' will be used,
and '-alpine' will be appended to the image unless a specific runtime is
supplied. For example, the version `1.17` will result in the use of the
`1.17-alpine` image.

To use a different base, specify the complete tag name, e.g. `1.17-bullseye`.

### `working-directory` (Optional, string)

The working directory to use when discovering dependencies and Nancy
configuration. By default this is the root of the repository.

## Developing

To run the tests:

```shell
docker-compose run --rm tests
```

## Contributing

1. Fork the repo
2. Make the changes
3. Run the tests
4. Commit and push your changes
5. Send a pull request
