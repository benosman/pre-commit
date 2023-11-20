#!/usr/bin/env bash

set -euo pipefail

# OSX GUI apps do not pick up environment variables the same way as Terminal apps and there are no easy solutions,
# especially as Apple changes the GUI app behavior every release (see https://stackoverflow.com/q/135688/483528). As a
# workaround to allow GitHub Desktop to work, add this (hopefully harmless) setting here.
export PATH=$PATH:/usr/local/bin

# Store and return all failures from fmt so this can validate every directory passed before exiting
FMT_ERROR=0

for file in "$@"; do
  pushd "$(dirname "$file")" >/dev/null
  terraform fmt -diff -check -write "$(basename "$file")" || FMT_ERROR=$((FMT_ERROR + $?))
  popd >/dev/null
done

if [[ $FMT_ERROR -gt 0 ]]; then
  exit 1
else
  exit 0
fi
