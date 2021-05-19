#!/usr/bin/env bash

# -w    write result to file
# -i 2  indent 2 spaces
# -ci   indent switch cases
# -l    list unformatted

shfmt -w -i 2 -ci -l template-v1 lib/message-lib.sh lib/usage-lib.sh && echo '
All files formatted!
'
