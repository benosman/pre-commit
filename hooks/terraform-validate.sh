#!/usr/bin/env bash

set -euo pipefail

# OSX GUI apps do not pick up environment variables the same way as Terminal apps and there are no easy solutions,
# especially as Apple changes the GUI app behavior every release (see https://stackoverflow.com/q/135688/483528). As a
# workaround to allow GitHub Desktop to work, add this (hopefully harmless) setting here.
export PATH=$PATH:/usr/local/bin

# Disable output not usually helpful when running in automation (such as guidance to run plan after init)
export TF_IN_AUTOMATION=1

# Store and return all failures from validate so this can validate every directory passed before exiting
VALIDATE_ERROR=0

for dir in $(echo "$@" | xargs -n1 dirname | sort -u); do
  echo "--> Running 'terraform validate' in directory '$dir'"
  pushd "$dir" >/dev/null
  terraform init -backend=false || VALIDATE_ERROR=$((VALIDATE_ERROR + $?))
  terraform validate || VALIDATE_ERROR=$((VALIDATE_ERROR + $?))
  popd >/dev/null
done

if [[ $VALIDATE_ERROR -gt 0 ]]; then
  exit 1
else
  exit 0
fi
