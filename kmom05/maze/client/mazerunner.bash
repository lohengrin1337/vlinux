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
## VARIABLES
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

# source .game_config if exists (globals GAME_ID, ROOM_ID and MAPS_AVAILABLE)
# shellcheck disable=SC1091
[[ -f ".game_config" ]] && source ".game_config"


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
# verify response is OK (code 200), and call response_error if not
#
function verify_response
{
    local response="$1"
    local msg="$2"

    if ! echo "$response" | head -n 1 | grep "200" &> /dev/null; then
        response_error "$response" "$msg"
    fi
}

#
# handle response error
#
function response_error
{
    local response="$1"
    local msg="$2"
    local status_code
    local content
    local text
    local hint

    # get status code from header, and content from body
    status_code="$(echo "$response" | head -n 1 | grep -Ewo "[0-9]{3}")"
    content="$(echo "$response" | tail -n 1)"
    text="$( echo "$content" | jq .text )"
    hint="$( echo "$content" | jq .hint )"

    [[ -n $msg ]] && echo "$msg"
    echo "Response code: $status_code"
    echo "Message: $text"
    echo "Hint: $hint"
    exit 1
}

#
# set global array MAPS_AVAILABLE with available maps
#
function get_maps
{
    # request '/map' (header and body(csv), silent, include error from curl)
    url="$BASE_URL/map$TO_CSV"
    if ! res="$(curl -isS "$url")"; then
        curl_error "$url" "$res"
    fi

    # get maps from body (get the json-files from csv content in format 'map1.json map2.json')
    if ! maps="$(echo "$res" | tail -n 1 | grep -Eo "[[:alnum:]\-]+.json" | tr '\n' ' ')"; then
        response_error "$res" "Unable to find maps!"
    fi

    # Add maps to .game_config as global array, and source the file
    echo "MAPS_AVAILABLE=($maps)" >> ".game_config"

    # shellcheck disable=SC1091
    [[ -f ".game_config" ]] && source ".game_config"
}

#
# verify game exists, by doing nothing or exiting with message
#
function verify_game_exists
{
    # set optional message ($1), else default message
    local msg
    [[ -n $1 ]] && \
        msg="$1" || \
        msg="STEP ONE: start a new game with './$SCRIPT init'"

    # set optional exit code ($2), else default code (1)
    local exit_code
    [[ -n $2 ]] && \
        exit_code="$2" || \
        exit_code="1"

    # check if GAME_ID is unset (sourced with .game_config)
    # shellcheck disable=SC2153
    if [[ -z $GAME_ID ]]; then
        echo "$msg"
        exit "$exit_code"
    fi
}

#
# check if ROOM_ID is set in .game_config
#
function verify_room_exists
{
    [[ -z $ROOM_ID ]] && \
        echo "NEXT STEP: enter first room with './$SCRIPT enter'" && \
        exit 1
}



##
## APP FUNCTIONS
##

#
# init game, and save id to 'game_id'
#
function app_init
{
    # request '/' (header and body(csv), silent, include error from curl)
    url="$BASE_URL/$TO_CSV"
    if ! res="$(curl -isS "$url")"; then
        curl_error "$url" "$res"
    fi

    # get game id from body
    if ! game_id="$(echo "$res" | tail -n 1 | grep -Ewo "[0-9]{5}")"; then
        response_error "$res" "Unable to create a new game!"
    fi

    # save game id to global GAME_ID in .game_config
    echo "GAME_ID=$game_id" > ".game_config"    # replace any earlier content (fresh game)
    echo "A new game is created with id: $game_id"
    echo "NEXT STEP: show maps with './$SCRIPT maps'"
}


#
# show existing maps with numbers
#
function app_maps
{
    # get available maps into MAPS_AVAILABLE, if not set
    [[ -z $MAPS_AVAILABLE ]] && get_maps

    # check that at least one map is available
    [[ ${#MAPS_AVAILABLE[@]} -lt 1 ]] && \
        echo "No maps were currently available!" && exit 1

    echo "Available maps:"

    # print each map with a number (index +1), and without file extension
    for i in "${!MAPS_AVAILABLE[@]}"; do
        echo "$((i + 1)): ${MAPS_AVAILABLE[$i]%.json}"
    done

    # inform user to init game if not done
    verify_game_exists "" 0

    echo "NEXT STEP: select a map with './$SCRIPT select <number>'"
}

#
# select a map (number)
#
function app_select
{
    # check game is existing
    verify_game_exists

    # get available maps into MAPS_AVAILABLE, if not set, and count maps
    [[ -z $MAPS_AVAILABLE ]] && get_maps
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

    # request '/<game_id>/map/<map_name>' (header and body(csv), silent, include error from curl)
    url="${BASE_URL}/${GAME_ID}/map/${map}${TO_CSV}"
    if ! res="$(curl -isS "$url")"; then
        curl_error "$url" "$res"
    fi

    # get text content
    if ! response_text="$(echo "$res" | tail -n 1 | grep -o "New map selected")"; then
        response_error "$res" "Unable to select map '$map'!"
    fi

    echo "$response_text: ${map%.json}"
    echo "NEXT STEP: enter first room with './$SCRIPT enter'"
}

#
# enter first room, and save room id to 'data/room_id'
#
function app_enter
{
    # exit and inform user to init game if not done
    verify_game_exists

    # request '/<game_id>/maze' (header and body(json), silent, include error from curl)
    url="${BASE_URL}/${GAME_ID}/maze"
    if ! res="$( curl -isS "$url" )"; then
        curl_error "$url" "$res"
    fi

    # check response code is 200
    verify_response "$res" "Unable to enter first room!"

    # get json body
    body="$( echo "$res" | tail -n 1 )"

    # use jq to parse json
    room_id="$( echo "$body" | jq -r .roomid )"
    description="$( echo "$body" | jq -r .description )"

    # get the available directions (eg. has a room number, and not a '-')
    valid_directions=($(echo "$body" | jq -r '.directions | to_entries[] | select(.value != "-") | .key'))

    # save room id to .game_config ROOM_ID
    echo "ROOM_ID=$room_id" >> ".game_config"

    # print info
    echo "You have entered the first room."
    echo "Description: $description"
    echo "You find doors in the following directions: ${valid_directions[*]}"
    echo "NEXT STEP: enter an adjecent room with './$SCRIPT go <direction>'"
}

#
# show room info of current room
#
function app_info
{
    # exit and inform user to init game, if GAME_ID is undefined
    verify_game_exists

    # exit and inform user to enter the maze, if ROOM_ID is undefined
    verify_room_exists

    # /42580/maze/5
    # request '/<game_id>/maze/<room_id>' (header and body (json), silent, include error from curl)
    url="${BASE_URL}/${GAME_ID}/maze/${ROOM_ID}"
    if ! res="$( curl -isS "$url" )"; then
        curl_error "$url" "$res"
    fi

    # check response code is 200
    verify_response "$res" "Unable to get info!"

    body="$( echo "$res" | tail -n 1 )"



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
