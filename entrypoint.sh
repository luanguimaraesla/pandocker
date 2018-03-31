#! /bin/bash

cmd="$@"

# Add cabal binaries
PATH=$PATH:/root/.cabal/bin

exec $cmd
