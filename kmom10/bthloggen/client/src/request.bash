#!/usr/bin/env bash

##
## Function to request log-server
##



#
# request log-server at specified route
# curl options: include header, silent mode, include error from curl
#
function request_log_server
{
    route="$1"
    url="${BASE_URL}${route}"

    echo -e "\n*** requesting $url ***\n"

    # request server, save response, and handle possible error from curl
    if ! curl -isS "$url" &> "$RESPONSE_TEMP"; then
        curl_error "$url"
    fi

    # echo -e "\n*** RESPONSE_TEMP:\n$(cat "$RESPONSE_TEMP")\n***\n"

    # check response is OK
    if ! response_is_ok; then
        response_error "$url"
    fi

    echo -e "\n*** Response = OK ***\n"

    # remove header from response, leave json body (last line)
    sed -i '$!d' "$RESPONSE_TEMP"

    # convert one-line json string to valid formated json
    temp=$(mktemp)
    jq -r . "$RESPONSE_TEMP" > "$temp"
    mv "$temp" "$RESPONSE_TEMP"
}
