#!/bin/bash

# This script is inspired by https://github.com/Casvt/Plex-scripts/blob/main/sonarr/unmonitor_downloaded_episodes.py
# I only wanted to rewrite it in bash so that there are no dependencies since the linuxserver sonarr image
# does not come with python installed on it.

# The use case of this script is the following:
# 	When an episode is downloaded and imported in sonarr, unmonitor that episode.
# Setup:
# 	First, fill the three variables below.
# 	Then go to the sonarr web-ui -> Settings -> Connect -> + -> Custom Script:
# 		Name = whatever you want
# 		Triggers = 'On Download' and 'On Upgrade'
# 		Tags = whatever if needed
# 		path = /path/to/sonarr_unmonitor_downloaded_episodes.sh

# Fill these variables
sonarr_ip=''
sonarr_port=''
sonarr_api_token=''

# Handle testing of the script by Sonarr
if [ $sonarr_eventtype == 'Test' ]; then
    if [[ -z $sonarr_ip || -z $sonarr_port || -z $sonarr_api_token ]]; then
        echo "Error: Not all variables are set."
        exit 1
    else
        exit 0
    fi
fi

# Unmonitor the episode
curl -s -H "X-Api-Key: $sonarr_api_token" \
    -X PUT "http://$sonarr_ip:$sonarr_port/api/v3/episode/monitor" \
    -H 'Content-Type: application/json' \
    -d '{"episodeIds": ['$sonarr_episodefile_episodeids'], "monitored": false}'
