#!/usr/bin/env bash

##
## Core functions for mazerunner cli
##



#
# init game, and save id to GAME_ID (.game_config)
#
function app_init
{
    # request '/', save RESPONSE
    request_maze_server "/"

    # get game id from body
    game_id="$(echo "$RESPONSE" | tail -n 1 | grep -Ewo "[0-9]{5}")"

    # save game id to global GAME_ID in .game_config
    echo "GAME_ID=$game_id" > ".game_config"        # replace any earlier content (fresh game)

    txt=(
        "A new game is created"
        "${NEXT_STEP["maps"]}"
    )

    pretty_print "${txt[@]}"
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
    declare -a map_selection
    i=1
    for map in $MAPS_AVAILABLE; do
        map_selection+=("$i: ${map%.json}")
        (( i++ ))
    done

    # check which next step is
    next="${NEXT_STEP["select"]}"
    if ! game_exists; then
        next="${NEXT_STEP["init"]}"
    fi

    pretty_print "${map_selection[@]}" "$next"
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

    # count maps
    map_count="$( echo "$MAPS_AVAILABLE" | wc -w )"

    # check that at least one map is available
    [[ $map_count -lt 1 ]] && \
        pretty_print -red "No maps were currently available!" && exit 1

    # check for empty or invalid number argument
    num="$1"
    [[ ! $num =~ ^[0-9]+$ || $num -lt 1 || $num -gt $map_count ]] && \
        badUsage "$num" "Argument for 'select' has to be an integer in the range 1-$map_count!"

    # get selected map
    map="$( echo "$MAPS_AVAILABLE" | cut -f "$num" -d ' ')"

    # request '/<game_id>/map/<map_name>', save RESPONSE
    # shellcheck disable=SC2153
    request_maze_server "/${GAME_ID}/map/${map}"

    # save SELECTED_MAP to .game_config to prevent re-select (which will make server fail)
    echo -e "SELECTED_MAP=\"$map\"" >> ".game_config"

    # get text content
    text="$(echo "$RESPONSE" | tail -n 1 | jq -r '.text')"

    pretty_print "${text%.}: ${map%.json}" "${NEXT_STEP["enter"]}"
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

    # parse RESPONSE into ROOM_INFO
    parse_room_info

    # save new room id to .game_config ROOM_ID
    echo "ROOM_ID=${ROOM_INFO["id"]}" >> ".game_config"

    # prepare relevant text in TEXT_TO_PRINT
    prepare_room_info

    # print info
    pretty_print "You have entered the first room" "${TEXT_TO_PRINT[@]}"
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

    # parse RESPONSE into ROOM_INFO
    parse_room_info

    # check if exit from maze was found, and prepare relevant text in TEXT_TO_PRINT
    prepare_room_info

    # print info
    pretty_print "${TEXT_TO_PRINT[@]}"
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

    # parse RESPONSE into ROOM_INFO
    parse_room_info

    # save new room id to .game_config ROOM_ID
    echo "ROOM_ID=${ROOM_INFO["id"]}" >> ".game_config"

    # check if exit from maze was found, and prepare relevant text in TEXT_TO_PRINT
    prepare_room_info

    # print info
    pretty_print "${TEXT_TO_PRINT[@]}"
}
