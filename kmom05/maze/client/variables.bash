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

# response from maze-server set by 'request_maze_server'
RESPONSE=""

# 'id', 'description' and 'valid_directions' - parsed by 'parse_room_info'
declare -A ROOM_INFO

# array with text strings to print
declare -a TEXT_TO_PRINT

# list of next steps for the user
declare -A NEXT_STEP
NEXT_STEP=(
    ["init"]="STEP ONE: start a new game with '$SCRIPT init'"
    ["maps"]="NEXT STEP: show maps with '$SCRIPT maps'"
    ["select"]="NEXT STEP: select a map with '$SCRIPT select <number>'"
    ["enter"]="NEXT STEP: enter first room with '$SCRIPT enter'"
    ["info"]="Print room info with '$SCRIPT info'"
    ["go"]="NEXT STEP: enter an adjecent room with '$SCRIPT go <direction>'"
)
