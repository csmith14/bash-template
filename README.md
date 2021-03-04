# bash-template

![bash](https://img.shields.io/badge/bash-v5.1-blue.svg?style=flat-square)

My Bash Script Template.

Based on [leogtzr/minimal-safe-bash-template](https://github.com/leogtzr/minimal-safe-bash-template).
This fork addresses several issues present in the original, and introduces several new features.

All script files have been linted with `shellcheck`. All script contents and overall structure follow
[Google's shell style guide](https://google.github.io/styleguide/shellguide.html).
All functions are documented according to Google's style guide recommendations.

The main script file integrates an inline doc-comment syntax which is used by `lib/usage-lib.sh.` to
generate the usage output when `-h` flag is passed. Of course, this can be replaced with a static `heredoc`
if desired. Since `usage-lib` is sourced into the main script file, the change is easy to make.

## Environment

### Bash v5.1

This template assumes use in an environment that has bash version ^5.1. Some builtins used within the
script files need a minimum version of 5.1.

### Testing/Linting

The following tools are used to test, lint, and format the script files. **None are required** to use the
template, but **all are highly recommended** for the best bash script development experience.

- [bats (bats-core)](https://bats-core.readthedocs.io/en/latest/index.html)
- [shellcheck](https://github.com/koalaman/shellcheck#user-content-installing)
- [shfmt](https://github.com/mvdan/sh)

## Usage examples

```bash
# specs
$ bats test/message-lib.bats
 ✓ invoking debug with unset 'd_opt_set' results in no output and status 0
 ✓ invoking debug with 'd_opt_set=0' results in no output and status 0
 ✓ invoking debug with 'd_opt_set=1' results in formatted output
 ✓ invoking info results in formatted output
 ✓ invoking success results in formatted output

5 tests, 0 failures

```
