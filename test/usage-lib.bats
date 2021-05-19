#!/usr/bin/env bats

setup() {
  # $PWD within test exec context is bats tmp dir
  export test_script_file="${PWD}/test/test_script"

  # ensure mock script file exists
  touch "$test_script_file"

  # disables dynamic source checking (vscode plugin vs running in project root)
  # shellcheck disable=1091
  source "${PWD}/lib/usage-lib.sh"

}

@test "get_num_lines sets doc_header_line_count to 0 if script_name unset" {
  unset script_name

  run get_num_lines
  [[ "${status}" -eq 0 ]]
}

@test "get_num_lines sets doc_header_line_count to the correct value" {
  export script_name="$test_script_file"

  content_pre="#! shebang here"
  content_post="\n\n\n"

  file_contents=(
    "\n#\n#\n#\n"             # 3
    "\n#\n#\n#\n\n\n\n#\n"    # 3
    "\n#\n#\n#\n#\n#\n"       # 5
    "\n\n\n\n#\n#\n#\n#\n#\n" # 0
  )

  # number of '\n#' in corresponding file_contents value
  header_lines=(
    3
    3
    5
    0
  )

  for ((i = 0 ; i < ${#header_lines[@]} ; i++)); do
    content=${file_contents[(($i))]}
    expect_value=${header_lines[(($i))]}
    ((expect_value+=1)) # returned value = (num_lines + 1)

    # set content
    echo -e "$content_pre$content$content_post" > "$test_script_file"

    # run cmd
    run get_num_lines "$test_script_file"

    # debugging failures
    echo -e "$content_pre$content$content_post"
    echo "$output !== $expect_value"

    # test value
    [[ "$output" -eq  "$expect_value" ]]
  done
}

# @test "format_usage_section outputs args formatted as title and content" {

# }

teardown() {
  rm "$test_script_file"
}
