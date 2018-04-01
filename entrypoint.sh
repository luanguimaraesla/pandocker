#! /bin/bash

# Set pandocker cmd
export PANDOCKER_CMD="$@"

# Add cabal binaries
PATH=$PATH:/root/.cabal/bin

mix run -e Pandocker.run
