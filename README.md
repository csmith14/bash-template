# bash-template

![bash](https://img.shields.io/badge/bash-v5.1-blue.svg?style=flat-square)

My Bash Script Template.

Based on [leogtzr/minimal-safe-bash-template](https://github.com/leogtzr/minimal-safe-bash-template).
This fork addresses several issues present in the original, and introduces several new features.

All script contents and overall structure follow [Google's shell style guide](https://google.github.io/styleguide/shellguide.html).
All functions are documented according to Google's style guide recommendations.

## Script Libs

### message-lib

Provides the following functions for printing consistently-formatted messages:

| Function  | Description                              | Example output              |
| --------- | ---------------------------------------- | --------------------------- |
| `debug`   | prints debug-level message               | [ DEBUG ] debugging message |
| `info`    | prints info-level message                | [ ℹ ] debugging message     |
| `success` | prints success message                   | [ OK ] hooray!              |
| `die`     | prints formatted error message and exits | [ FAIL ] oh dear            |
| `user`    | prints prompt and reads user input       | ---                         |

### usage-lib

The main script file utilizes an inline doc-comment syntax, which is parsed and formatted by `lib/usage-lib.sh` to
generate the help/usage output:

```bash
$ ./template-v1 -h

template-v1
(v0.0.1-beta)

USAGE:
    template-v1 [-options] ARG1 [ARG2]

DESCRIPTION:
    Brief script description. Displayed in usage message.
    May be multiple lines. Consecutive omment-only lines beginning with '#:'
    will be combined into the description.

OPTIONS:
    -s  Description for the -s option
    -p  Description for -p option
    -h  Display this usage information and exit
    -d  Display debugging information

```

Of course, this can be replaced with a static `heredoc` if desired.
Since `usage-lib` is sourced into the main script file, the change is easy to make.

## Environment

### Bash v5.1

This template assumes use in an environment that has bash version ^5.1. Some builtins used within the
script files need a minimum version of 5.1.

### envrc

If you have `direnv` (or similar tool) installed, the following will be added to your shell environment
while within the project:

```sh
root="$(dirname "$@")"
export PROJECT_ROOT="$root"

# Add util dir to $PATH
export PATH=$PATH:"${PROJECT_ROOT}/util"

# bats config values
export BATS_LIB_DIRNAME="${PWD}/lib"
export BATS_TEST_DIRNAME="${PWD}/test"
```

## Testing/Linting

The following tools are used to test, lint, and format the script files. **None are required** to use the
template, but **all are highly recommended** for the best bash script development experience.

- [bats (bats-core)](https://bats-core.readthedocs.io/en/latest/index.html)
- [shellcheck](https://github.com/koalaman/shellcheck#user-content-installing)
- [shfmt](https://github.com/mvdan/sh)

### Lint & Format

The absolute path to `util/` should have been added to your `$PATHT` via `.envrc`.

To perform linting:

```bash
$ lint.sh

All files linted!
```

To perform formatting:

```bash
$ format.sh

All files linted!
```

### Testing

The `test.sh` script runs all tests and formats each output.

```bash
$ test.sh

 Running 2 test suites...
 -----

 1. message-lib
 --
 ✓ invoking debug with unset 'd_opt_set' results in no output and status 0
 ✓ invoking debug with 'd_opt_set=0' results in no output and status 0
 ✓ invoking debug with 'd_opt_set=1' results in formatted output
 ✓ invoking info results in formatted output
 ✓ invoking success results in formatted output

5 tests, 0 failures


 2. usage-lib
 --
 ✓ get_num_lines sets doc_header_line_count to 0 if script_name unset
 ✓ get_num_lines sets doc_header_line_count to the correct value

2 tests, 0 failures


 🎉 All suites have passed

```
