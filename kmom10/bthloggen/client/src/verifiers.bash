#!/usr/bin/env bash

##
## Verifying functions for mazerunner cli
##



#
# check if response is OK (code 200 = 0 = true)
#
function response_is_ok
{
    # use grep to match '200' in top line of header
    # echo "$RESPONSE" | head -n 1 | grep -E "\b200\b" &> "/dev/null"

    head -n 1 "$RESPONSE_TEMP" | grep -E "\b200\b" &> "/dev/null"
}



#
# check if GAME_ID is set
#
function game_exists
{
    [[ -n $GAME_ID ]]
}



#
# check map is selected
#
function map_is_selected
{
    [[ -n $SELECTED_MAP ]]
}



#
# check if a selected map is valid (user input)
#
function map_selection_is_valid
{
    local number="$1"
    regex_positive_int="^[0-9]+$"
    map_count="$( wc -w <<< "$MAPS_AVAILABLE" )"

    # check number argument is valid (integer between 1 and map count)
    [[ $number =~ $regex_positive_int && $number -ge 1 && $number -le $map_count ]]
}



#
# check direction is valid (user input)
#
function direction_is_valid
{
    valid_directions=" north east south west "
    direction="$1"
    regex="[[:space:]]${direction}[[:space:]]"

    # use the direction (user input) in regex, to match a valid direction
    [[ $valid_directions =~ $regex ]]
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
# Check if the exit of the maze is found
#
function exit_is_found
{
    [[ ${ROOM_INFO["description"]} = "You found the exit" ]]
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
# Verify number (select <num>) refers to an existing map
#
function verify_map_exists
{
    local number="$1"

    # count maps
    map_count="$( wc -w <<< "$MAPS_AVAILABLE" )"

    # check that at least one map is available
    [[ $map_count -lt 1 ]] && \
        pretty_print -red "No maps were currently available!" && exit 1

    # check for empty or invalid number argument
    if ! map_selection_is_valid "$number"; then
        badUsage "$number" "Argument for 'select' has to be an integer in the range 1-$map_count!"
    fi
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
# verify direction is valid, else exit with message
#
function verify_direction
{
    direction="$1"

    # use the direction (user input) in regex, to match a valid direction
    if ! direction_is_valid "$direction"; then
        msg="${2:-"Invalid direction '$direction'"}"
        pretty_print -red "$msg"
        exit 1
    fi
}
