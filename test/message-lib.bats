#!/usr/bin/env bats

setup() {
  export d_opt_set=1

  # disables dynamic source checking (vscode plugin vs running in project root)
  # shellcheck disable=2091,1090
  source "${PWD}/lib/message-lib.sh"
}

@test "invoking debug with unset 'd_opt_set' results in no output and status 0" {
  unset d_opt_set

  run debug "test message"
  [[ ${status} -eq 0 ]]
  [[ -z "${output}" ]]
}

@test "invoking debug with 'd_opt_set=0' results in no output and status 0" {
  d_opt_set=0

  run debug "test message"
  [[ ${status} -eq 0 ]]
  [[ -z "${output}" ]]
}

@test "invoking debug with 'd_opt_set=1' results in formatted output" {
  run debug "test message"
  [[ ${status} -eq 0 ]]
  [[ "${output}" =~ 'test message' ]]
}

@test "invoking info results in formatted output" {
  run info "test message"
  [[ ${status} -eq 0 ]]
  [[ "${output}" =~ 'test message' ]]
}

@test "invoking success results in formatted output" {
  run success "test message"
  [[ ${status} -eq 0 ]]
  [[ "${output}" =~ 'test message' ]]
}
