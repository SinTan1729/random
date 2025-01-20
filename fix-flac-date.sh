#!/usr/bin/env bash

# This script changes the DATE of a flac to be the
# one passed as the first argument.
# The name of the file should be passed as the second argument.

DATE=$1
FILE="$2"

[ -z "$DATE" ] && echo "Please provide a date" && exit -1
! [ -f "$FILE" ] && echo "Please provide a valid file" && exit -2

metaflac --remove-tag=YEAR "$FILE"
metaflac --remove-tag=DATE "$FILE"
metaflac --set-tag="DATE=$DATE" "$FILE"

echo "Done!"

