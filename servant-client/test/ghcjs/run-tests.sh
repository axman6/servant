#/usr/bin/env bash

# this script has to be executed from the 'servant-client' directory

set -o errexit

export STACK_YAML=stack-ghcjs.yaml
stack setup
stack test
