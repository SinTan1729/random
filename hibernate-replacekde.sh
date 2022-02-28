#!/bin/sh

# This script replaces the Plasma sessions after waking up from hibernation.
# It's a temporary fix for the app menu breaking after waking up from hibernation.
# Have to place this script inside `/lib/systemd/system-sleep` and make it executable for it to work.

case $1/$2 in
  post/hibernate)
    kwin_x11 --replace
    ;;
esac
