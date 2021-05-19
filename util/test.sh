#!/usr/bin/env bash

LIME_GREEN="\033[38;5;10m"
RED="\033[38;5;9m"
CRESET="\033[0m"
BOLD="\033[1m"

function lsname() {
  local dir="$1"
  if [[ -z "$dir" ]]; then
    dir="$PWD"
  fi

  # shellcheck disable=2012
  ls -lA "$dir" | awk -F':[0-9]* ' '/:/{print $2}'
}

IFS=$'\n'
# shellcheck disable=2207
tests=($(lsname "$PROJECT_ROOT/test"))
unset IFS

index=1
sum_exit_code=0
echo -e "\n$BOLD Running ${#tests[@]} test suites...\n -----"

for test in "${tests[@]}"; do
  echo -e "\n$BOLD $index. ${test%.bats} $CRESET\n --"
  bats "$PROJECT_ROOT/test/$test" || ((sum_exit_code += $?))
  ((index += 1))
done

if [[ $sum_exit_code -gt 0 ]]; then
  message="$RED$BOLD At least one suite has failed"
else
  message="$LIME_GREEN$BOLD 🎉 All suites have passed"
fi

echo -e "\n$message\n\n"
