#!/bin/sh
set -e
# these are no longer used, and we want to purge
files=(Rakefile Guardfile Gemfile Gemfile.lock .tailor .cane .kitchen.lxc.yml)

for file in "${files[@]}" ; do
	if [ -f "$file" ] ; then 
		echo "Removing: $file"
		git rm -f  "$file"
	fi
done
