#!/bin/bash

script_dir="$(dirname "$(readlink -f "$0")")"

ADDITIONAL_TIME="30 minutes"
if [[ -n "$1" ]]; then
  ADDITIONAL_TIME="$1"
fi
echo "Will teardown setup in $ADDITIONAL_TIME"
(
set -x
at "now + $ADDITIONAL_TIME" <<EOF
"$script_dir/apply.sh" destroy
EOF
)

echo "To view: atq"
echo "To cancel use atrm against the created at job"
