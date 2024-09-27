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
    status_code="$(echo $res | head -n 1 | grep -Ewo "[0-9]{3}")"
    content="$(echo $res | tail -n 1)"
    content="${content//\"{}/}" # remove quotes and curly brackets

    echo "Unable to create new game!"
    echo "Response code: $status_code"
    echo "Content: $content"
    exit 1
}


#
# init game, and save id to 'game_id'
#
function app-init
{
    # request '/' (header and body, silent, include error from curl)
    url="$BASE_URL/$TO_CSV"
    if ! res="$(curl -isS "$url")"; then
        curl_error "$url" "$res"
    fi

    # get game id from body
    if ! game_id="$(echo $res | tail -n 1 | grep -Ewo "[0-9]{5}")"; then
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
function app-maps
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

    echo "Available maps:"

    # print each map with a number
    i=1
    for map in $maps; do
        map="${map%.json}"  # remove file extension
        echo "$i: $map"
        (( i++ ))
    done

    echo "NEXT STEP: select a map with './$SCRIPT select <number>'"
}

#
# select a map (number)
#
function app-select
{
    true
}

#
# enter first room, and save room id to 'data/room_id'
#
function app-enter
{
    true
}

#
# show room info of current room
#
function app-info
{
    true
}

#
# enter new room (if possible), and save room id to 'data/room_id'
#
function app-go
{
    true
}



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
                app-"$command" "$@"     # run app-function with remaining args
                exit 0
            ;;

            ( * )
                badUsage "Option/command not recognized."
                exit 1
            ;;
        esac
    done

    badUsage
}

# run main with args
main "$@"
exit 1
