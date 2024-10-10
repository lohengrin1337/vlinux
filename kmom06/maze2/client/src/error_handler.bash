#!/usr/bin/env bash

##
## Error handling for mazerunner cli
##



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