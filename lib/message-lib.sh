#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

####################################################################################################
# Prints debug-level message
#
# Globals:
#   d_opt_set
# Outputs:
#   writes formatted message to stdout if $d_opt_set is greater than 0
####################################################################################################
debug() {
  [[ "${d_opt_set-0}" -gt 0 ]] && printf "\r  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

####################################################################################################
# Prints info-level message
#
# Outputs:
#   writes formatted message to stdout
####################################################################################################
info() {
  printf "\r  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

####################################################################################################
# Prints prompt and reads user input.
# Handles formatting of prompt string.
#
# Arguments:
#   prompt string
#   name of variable to assign response
####################################################################################################
user() {
  read -p "$(printf "\r  [ \033[0;33m??\033[0m ] %s\n" "$1")"
  export "$2=$REPLY"
}

####################################################################################################
# Prints success message.
# NOTE: Clears current line.
#
# Outputs:
#   writes formatted message to stdout
####################################################################################################
success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

####################################################################################################
# Prints formatted error message and exits.
# NOTE: Clears current line.
#
# Arguments:
#   error message
#   exit code (90)
# Outputs:
#   writes formatted message to stdout
####################################################################################################
die() {
  local -r msg="${1}"
  local -r code="${2:-90}"

  printf "\r\033[2K [\033[0;31mFAIL\033[0m] %s\n" "$msg" >&2
  exit "${code}"
}
