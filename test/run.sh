#!/bin/bash

set -e
set -x 

if [ -d "spec" ] ; then
  rspec  --format documentation --color 
fi

foodcritic -f correctness,services,libraries,deprecated -t ~FC001 -t ~FC034 -t ~FC007 -t ~FC017 .
rubocop -Da .

kitchen test -c 4
