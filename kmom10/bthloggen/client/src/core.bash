#!/usr/bin/env bash

##
## Core functions for log client
##



#
# set hostname of server to use
#
function app_use
{
    local host_name="$1"

    echo -e "CUSTOM_HOST=\"$host_name\"" >> "$CONFIG_FILE"

    pretty_print "You are using '$host_name' as server host"
}



#
# show the url to access the log-server from browser
#
function app_url
{
    pretty_print "URL to access log-server from browser:" "$PUBLIC_URL"
}



#
# list entries, with or without filters (ip, url, month, day, time)
#
function app_view
{
    # build a query string (filters) from the arguments
    build_query "$@"

    # request 'log-server/data' with the query
    request_log_server "/data${QUERY_STRING}"

    # convert json response to csv with jq
    entries2csv

    # convert csv to formated table with awk
    csv2table

    # print table
    pretty_print -table $RESPONSE_TEMP
}


#
# init game, and save id to GAME_ID (.game_config)
#
function app_init
{
    # request '/', save RESPONSE
    request_maze_server "/"

    # check init was successfull
    ! response_is_ok && response_error

    # get game id from body
    game_id="$(echo "$RESPONSE" | tail -n 1 | grep -Ewo "[0-9]{5}")"

    # save game id to global GAME_ID in .game_config
    echo "GAME_ID=$game_id" > ".game_config"        # replace any earlier content (fresh game)

    # shellcheck disable=SC1091
    [ -f ".game_config" ] && source ".game_config"

    PRETTY_PRINT=(
        "A new game is created"
        "${NEXT_STEP["maps"]}"
    )
}



#
# show existing maps with numbers
#
function app_maps
{
    # get available maps into MAPS_AVAILABLE, if not set
    [[ -z $MAPS_AVAILABLE ]] && \
        get_maps

    # check that MAPS_AVAILABLE is not an empty string
    [[ -z $MAPS_AVAILABLE ]] && \
        pretty_print -red "No maps were currently available!" && exit 1

    # get each map with a number, and without file extension
    i=1
    for map in $MAPS_AVAILABLE; do
        MAP_SELECTION+=("$i: ${map%.json}")
        (( i++ ))
    done

    export MAP_SELECTION

    # check which next step is
    next="${NEXT_STEP["select"]}"
    if ! game_exists; then
        next="${NEXT_STEP["init"]}"
    fi

    PRETTY_PRINT=(
        "${MAP_SELECTION[@]}"
        "$next"
    )
}



#
# select a map (number)
#
function app_select
{
    # check game is existing
    verify_game_exists

    # check map is not already selected
    verify_map_not_selected

    # get available maps into MAPS_AVAILABLE, if not set
    [[ -z $MAPS_AVAILABLE ]] && get_maps

    # check user input matches an existing map
    num="$1"
    verify_map_exists "$num"

    # get selected map
    map="$( cut -f "$num" -d ' ' <<< "$MAPS_AVAILABLE")"

    # request '/<game_id>/map/<map_name>', save RESPONSE
    # shellcheck disable=SC2153
    request_maze_server "/${GAME_ID}/map/${map}"

    # check select was successfull
    ! response_is_ok && response_error

    # save SELECTED_MAP to .game_config to prevent re-select (which will make server fail)
    echo -e "SELECTED_MAP=\"$map\"" >> ".game_config"

    # shellcheck disable=SC1091
    [ -f ".game_config" ] && source ".game_config"

    # get text content
    text="$(echo "$RESPONSE" | tail -n 1 | jq -r '.text')"

    PRETTY_PRINT=(
        "${text%.}: ${map%.json}"
        "${NEXT_STEP["enter"]}"
    )
}



#
# enter first room, and save ROOM_ID to .game_config
#
function app_enter
{
    # verify game is created, else exit and inform user to init game
    verify_game_exists

    # verify map is selected, else exit and inform user to select map
    verify_map_is_selected

    # request '/<game_id>/maze', save RESPONSE
    request_maze_server "/${GAME_ID}/maze"

    # check enter was successfull
    ! response_is_ok && response_error

    # parse RESPONSE into ROOM_INFO
    parse_room_info

    # save new room id to .game_config ROOM_ID
    echo "ROOM_ID=${ROOM_INFO["id"]}" >> ".game_config"

    # shellcheck disable=SC1091
    [ -f ".game_config" ] && source ".game_config"

    # prepare relevant text in ROOM_INFO_PRINT
    prepare_room_info

    PRETTY_PRINT=(
        "You have entered the first room"
        "${ROOM_INFO_PRINT[@]}"
    )
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

    # request '/<game_id>/maze/<room_id>', save RESPONSE
    request_maze_server "/${GAME_ID}/maze/${ROOM_ID}"

    # check info-response was successfull
    ! response_is_ok && response_error

    # parse RESPONSE into ROOM_INFO
    parse_room_info

    # check if exit from maze was found, and prepare relevant text in ROOM_INFO_PRINT
    prepare_room_info

    PRETTY_PRINT=(
        "${ROOM_INFO_PRINT[@]}"
    )
}



#
# enter new room (if possible), and save ROOM_ID to .game_config
#
function app_go
{
    # exit and inform user to init game, if GAME_ID is undefined
    verify_game_exists

    # exit and inform user to enter the maze, if ROOM_ID is undefined
    verify_room_exists

    # check argument is one of four valid directions
    direction="$1"
    verify_direction "$direction"

    # request '/<game_id>/maze/<room_id>/<direction>', save RESPONSE
    request_maze_server "/${GAME_ID}/maze/${ROOM_ID}/${direction}"

    # check go-response was successfull
    if ! response_is_ok; then
        export PRETTY_PRINT=(
            "There is no door in that direction"
            "${NEXT_STEP["info"]}"
        )
    else
        # parse RESPONSE into ROOM_INFO
        parse_room_info

        # save new room id to .game_config ROOM_ID
        echo "ROOM_ID=${ROOM_INFO["id"]}" >> ".game_config"

        # shellcheck disable=SC1091
        [ -f ".game_config" ] && source ".game_config"

        # check if exit from maze was found, and prepare relevant text in ROOM_INFO_PRINT
        prepare_room_info

        export PRETTY_PRINT=(
            "${ROOM_INFO_PRINT[@]}"
        )
    fi
}
