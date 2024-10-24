#!/usr/bin/env bash

##
## Functions to request log-server, and check response
##



#
# request log-server at specified route (plus query)
# curl options: include header, silent mode, include error from curl
# 
#
function request_log_server
{
    route="$1"
    url="${BASE_URL}${route}"

    # request server, save response, and handle possible error from curl
    if ! curl -isS "$url" &> "$RESPONSE_TEMP"; then
        curl_error "$url"
    fi

    # check response is OK
    if ! response_is_ok; then
        response_error "$url"
    fi

    # remove header from response, leave json body (last line)
    sed -i '$!d' "$RESPONSE_TEMP"
}
