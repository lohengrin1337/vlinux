#!/usr/bin/env bash
#
# Client for Mazerunner game
#
# Exit values:
#  0 on success
#  1 on failure
#
# Author: Olof Jönsson - oljn22
#



##
## VARIABLES DEFINITIONS
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

# global vars used with 'get-maps' and get_game_id functions
declare -a MAPS_AVAILABLE
GAME_ID=""

# Define color codes
GREEN="\033[0;32m"
RED="\033[0;31m"
NO_COLOR="\033[0m"



##
## UTIL FUNCTIONS
##

#
# Message to display for usage and help.
#
function usage
{
    local txt=(
        "Client $SCRIPT for Mazerunner game"
        "Usage: ./$SCRIPT [options] <command> [arguments]"
        ""
        "Commands:"
        "   init                            init game"
        "   maps                            show maps"
        "   select <num>                    select map"
        "   enter                           enter first room"
        "   info                            show info of current room"
        "   go <north|east|south|west>      enter new room (if possible)"
        ""
        "Options:"
        "   --help, -h       Print help."
        "   --version, -h    Print version."
    )

    printf "%s\\n" "${txt[@]}"
}

#
# message to display when bad usage.
#
function badUsage
{
    local message="$1"
    local txt=(
        "For an overview of the commands, execute:"
        "./$SCRIPT --help | -h"
    )

    [[ -n $message ]] && printf "%s\\n" "$message"

    printf "%s\\n" "${txt[@]}"

    exit 1
}

#
# print version.
#
function version
{
    local txt=(
        "$SCRIPT version $VERSION"
    )

    printf "%s\\n" "${txt[@]}"
}

#
# handle error from curl
#
function curl_error
{
    echo "Curl failed when requesting '$1'"
    [[ -n $2 ]] && echo "$2"
    exit 1
}

#
# handle response error
#
function response_error
{
    # get status code from header, and full content-body
    status_code="$(echo "$res" | head -n 1 | grep -Ewo "[0-9]{3}")"
    content="$(echo "$res" | tail -n 1)"
    content="${content//\"{}/}" # remove quotes and curly brackets

    echo "Unable to create new game!"
    echo "Response code: $status_code"
    echo "Content: $content"
    exit 1
}

#
# update global array MAPS_AVAILABLE with available maps
#
function get_maps
{
    # request '/map' (header and body, silent, include error from curl)
    url="$BASE_URL/map$TO_CSV"
    if ! res="$(curl -isS "$url")"; then
        curl_error "$url" "$res"
    fi

    # get maps from body (get the json-files from csv content)
    if ! maps="$(echo "$res" | tail -n 1 | grep -Eo "[[:alnum:]\-]+.json")"; then
        response_error "$res"
    fi

    # append maps to MAPS_AVAILABLE
    for map in $maps; do
        map="${map%.json}"          # remove file extension
        MAPS_AVAILABLE+=("$map")    # append map
        (( i++ ))
    done
}

#
# update global GAME_ID with id from file 'game_id'. exit with msg if nonexisting.
#
function get_game_id
{
    if ! id="$(cat "game_id")"; then
        echo "STEP ONE: start a new game with './$SCRIPT init'"
        exit 1
    fi

    GAME_ID="$id"
}



##
## APP FUNCTIONS
##

#
# init game, and save id to 'game_id'
#
function app_init
{
    # request '/' (header and body, silent, include error from curl)
    url="$BASE_URL/$TO_CSV"
    if ! res="$(curl -isS "$url")"; then
        curl_error "$url" "$res"
    fi

    # get game id from body
    if ! game_id="$(echo "$res" | tail -n 1 | grep -Ewo "[0-9]{5}")"; then
        response_error "$res"
    fi

    # save game id to file
    echo "$game_id" > "./game_id"
    echo "A new game is created with id: $game_id"
    echo "NEXT STEP: show maps with './$SCRIPT maps'"
}


#
# show existing maps with numbers
#
function app_maps
{
    # get available maps into MAPS_AVAILABLE
    get_maps

    # check that at least one map is available
    [[ ${#MAPS_AVAILABLE[@]} -lt 1 ]] && \
        echo "No maps were currently available!" && exit 1

    echo "Available maps:"

    # print each map with a number (index +1)
    for i in "${!MAPS_AVAILABLE[@]}"; do
        echo "$((i + 1)): ${MAPS_AVAILABLE[$i]}"
    done

    echo "NEXT STEP: select a map with './$SCRIPT select <number>'"
}

#
# select a map (number)
#
function app_select
{
    # get available maps into MAPS_AVAILABLE, and count maps
    get_maps
    map_count=${#MAPS_AVAILABLE[@]}

    # check at least one map is available
    [[ $map_count -lt 1 ]] && \
        echo "No maps were currently available!" && exit 1

    # check for empty or invalid number argument
    num="$1"
    [[ ! $num =~ ^[0-9]+$ || $num -lt 1 || $num -gt $map_count ]] && \
        badUsage "Argument for 'select' has to be an integer in the range 1-$map_count!"

    # select map (convert number to index)
    map="${MAPS_AVAILABLE[$((num - 1))]}"

    echo -e "selected map:\n$map"

    # get game id from file to global GAME_ID
}

#
# enter first room, and save room id to 'data/room_id'
#
function app_enter
{
    true
}

#
# show room info of current room
#
function app_info
{
    true
}

#
# enter new room (if possible), and save room id to 'data/room_id'
#
function app_go
{
    true
}



##
## MAIN LOOP
##

#
# Main function to process options
#
function main
{
    while (( $# )); do
        case "$1" in
            ( --help | -h )
                usage
                exit 0
            ;;

            ( --version | -v )
                version
                exit 0
            ;;

            ( init | maps | select | enter | info | go )
                command=$1
                shift
                app_"$command" "$@"     # run app_function with remaining args
                exit 0
            ;;

            ( * )
                badUsage "Option/command not recognized."
            ;;
        esac
    done

    badUsage
}



##
## ENTRYPOINT
##

# run main with args
main "$@"
