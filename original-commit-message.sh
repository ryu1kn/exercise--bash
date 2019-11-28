#!/bin/bash

set -euo pipefail

branch_name=$1

cat << ENDMSG

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# On branch $branch_name
# Your branch is up to date with 'origin/$branch_name'.
#
# Changes to be committed:
#	modified:   README.md
#
ENDMSG