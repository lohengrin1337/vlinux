#!/usr/bin/env bash

##
## Print- and parsing functions for mazerunner cli
##



#
# print each argument with frame, color and spacing
#
function pretty_print
{
    local color="$GREEN"
    [[ $1 = "-red" ]] && color="$RED" && shift

    local top="$color====================================================================================$NO_COLOR\n"
    local bottom="$color====================================================================================$NO_COLOR"

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
        "<<< LOG CLIENT >>>"
        "Usage: $0 [options] <command> [arguments]"
        "Tip: You can use multiple filters with view ( e.g. 'view ip <ip> url <url> time <time>')"
        ""
        "Commands:"
        "   use <server>            Set hostname of server to use ('log-server', 'localhost' etc)"
        "   url                     Show url for browser access"
        "   view                    List all entries"
        "   view ip <ip>            Filter entries on ip (substring, case-insensitive)"
        "   view url <url>          Filter entries on url (substring, case-insensitive)"
        "   view month <month>      Filter entries on month (case-insensitive)"
        "   view day <day>          Filter entries on day (leading zero)"
        "   view time <time>        Filter entries on time ('hh' or 'hh:mm' or 'hh:mm:ss')"
        ""
        "Options:"
        "   --help, -h              Show help"
        "   --version, -v           Show version"
        "   --count, -c             Show the count of matching entries (e.g. '-c view url <url>')"
    )

    pretty_print "${txt[@]}"
}



#
# print version
#
function version
{
    pretty_print "$SCRIPT version $VERSION"
}



#
# exit on purpose with message
#
function exit_friendly
{
    pretty_print "Good bye!"

    # remove game config
    clean_up

    exit 0
}



#
# remove .game_config, and globals, if already sourced
#
function clean_up
{
    rm -f ".game_config"
    unset GAME_ID
    unset MAPS_AVAILABLE
    unset SELECTED_MAP
    unset ROOM_ID
}



#
# set global array MAPS_AVAILABLE with available maps
#
function get_maps
{
    # request '/map'
    request_maze_server "/map"

    # check response was successfull
    ! response_is_ok && response_error

    # get json-maps from response body with jq, as string ("map1.json map2.json")
    maps="$( echo "$RESPONSE" | tail -n 1 | jq -r 'join(" ")' )"

    # Add MAPS_AVAILABLE to .game_config , and source the file
    echo -e "MAPS_AVAILABLE=\"${maps}\"" >> ".game_config"

    # shellcheck disable=SC1091
    [[ -f ".game_config" ]] && source ".game_config"
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
# save relevant room info to ROOM_INFO_PRINT
#
function prepare_room_info
{
    # check if exit from maze was found
    if exit_is_found; then
        ROOM_INFO_PRINT=(
            "*** CONGRATULATIONS ***"
            "${ROOM_INFO["description"]}"
            "Start a new game with '$SCRIPT init'"
        )
    else
        ROOM_INFO_PRINT=(
            "${ROOM_INFO["description"]}"
            "${ROOM_INFO["valid_directions"]}"
            "${NEXT_STEP["go"]}"
        )
    fi

    export ROOM_INFO_PRINT
}
