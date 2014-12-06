#!/bin/bash
set -x

git remote add skeleton git@github.com:milt-cookbooks/skeleton.git
set -e
git fetch skeleton
git merge -X theirs -m 'skeleton cookbook sync' --squash skeleton/master
