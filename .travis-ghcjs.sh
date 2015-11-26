#/usr/bin/env bash
set -ev

tinc install hspec-discover
hspec-discover --version
cd servant-client
./test/ghcjs/run-tests.sh
