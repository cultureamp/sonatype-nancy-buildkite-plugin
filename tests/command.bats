#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment the following line to debug stub failures
# export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty

@test "Runs with the latest version of Go by default" {
  # export BUILDKITE_PLUGIN_SONATYPE_NANCY_GO_VERSION=""

  stub docker \
    'pull * : echo $@' \
    'pull * : echo $@' \
    'run * : echo $@' \
    'run * : echo $@'

  run "$PWD/hooks/command"

  unstub docker

  expected_go_image="1-alpine"

  assert_success
  assert_output --partial "pull sonatypecommunity/nancy:latest"
  assert_output --partial "pull golang:${expected_go_image}"
  assert_output --partial "run --rm -it -v /plugin:/app -w /app golang:${expected_go_image} go list -json -m all"
  assert_output --partial "run --rm -i sonatypecommunity/nancy:latest sleuth"
}

@test "Fails when Nancy fails" {
  # export BUILDKITE_PLUGIN_SONATYPE_NANCY_GO_VERSION=""

  stub docker \
    'pull * : echo $@' \
    'pull * : echo $@' \
    'run * : echo $@' \
    'run * : echo $@; exit 1'

  run "$PWD/hooks/command"

  unstub docker

  expected_go_image="1-alpine"

  assert_failure
  assert_output --partial "pull sonatypecommunity/nancy:latest"
  assert_output --partial "pull golang:${expected_go_image}"
  assert_output --partial "run --rm -it -v /plugin:/app -w /app golang:${expected_go_image} go list -json -m all"
  assert_output --partial "run --rm -i sonatypecommunity/nancy:latest sleuth"
}

@test "Uses Alpine Go image unless forced" {
  export BUILDKITE_PLUGIN_SONATYPE_NANCY_GO_VERSION="1.17"

  stub docker \
    'pull * : echo $@' \
    'pull * : echo $@' \
    'run * : echo $@' \
    'run * : echo $@'

  run "$PWD/hooks/command"

  unstub docker

  expected_go_image="1.17-alpine"

  assert_success
  assert_output --partial "pull sonatypecommunity/nancy:latest"
  assert_output --partial "pull golang:${expected_go_image}"
  assert_output --partial "run --rm -it -v /plugin:/app -w /app golang:${expected_go_image} go list -json -m all"
  assert_output --partial "run --rm -i sonatypecommunity/nancy:latest sleuth"
}


@test "Uses specific Go image when supplied" {
  export BUILDKITE_PLUGIN_SONATYPE_NANCY_GO_VERSION="1.17-bullseye"

  stub docker \
    'pull * : echo $@' \
    'pull * : echo $@' \
    'run * : echo $@' \
    'run * : echo $@'

  run "$PWD/hooks/command"

  unstub docker

  expected_go_image="1.17-bullseye"

  assert_success
  assert_output --partial "pull sonatypecommunity/nancy:latest"
  assert_output --partial "pull golang:${expected_go_image}"
  assert_output --partial "run --rm -it -v /plugin:/app -w /app golang:${expected_go_image} go list -json -m all"
  assert_output --partial "run --rm -i sonatypecommunity/nancy:latest sleuth"
}
