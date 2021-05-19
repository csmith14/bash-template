#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

declare doc_header_line_count

trim_string() {
  : "${1#"${1%%[![:space:]]*}"}"
  : "${_%"${_##*[![:space:]]}"}"
  printf '%s\n' "$_"
}

################################################################################
# Get/evalueate the value of $doc_lines to number of consecutive comment-only
# ines in $script_name. If $script_name is empty or unset, or grep cannot find
# first non-comment line, then value is 0.
# If $doc_lines is already set, outputs the value.
#
# Globals:
#   script_name
# Outputs:
#   Number of header doc comment lines in $script_name, 0 if $script_name unset or empty
################################################################################
get_num_lines() {
  # $script_name unset or empty,
  [[ -z "${script_name-}" ]] && doc_header_line_count=0

  # if value not already set, evaluate it
  if [[ -z "${doc_header_line_count-}" ]]; then
    doc_header_line_count="$({
      grep -E -n -m 1 -v '^#' "$script_name" | grep -E '^\d+' | sed 's/://g'
    } || echo 2)"

    # correct for index offset
    ((doc_header_line_count -= 1))

    readonly doc_header_line_count
  fi

  echo "$doc_header_line_count"
}

################################################################################
# Formats and outputs a section of script usage message. All arguments are
# stripped of extra white space. Line breaks within CONTENT are preserved.
#  * TITLE is formatted bold, colon appended.
#  * CONTENT each line indented 4 spaces.
#
# If any argument is empty or unset, outputs empty string.
#
# Arguments:
#   TITLE
#   CONTENT
# Outputs:
#   if TITLE, CONTENT non-empty, outputs formatted text
#   otherwise, empty string
################################################################################
format_usage_section() {
  if [[ "${1-}" && "${2-}" ]]; then
    title="${1^^}" # all-caps title
    content="$(echo "$2" | sed 's/ +/ /g' | sed 's/ *$//g' | sed -E 's/^ */    /g')"
    printf "\n\033[1m%s:\033[0m\n%s\n\r\n" "$title" "$content"
  else
    echo ''
  fi
}

################################################################################
# Finds script-header comment line starting with '#@', retrieves semver-formatted version
# string (if any).
#
# Outputs:
#   semver string, or empty string if match not found
################################################################################
get_script_version() {
  num_lines="$(get_num_lines)"
  [[ num_lines -eq 0 ]] && echo "" && return 0 # handle no header comment

  # search for first line with script-version indicator '#@' followed by common semver pattern
  version_num="$(head -n "$num_lines" "$script_name" | {
    grep -E '^#@ *v?\d{1,3}\.\d{1,3}\.\d{1,3}(-\w)?' || echo ''
  } | sed -E 's/^#@ *v?/v/')"

  echo "$version_num"
}

################################################################################
# Finds script-header comment line starting with '#?', retrieves command's call
# signature (if any).
#
# Outputs:
#   call signature string, or empty string if match not found
################################################################################
get_call_signature() {
  num_lines="$(get_num_lines)"
  [[ num_lines -eq 0 ]] && echo "" && return 0 # handle no header comment

  # search for first line with call-signature indicator '#?'
  call_signature="$(head -n "$num_lines" "$script_name" | { grep -m 1 '^#?' || echo ''; })"

  [[ -n "$call_signature" ]] && call_signature=$(echo " ${call_signature//#\? /}" | sed -E 's/ +/ /g')
  echo "$call_signature"
}

################################################################################
# Finds script-header comment line(s) starting with '#:', retrieves text content
# from all (if any).
#
# Outputs:
#   description string (possibly multiple lines), empty string if none found
################################################################################
get_description() {
  num_lines="$(get_num_lines)"
  [[ num_lines -eq 0 ]] && echo "" && return 0 # handle no header comment

  # search in header-comment for line(s) with description indicator '#:'
  description="$(head -n "$num_lines" "$script_name" | {
    grep -E '^#:' || echo ''
  })"

  [[ -n "$description" ]] && description="${description//#: /}"
  echo "$description"
}

################################################################################
# Finds any/all lines in $script_name matching pattern of single-char switch
# case immediately followed by doc-comment '#:'. Associates doc-comment text to
# the switch-case char and outputs the combined text of all matching lines.
#
# Globals:
#   script_name
# Outputs:
#   all option doc text lines, each in format '-{char} {comment text}'
#   if no option doc comments found, outputs empty string
################################################################################
get_option_details() {
  [[ -z "${script_name-}" ]] && echo '' && return 0 # handle unset|empty $script_name

  usage_opts="$(grep -i -E '^ *[A-z0-9]\) *#:' "$script_name" || echo '')"

  # clean up non-doc text, extract flag char for line
  usage_opts="$(
    echo "$usage_opts" | sed -E 's/ *#: */  /' | sed -E -r 's/([a-z])\)/-\1/'
  )"

  echo "$usage_opts"
}

################################################################################
# Calls functions to assemble each component of the usage text body, concatenates
# them, and outputs combined result.
#
# Globals:
#   script_name
# Outputs:
#   full description text of all present sections
################################################################################
output_usage() {
  [[ -z "${script_name-}" ]] && echo '' && return 0 # handle empty|unset $script_name

  version_str="$(get_script_version)"
  if [[ -n "${version_str-}" ]]; then
    usage_header="$(printf '\n\n\033[1m%s\033[0m\n%s\n\r\n' "$script_name" "(${version_str})")"
  else
    usage_header="\n$script_name\n\n"
  fi

  call_sig="$(get_call_signature)"
  if [[ -n "${call_sig:-}" ]]; then
    call_sig="$(printf '%s%s' "$script_name" "$call_sig")"
  fi

  cmd_sig_section="$(format_usage_section 'usage' "$call_sig")"
  desc_section="$(format_usage_section 'description' "$(get_description)")"
  opts_section="$(format_usage_section 'options' "$(get_option_details)")"

  echo -e "${usage_header}${cmd_sig_section}${desc_section}${opts_section}"
}
