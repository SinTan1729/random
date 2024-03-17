#!/bin/sh

# This simply switched the given file(s) with a $filename.bak file if it exists
# and creates a backup if it doesn't exist

if [ $# -ge 1 ]; then
    for f in $@
    do
        [ -f "$f.bak" ] && mv "$f.bak" "$f.tmp"
        [ -f "$f" ] && cp -l "$f"{,.bak}
        [ -f "$f.tmp" ] && mv "$f.tmp" "$f"
    done
else
    echo "No filenames passed."
    exit 1
fi
