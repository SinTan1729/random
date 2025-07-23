#!/bin/sh
# Automatically choose the pinentry program depending on the environment
# Just add the following in .gnupg/gpg-agent.conf
# pinentry-program /path/to/executable/script

set -eu
PINENTRY_TERMINAL='/usr/bin/pinentry-tty'
PINENTRY_KDE='/usr/bin/pinentry-qt'
if [ -n "${DISPLAY-}" ]; then
    exec "$PINENTRY_KDE" "$@"
else
    exec "$PINENTRY_TERMINAL" "$@"
fi
