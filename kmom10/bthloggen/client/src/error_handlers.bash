#!/usr/bin/env bash

##
## Error handling for log client
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
        "$0 --help"
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
        "Request to server failed"
        "$(cat "$RESPONSE_TEMP")"
        "Tip: '$0 use log-server'"
    )

    pretty_print -red "${txt[@]}"
    exit 1
}



#
# handle response error
#
function response_error
{
    local code url detail txt

    url="$1"

    # parse code from header, and detail from body
    code="$(head -n 1 "$RESPONSE_TEMP" | grep -Eo "[0-9]{3}")"
    body="$( tail -n 1 "$RESPONSE_TEMP")"

    case "$detail" in
        ( "Not Found" )
            txt+=(
                "Log-server: Page Not Found"
                "Requested resource: '$url'"
            )
        ;;

        ( * )
            txt+=(
                "Something went wrong!"
                "Make sure './data/log.json' is in place"
                "Requested resource: '$url'"
                "Response code: $code"
                "Body: $body"
            )
    esac

    txt+=("Print help with '$SCRIPT --help'")

    pretty_print -red "${txt[@]}"
    exit 1
}
