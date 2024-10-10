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
# print version
#
function version
{
    pretty_print "$SCRIPT version $VERSION"
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
