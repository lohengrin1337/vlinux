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
        "   --version, -v                   Print version."
    )

    pretty_print "${txt[@]}"
}



#
# message to display when bad usage.
#
function badUsage
{
    local message="${2:-"Option/command/argument '$1' was not recognized"}"
    local txt=(
        "$message"
        "For an overview of the commands, execute:"
        "$SCRIPT --help"
    )

    pretty_print -red "${txt[@]}"
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

    export RESPONSE

    # check response is OK
    if ! response_is_ok; then
        response_error
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
    # parse text content from json response body
    text="$( echo "$RESPONSE" | tail -n 1 | jq -r '.text')"

    # body="$( echo "$RESPONSE" | tail -n 1 | jq -r .)"
    # echo -e "$body"

    local txt
    case "$text" in
        ( "Path dont exist" )
            txt+=(
                "There is no door in that direction"
                "${NEXT_STEP["info"]}"
            )
        ;;

        ( * )
            txt+=("Something went wrong with the game logic, due to the last command")
        ;;
    esac

    txt+=("Print help with '$SCRIPT --help'")

    pretty_print -red "${txt[@]}"
    exit 1
}



#
# set global array MAPS_AVAILABLE with available maps
#
function get_maps
{
    # request '/map'
    request_maze_server "/map"

    # get json-maps from response body with jq, as string ("map1.json map2.json")
    maps="$( echo "$RESPONSE" | tail -n 1 | jq -r 'join(" ")' )"

    # Add MAPS_AVAILABLE to .game_config , and source the file
    echo -e "MAPS_AVAILABLE=\"${maps}\"" >> ".game_config"

    # shellcheck disable=SC1091
    [[ -f ".game_config" ]] && source ".game_config"
}



#
# check if GAME_ID is set
#
function game_exists
{
    [[ -n $GAME_ID ]]
}



#
# check if GAME_ID is set (.game_config)
# do nothing or exit with message
#
function verify_game_exists
{
    # shellcheck disable=SC2153
    if ! game_exists; then
        msg=${1:-"${NEXT_STEP["init"]}"}
        exit_code=${2:-"1"}

        pretty_print -red "$msg"
        exit "$exit_code"
    fi
}



#
# check map is selected
#
function map_is_selected
{
    [[ -n $SELECTED_MAP ]]
}



#
# verify map is selected, else exit with message
#
function verify_map_is_selected
{
    if ! map_is_selected; then
        pretty_print -red "${NEXT_STEP["maps"]}"
        exit 1
    fi
}



#
# check SELECTED_MAP is not set, else exit with message
#
function verify_map_not_selected
{
    if map_is_selected; then
        txt=("A map is already selected (${SELECTED_MAP%.json})")

        if room_exists; then
            txt+=(
                "${NEXT_STEP["go"]}"
                "${NEXT_STEP["info"]}"
            )
        else
            txt+=("${NEXT_STEP["enter"]}")
        fi

        txt+=("If you want to change map, you need to create a new game")

        pretty_print -red "${txt[@]}"
        exit 1
    fi
}



#
# check if ROOM_ID is set
#
function room_exists
{
    # shellcheck disable=SC2153
    [[ -n $ROOM_ID ]]
}



#
# check if ROOM_ID is set (.game_config)
# do nothing or exit with message
#
function verify_room_exists
{
    # shellcheck disable=SC2153
    if ! room_exists; then
        pretty_print -red "${NEXT_STEP["enter"]}"
        exit 1
    fi
}



#
# parse room info from RESPONSE (enter/info/go), and save to ROOM_INFO
#
function parse_room_info
{
    # get json body from RESPONSE
    body="$( echo "$RESPONSE" | tail -n 1 )"

    # use jq to parse values roomid and description
    room_id="$( echo "$body" | jq -r .roomid )"
    description="$( echo "$body" | jq -r .description )"

    # get the available directions (eg. has a room number, and not a '-')
    valid_directions="$(echo "$body" | jq -r '.directions | to_entries[] | select(.value != "-") | .key' | tr '\n' ' ' | xargs )"

    # save the parsed data to ROOM_INFO
    ROOM_INFO["id"]="$room_id"
    ROOM_INFO["description"]="$description"
    ROOM_INFO["valid_directions"]="You find doors in the following directions: $valid_directions"
    export ROOM_INFO
}



#
# verify direction is valid, else exit with message
#
function verify_direction
{
    all_directions=" north east south west "
    direction="$1"

    # use the direction (user input) in regex, to match a valid direction
    if ! [[ $all_directions =~ [[:space:]]${direction}[[:space:]] ]]; then
        msg="${2:-"Invalid direction '$direction'"}"
        pretty_print -red "$msg"
        exit 1
    fi
}



#
# Check if the exit of the maze is found
#
function exit_is_found
{
    [[ ${ROOM_INFO["description"]} = "You found the exit" ]]
}



#
# save relevant room info to TEXT_TO_PRINT
#
function prepare_room_info
{
    # check if exit from maze was found
    if exit_is_found; then
        TEXT_TO_PRINT=(
            "Congratulations!!!"
            "${ROOM_INFO["description"]}"
            "Start a new game with '$SCRIPT init'"
        )
    else
        TEXT_TO_PRINT=(
            "${ROOM_INFO["description"]}"
            "${ROOM_INFO["valid_directions"]}"
            "${NEXT_STEP["go"]}"
        )
    fi

    export TEXT_TO_PRINT
}
