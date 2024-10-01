#!/usr/bin/env bash

##
## Global variables for mazerunner cli
##

# Name of the script
SCRIPT=$( basename "$0" )

# Current version
VERSION="1.0.0"

# host and port of maze-server
HOST="maze-server"
PORT="1337"
BASE_URL="$HOST:$PORT"
TO_CSV="?type=csv"

# Define color codes
GREEN="\033[0;32m"
RED="\033[0;31m"
NO_COLOR="\033[0m"

# response set by 'request_maze_server'
RESPONSE=""
