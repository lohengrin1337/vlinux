#!/usr/bin/env bash

##
## Util functions for mazerunner cli
##

#
# print each argument with frame, color and spacing
#
function pretty_print
{
    local color="$GREEN"
    [[ $1 = "-red" ]] && color="$RED" && shift

    local top="$color=====================================================================$NO_COLOR\n"
    local bottom="$color=====================================================================$NO_COLOR"

    echo -e "$top"
    printf "    %s\n\n" "$@"
    echo -e "$bottom"
}

#
# Message to display for usage and help.
#
function usage
{
    local txt=(
        "<<< CLIENT '$SCRIPT' FOR MAZERUNNER GAME >>>"
        "Usage: $SCRIPT [options] <command> [arguments]"
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
        "   --help, -h                      Print help."
        "   --version, -h                   Print version."
    )

    pretty_print "${txt[@]}"
}

#
# message to display when bad usage.
#
function badUsage
{
    local message="Option/command '$1' was not recognized"
    local txt=(
        "For an overview of the commands, execute:"
        "$SCRIPT --help"
    )

    pretty_print -red "$message" "${txt[@]}"
    exit 1
}

#
# print version
#
function version
{
    pretty_print "$SCRIPT version $VERSION"
}

#
# request to maze-server at specified route
# curl options: include header, silent mode, include error from curl
#
function request_maze_server
{
    route="$1"
    url="${BASE_URL}${route}"

    # request server, save response, and handle possible error from curl
    if ! RESPONSE="$(curl -isS "$url")"; then
        curl_error "$url"
    fi
}

#
# handle error from curl
#
function curl_error
{
    local txt=(
        "Curl failed when requesting '$1'"
        "Message from curl: $RESPONSE"
    )

    pretty_print -red "${txt[@]}"
    exit 1
}

#
# check if response is OK (code 200 = 0 = true)
#
function response_is_ok
{
    # use grep to match '200' in top line of header
    echo "$RESPONSE" | head -n 1 | grep -E "\b200\b" &> "/dev/null"
}

#
# handle response error
#
function response_error
{
    # parse response (header and body)
    response_code="$(echo "$RESPONSE" | head -n 1 | grep -Ewo "[0-9]{3}")"
    body="$(echo "$RESPONSE" | tail -n 1)"
    text="$( echo "$body" | jq -r .text )"
    hint="$( echo "$body" | jq -r .hint )"
    msg="${1:-"Response error ($response_code)"}"

    pretty_print -red "$msg" "$txt" "$hint"
    exit 1
}



#
# set global array MAPS_AVAILABLE with available maps
#
function get_maps
{
#     # request '/map' (header and body(csv), silent, include error from curl)
#     url="$BASE_URL/map$TO_CSV"
#     if ! res="$(curl -isS "$url")"; then
#         curl_error "$url" "$res"
#     fi

    # request '/map'
    request_maze_server "/map"

    # check response is OK
    if ! response_is_ok; then
        response_error
    fi

    # # get maps from body (get the json-files from csv content in format 'map1.json map2.json')
    # if ! maps="$(echo "$res" | tail -n 1 | grep -Eo "[[:alnum:]\-]+.json" | tr '\n' ' ')"; then
    #     response_error "$res" "Unable to find maps!"
    # fi

    # get json-maps from response body with jq, as string ("map1.json map2.json")
    maps="$( echo "$RESPONSE" | tail -n 1 | jq -r 'join(" ")' )"

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

#
# verify direction is valid, else exit with message
#
function verify_direction
{
    all_directions=" north east south west "
    direction="$1"
    msg="$2"

    if ! [[ $all_directions =~ [[:space:]]$direction[[:space:]] ]]; then
        [[ -n $msg ]] && \
            echo "$msg" || \
            echo "Invalid direction '$direction'!"
        exit 1
    fi
}