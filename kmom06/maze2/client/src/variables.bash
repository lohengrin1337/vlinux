#!/usr/bin/env bash

##
## Global variables for mazerunner cli
##

# Name of the script
name=$( basename "$0" )
export SCRIPT="$name"

# Current version
export VERSION="1.0.0"

# host and port of maze-server
export HOST="maze-server"
export PORT="1337"
export BASE_URL="$HOST:$PORT"

# Define color codes
export GREEN="\033[0;32m"
export RED="\033[0;31m"
export NO_COLOR="\033[0m"

# response from maze-server set by 'request_maze_server'
export RESPONSE

# map selection with numbers to choose from
declare -a MAP_SELECTION
export MAP_SELECTION

# 'id', 'description' and 'valid_directions' - parsed by 'parse_room_info'
declare -A ROOM_INFO
export ROOM_INFO

# array with prepared room info to print
declare -a ROOM_INFO_PRINT
export ROOM_INFO_PRINT

# array with text strings to print with pretty_print
declare -a PRETTY_PRINT
export PRETTY_PRINT

# list of next steps for the user
declare -A NEXT_STEP
export NEXT_STEP=(
    ["init"]="STEP ONE: start a new game with '$SCRIPT init'"
    ["maps"]="NEXT STEP: show maps with '$SCRIPT maps'"
    ["select"]="NEXT STEP: select a map with '$SCRIPT select <number>'"
    ["enter"]="NEXT STEP: enter first room with '$SCRIPT enter'"
    ["info"]="Print room info with '$SCRIPT info'"
    ["go"]="NEXT STEP: enter an adjecent room with '$SCRIPT go <direction>'"
)

# list of messages
declare -A MESSAGES
export MESSAGES=(
    ["welcome"]="<<< MAZERUNNER GAME LOOP >>>"
    ["init"]="A new game is created"
    ["maps"]="Maps available:"
    ["select"]="Select a map (enter a number):"
    ["invalid_map"]="Invalid map selection (use '1', '2' etc, or 'help')"
    ["invalid_direction"]="Invalid direction (use 'north', 'east', 'south', 'west', or 'help')"
    ["invalid_door"]="There is no door in that direction (use 'info' to see available directions)"
)
