#!/bin/sh

# This script is needed to start autofs at login, in case I'm switching users.
# I add this as a login script in KDE.
# Look at autofs-fix-lag-logout.sh for more info.

systemctl start autofs
