#!/usr/bin/env bash

shellcheck \
  --external-sources \
  --check-sourced \
  template-v1 lib/message-lib.sh lib/usage-lib.sh && echo '
All files linted!
'
