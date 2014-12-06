#!/bin/bash

set -e
set -x

if [ -d "spec" ] ; then
  rspec  --format documentation --color
fi

# foodcritic tags go in ../.foodcritic
foodcritic -f correctness,services,libraries,deprecated .

rubocop -Da .
