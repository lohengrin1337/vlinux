#!/usr/bin/env bash

##
## Function to request log-server
##



#
# request log-server at specified route
# curl options: silent mode, include error from curl
#
function request_log_server
{
    route="$1"
    url="${BASE_URL}${route}"

    # # request server, save response, and handle possible error from curl
    # if ! RESPONSE="$(curl -isS "$url" 2>&1)"; then
    #     curl_error "$url"
    # fi

    # request server, save response, and handle possible error from curl
    if ! RESPONSE="$(curl -sS "$url" 2>&1)"; then
        curl_error "$url"
    fi

    export RESPONSE
}
