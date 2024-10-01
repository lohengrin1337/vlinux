#!/usr/bin/env bash

##
## Core functions for mazerunner cli
##

#
# init game, and save id to 'game_id'
#
function app_init
{
    # # request '/' (header and body(csv), silent, include error from curl)
    # url="$BASE_URL/$TO_CSV"
    # if ! res="$(curl -isS "$url")"; then
    #     curl_error "$url" "$res"
    # fi

    # request '/'
    request_maze_server "/"

    # check response is 200
    if ! response_is_ok; then
        response_error
    fi

    # get game id from body
    game_id="$(echo "$RESPONSE" | tail -n 1 | grep -Ewo "[0-9]{5}")"

    # save game id to global GAME_ID in .game_config
    echo "GAME_ID=$game_id" > ".game_config"    # replace any earlier content (fresh game)

    pretty_print \
        "A new game is created with id: $game_id" \
        "NEXT STEP: show maps with '$SCRIPT maps'"

    # echo "A new game is created with id: $game_id"
    # echo "NEXT STEP: show maps with '$SCRIPT maps'"
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

    # request '/<game_id>/maze/<room_id>' (header and body (json), silent, include error from curl)
    url="${BASE_URL}/${GAME_ID}/maze/${ROOM_ID}"
    if ! res="$( curl -isS "$url" )"; then
        curl_error "$url" "$res"
    fi

    # check response code is 200
    verify_response "$res" "Unable to get info!"

    # get body part
    body="$( echo "$res" | tail -n 1 )"

    # use jq to parse json
    room_id="$( echo "$body" | jq -r .roomid )"
    description="$( echo "$body" | jq -r .description )"

    # get the available directions (eg. has a room number, and not a '-')
    valid_directions=($(echo "$body" | jq -r '.directions | to_entries[] | select(.value != "-") | .key'))

    # save room id to .game_config ROOM_ID
    # echo "ROOM_ID=$room_id" >> ".game_config"

    # print info
    echo "Description: $description"
    echo "You find doors in the following directions: ${valid_directions[*]}"
    echo "NEXT STEP: enter an adjecent room with './$SCRIPT go <direction>'"
}

#
# enter new room (if possible), and save ROOM_ID to .game_config
#
function app_go
{
    # exit and inform user to init game, if GAME_ID is undefined
    verify_game_exists

    # check argument is one of four valid directions
    direction="$1"
    verify_direction "$direction"

    # request '/<game_id>/maze/<room_id>/<direction>' (header and body (json), silent, include error from curl)
    url="${BASE_URL}/${GAME_ID}/maze/${ROOM_ID}/${direction}"
    if ! res="$( curl -isS "$url" )"; then
        curl_error "$url" "$res"
    fi

    # get body part
    body="$( echo "$res" | tail -n 1 )"

    # use jq to parse json
    room_id="$( echo "$body" | jq -r .roomid )"
    description="$( echo "$body" | jq -r .description )"

    # get the available directions (eg. has a room number, and not a '-')
    valid_directions=($(echo "$body" | jq -r '.directions | to_entries[] | select(.value != "-") | .key'))

    # save new room id to .game_config ROOM_ID
    echo "ROOM_ID=$room_id" >> ".game_config"

    # print info
    echo "Description: $description"
    echo "You find doors in the following directions: ${valid_directions[*]}"
    echo "NEXT STEP: enter an adjecent room with './$SCRIPT go <direction>'"
}
