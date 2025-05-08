#!/bin/bash

# This is a script for periodically rebooting my device with exponential
# delays up to a limit. Useful mostly for my Pi Zero 2W.

DELAY_FILE="/home/sintan/temp/network_check.counter"
LOG_FILE="/home/sintan/temp/network_check.log"

if ping -qc1 192.168.0.1 >/dev/null; then
    echo "$(date): We up!" >> "$LOG_FILE"
    rm -f "$DELAY_FILE"
else
    echo "$(date): We down!"
    if [ -f "$DELAY_FILE" ]; then
        ITER="$(cat "$DELAY_FILE")"
        echo "$(( ITER + 1 ))" > "$DELAY_FILE"
    else
        ITER=1
        echo 2 > "$DELAY_FILE"
    fi

    if [[ $ITER == 8 ]]; then
        echo 5 > "$DELAY_FILE"
    fi
        

    [[ $ITER == 1 || $ITER == 2 || $ITER == 4 || $ITER == 8 ]] && echo "Rebooting!" >> "$LOG_FILE"
    /sbin/shutdown -r +1
fi
