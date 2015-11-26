#/usr/bin/env bash
set -ev

ghc --version

for package in $(cat sources.txt); do
  (cd $package && tinc && cabal configure --enable-tests --disable-optimization && cabal build && cabal test) || exit 1
done
