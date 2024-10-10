#!/usr/bin/env bash

##
## Function to request maze-server for mazerunner cli
##



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
