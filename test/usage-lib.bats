#!/usr/bin/env bats

setup() {
  export d_opt_set=1
  export test_script_file="${PWD}/test/test_script"

  touch "$test_script_file"

  # disables dynamic source checking (vscode plugin vs running in project root)
  # shellcheck disable=2091,1090
  source "${PWD}/lib/usage-lib.sh"
}

@test "get_num_lines sets doc_header_line_count to 0 if script_name unset" {
  unset script_name

  run get_num_lines
  [[ "${status}" -eq 0 ]]
}

teardown() {
  rm "$test_script_file"
}
