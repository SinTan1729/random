#!/usr/bin/env bash

# This is a simple script to find all video files in a folder and move them into their own folders.
# It also detects .srt subtitle files with matching names and moves them into their corresponding
# video file's folder.

process_file () {
    filename="$(basename "$file")"
    echo "Processing $filename..."
    without_ext="${filename%.*}"

    if [ -d "$without_ext" ]; then
        echo "The directory $without_ext alreaddy exists. Please process the file manually."
    else
        mkdir "$without_ext"
        mv "$filename" "$without_ext/"
        find . -maxdepth 1 -type f -regextype posix-egrep -iregex "\./$without_ext(\.[a-z]{2,3})?\.srt" \
            -exec mv "{}" "$without_ext/" \;
    fi
}

counter=0

find . -maxdepth 1 -type f -regextype posix-egrep -iregex '.*\.(mkv|mp4)$' -print0 | while IFS= read -r -d '' file; do
    process_file
done

